// @author Adam G. Freeman - adamgf@gmail.com
package org.opencv.reactnative;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeArray;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableNativeMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import android.content.res.Configuration;
import android.graphics.Bitmap;
import android.content.Context;
import android.util.Log;
import android.view.Surface;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.WindowManager;
import android.util.Base64;
import android.app.Activity;
import android.hardware.SensorManager;
import android.view.OrientationEventListener;

import org.opencv.android.Utils;
import org.opencv.android.JavaCameraView;
import org.opencv.android.CameraBridgeViewBase.CvCameraViewFrame;
import org.opencv.core.Mat;
import org.opencv.core.MatOfRect;
import org.opencv.core.MatOfPoint2f;
import org.opencv.core.Point;
import org.opencv.core.Rect;
import org.opencv.core.Scalar;
import org.opencv.core.Core;
import org.opencv.core.CvType;
import org.opencv.core.Size;
import org.opencv.imgproc.Imgproc;
import org.opencv.android.CameraBridgeViewBase.CvCameraViewListener2;
import org.opencv.objdetect.CascadeClassifier;
import org.opencv.objdetect.Objdetect;
import org.opencv.face.Face;
import org.opencv.face.Facemark;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.File;
import java.lang.Runnable;
import java.util.ArrayList;

// useful for popping up an alert if need be ...
//import android.widget.Toast;

enum whichOne {
    FACE_CLASSIFIER,
    EYES_CLASSIFIER,
    NOSE_CLASSIFIER,
    MOUTH_CLASSIFIER
}

public class CvCameraView extends JavaCameraView implements CvCameraViewListener2 {

    private static final String TAG = CvCameraView.class.getSimpleName();

    private SurfaceHolder          mHolder;
    private ThemedReactContext     mContext;

    // params
    private ReadableMap            mCvInvokeGroup;
    private int                    mCameraFacing;
    private CascadeClassifier      mFaceClassifier;
    private CascadeClassifier      mEyesClassifier;
    private CascadeClassifier      mNoseClassifier;
    private CascadeClassifier      mMouthClassifier;
    private boolean                mSuckUpFrames; // snarf, scoop?
    private Facemark               mLandmarks;

    private static final Scalar    FACE_RECT_COLOR     = new Scalar(255, 255, 0, 255);
    private boolean                mUseLandmarks       = false;
    private boolean                mUseFaceDetection   = false;
    private float                  mRelativeFaceSize   = 0.2f;
    private int                    mAbsoluteFaceSize   = 0;
    private int                    mRotation           = -1;

    public CvCameraView(ThemedReactContext context, int cameraFacing) {
      super( context, cameraFacing);
      Log.d(TAG, "Creating and setting view");
      mCameraFacing = cameraFacing;
      mContext = context;

      this.setVisibility(SurfaceView.VISIBLE);
      this.setCvCameraViewListener(this);

      System.loadLibrary("opencv_java3");

      mHolder = getHolder();
      mHolder.addCallback(this);

      // this is for older devices might as well keep it in here ...
      mHolder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);

      OrientationEventListener orientationEventListener = new OrientationEventListener(mContext) {
            @Override
            public void onOrientationChanged(int rotation) {
              if (((rotation >= 0) && (rotation <= 45)) || (rotation > 315)) {
                  mRotation = Core.ROTATE_90_CLOCKWISE;
              }
              else if ((rotation > 45) && (rotation <= 135)) {
                  mRotation = Core.ROTATE_180;
              }
              else if((rotation > 135) && (rotation <= 225)) {
                  mRotation = Core.ROTATE_90_COUNTERCLOCKWISE;
              }
              else {
                  mRotation = -1;
              }
              Log.d(TAG, "orientation = " + mRotation);
            }
        };

        orientationEventListener.enable();
    }

    @Override
    public void surfaceCreated(SurfaceHolder holder) {
      super.surfaceCreated( holder);
      Log.d(TAG, "In surfaceCreated ...");
    }

    @Override
    public void surfaceChanged(SurfaceHolder holder, int format, int w, int h) {
        super.surfaceChanged( holder, format, w, h);

        Log.d(TAG, "In surfaceChanged ...");

        if (mHolder.getSurface() == null){
            Log.e(TAG, "In surfaceChanged surface is null ...");
            // preview surface does not exist
            return;
        }

        try {
            this.enableView();
        }
        catch (Exception e){
            Log.e("CameraPreview", "Error enabling camera preview: " + e.getMessage());
        }
    }

    // TODO: not sure if this is the right place for this ...
    public void changeFacing(int facing) {
        //MakeAToast("Camera facing is: " + facing);
        if (mCameraFacing != facing) {
            mCameraFacing = facing;
            // TODO: restart camera preview
            disableView();
            setCameraIndex(mCameraFacing);
            enableView();
        }
    }

    public void setCvInvokeGroup(ReadableMap cvinvoke) {
        Log.d(TAG, "In setCvInvoke cvinvoke is: " + cvinvoke.toString());
        this.mCvInvokeGroup = cvinvoke;
    }

    private File readClassifierFile(String cascadeClassifier) {
      File cascadeFile = null;
      try {
          // load cascade file from application resources
          InputStream is = mContext.getAssets().open(cascadeClassifier);

          if (is == null) {
              //MakeAToast("Input stream is nullified!");
              Log.e(TAG, "Input stream is nullified!");
          }

          //int res = mContext.getResources().getIdentifier("icon", "drawable", mContext.getPackageName());
          //MakeAToast("res is: " + res + " cascadeClassifier is: " + cascadeClassifier +
          //  " packageName is: " + mContext.getPackageName());
          //InputStream is = mContext.getResources().openRawResource(res);

          //File cascadeDir = mContext.getDir("cascade", mContext.MODE_PRIVATE);

          File cacheDir = mContext.getCacheDir();

          cascadeFile = new File(cacheDir, cascadeClassifier);
          FileOutputStream os = new FileOutputStream(cascadeFile);

          byte[] buffer = new byte[4096];
          int bytesRead;
          while ((bytesRead = is.read(buffer)) != -1) {
              os.write(buffer, 0, bytesRead);
          }
          is.close();
          os.close();
      }
      catch (java.io.IOException ioe) {
          Log.e(TAG, "Failed to load cascade. IOException thrown: " + ioe.getMessage());
      }
      finally {
          return cascadeFile;
      }
    }

    public void setLandmarksModel(String landmarksModel) {
        mUseLandmarks = true;
        File landmarksFile = readClassifierFile(landmarksModel + ".yaml");
        // setup landmarks detector
        mLandmarks = Face.createFacemarkLBF();
        //mLandmarks = Face.createFacemarkKazemi();
        mLandmarks.loadModel(landmarksFile.getAbsolutePath());
    }

    public void setCascadeClassifier(String cascadeClassifier, whichOne classifierType) {
        mUseFaceDetection = true;
        File cascadeFile = readClassifierFile(cascadeClassifier + ".xml");
        if (cascadeFile != null) {
            CascadeClassifier classifier = new CascadeClassifier(cascadeFile.getAbsolutePath());
            if (classifier.empty()) {
                //MakeAToast("Failed to load cascade classifier: " + mCascadeFile.getAbsolutePath());
                Log.e(TAG, "Failed to load cascade classifier");
                classifier = null;
            }
            else {
                //MakeAToast("Loaded cascade classifier from " + mCascadeFile.getAbsolutePath());
                Log.i(TAG, "Loaded classifier from " + cascadeFile.getAbsolutePath());
            }
            cascadeFile.delete();

            switch (classifierType) {
                case EYES_CLASSIFIER:
                    mEyesClassifier = classifier;
                    break;
                case NOSE_CLASSIFIER:
                    mNoseClassifier = classifier;
                    break;
                case MOUTH_CLASSIFIER:
                    mMouthClassifier = classifier;
                    break;
                default:
                case FACE_CLASSIFIER:
                    mFaceClassifier = classifier;
                    break;
            }
        }
    }

    public void onCameraViewStarted(int width, int height) {
        Log.d(TAG, "In onCameraViewStarted ... width is: " + width + " height is: " + height);
    }

    public void onCameraViewStopped() {
        Log.d(TAG, "In onCameraViewStopped ...");
        this.disableView();
    }

    private static byte[] toJpeg(Bitmap bitmap, int quality) throws OutOfMemoryError {
        ByteArrayOutputStream BAOS = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.JPEG, quality, BAOS);

        try {
            return BAOS.toByteArray();
        }
        finally {
            try {
                BAOS.close();
            }
            catch (IOException e) {
                Log.e(TAG, "In toJpeg problem compressing jpeg: ", e);
            }
        }
    }

    public String toBase64(Bitmap currentRepresentation, int jpegQualityPercent) {
        return Base64.encodeToString(toJpeg(currentRepresentation, jpegQualityPercent), Base64.NO_WRAP);
    }

    // Just use for testing ...
    //private void MakeAToast(String message) {
    //    Toast.makeText(mContext, message, Toast.LENGTH_LONG).show();
    //}

    private void rotateImage(Mat image) {
        if (mRotation != -1) {
            Core.rotate(image, image, mRotation);
        }
    }

    /** dummy function to write out files ...
    static int whatever = 0;
    private void writeImage(Bitmap bmp) {
        try {
        String file_path = android.os.Environment.getExternalStorageDirectory().getAbsolutePath() +
                          "/testimgs";
        File dir = new File(file_path);
        if(!dir.exists())
          dir.mkdirs();
        File file = new File(dir, "whatever" + whatever + ".jpg");
        whatever++;
        FileOutputStream fOut = new FileOutputStream(file);

        bmp.compress(Bitmap.CompressFormat.JPEG, 85, fOut);
        fOut.flush();
        fOut.close();
        }
        catch (Exception e) {
            // whatever ...
            e.printStackTrace();
        }
    }
     */
    private String getPartJSON(Mat dFace, String partKey, Rect part) {

        StringBuffer sb = new StringBuffer();
        if (partKey != null) {
          sb.append(",\"" + partKey + "\":");
        }

        double widthToUse = dFace.cols();
        double heightToUse = dFace.rows();

        double X0 = part.tl().x;
        double Y0 = part.tl().y;
        double X1 = part.br().x;
        double Y1 = part.br().y;

        double x = X0/widthToUse;
        double y = Y0/heightToUse;
        double w = (X1 - X0)/widthToUse;
        double h = (Y1 - Y0)/heightToUse;

        switch(mRotation) {
          case Core.ROTATE_90_CLOCKWISE:
              x = Y0/heightToUse;
              y = 1.0 - X1/widthToUse;
              w = (Y1 - Y0)/heightToUse;
              h = (X1 - X0)/widthToUse;
              break;
          case Core.ROTATE_180:
              x = 1.0 - X1/widthToUse;
              y = 1.0 - Y1/heightToUse;
              break;
          case Core.ROTATE_90_COUNTERCLOCKWISE:
              x = 1.0 - Y1/heightToUse;
              y = X0/widthToUse;
              w = (Y1 - Y0)/heightToUse;
              h = (X1 - X0)/widthToUse;
              break;
          default:
              break;
        }

        sb.append("{\"x\":"+x+",\"y\":"+y+",\"width\":"+w+",\"height\":"+h);
        if (partKey != null) {
          sb.append("}");
        }
        return sb.toString();
    }

    private Point rotatePoint(Mat dFace, Point pt) {
        double newX, newY;
        double widthToUse = dFace.cols();
        double heightToUse = dFace.rows();
        switch(mRotation) {
            case Core.ROTATE_90_CLOCKWISE:
                newX = pt.y/heightToUse;
                newY = 1.0 - pt.x/widthToUse;
                break;
            case Core.ROTATE_180:
                newX = 1.0 - pt.x/widthToUse;
                newY = 1.0 - pt.y/heightToUse;
                break;
            case Core.ROTATE_90_COUNTERCLOCKWISE:
                newX = 1.0 - pt.y/heightToUse;
                newY = pt.x/widthToUse;
                break;
            default:
                newX = pt.x/widthToUse;
                newY = pt.y/heightToUse;
                break;
        }
        return new Point(newX, newY);
    }

    private double calcDistance(double centerX, double centerY, double pointX, double pointY) {
        double distX = pointX - centerX;
        double distY = pointY - centerY;

        distX = (distX < 0.0) ? -distX : distX;
        distY = (distY < 0.0) ? -distY : distY;
        return (distX + distY);
    }

    public Mat onCameraFrame(CvCameraViewFrame inputFrame) {
        // TODO: map camera settings to OpenCV frame modifications here ...
        Mat in = inputFrame.rgba();

        Mat ingray = null;

        if (mUseFaceDetection) {
            ingray = inputFrame.gray();
        }

        if (mCameraFacing == 1) {
            Core.flip(in, in, 1);
            if (mUseFaceDetection) {
                Core.flip(ingray, ingray, 1);
            }
        }

        if (mUseFaceDetection) {

            Imgproc.equalizeHist(ingray, ingray);
            rotateImage(ingray);

            int height = ingray.rows();
            if (Math.round(height * mRelativeFaceSize) > 0) {
                mAbsoluteFaceSize = Math.round(height * mRelativeFaceSize);
            }

            //-- Detect faces
            MatOfRect faces = new MatOfRect();
            ArrayList<MatOfPoint2f> landmarks = new ArrayList<MatOfPoint2f>();
            boolean landmarksFound = false;
            if (mFaceClassifier != null && ingray != null) {
                if (mUseLandmarks) {
                    // more sensitive if determining landmarks
                    mFaceClassifier.detectMultiScale(ingray, faces, 1.3, 5, 0|Objdetect.CASCADE_SCALE_IMAGE, new Size(mAbsoluteFaceSize, mAbsoluteFaceSize), new Size());
                    mLandmarks.fit(ingray, faces, landmarks);
                    if (landmarks.size() > 0) {
                        landmarksFound = true;
                    }
                }
                else {
                    mFaceClassifier.detectMultiScale(ingray, faces, 1.1, 2, 0|Objdetect.CASCADE_SCALE_IMAGE, new Size(mAbsoluteFaceSize, mAbsoluteFaceSize), new Size());
                }
            }
            Rect[] facesArray = faces.toArray();

            String faceInfo = "";
            if (facesArray.length > 0) {
                StringBuffer sb = new StringBuffer();
                sb.append("{\"faces\":[");
                for (int i = 0; i < facesArray.length; i++) {
                    sb.append(getPartJSON(ingray, null, facesArray[i]));
                    String id = "faceId" + i;
                    sb.append(",\"faceId\":\""+id+"\"");

                    if (mEyesClassifier != null ||
                        mNoseClassifier != null ||
                        mMouthClassifier != null) {

                        Rect faceROI = facesArray[i];
                        Mat dFace = ingray.submat(faceROI);

                        if (mEyesClassifier != null) {
                            MatOfRect eyes = new MatOfRect();
                            mEyesClassifier.detectMultiScale(dFace, eyes, 1.1, 2);
                            //mEyesClassifier.detectMultiScale(dFace, eyes, 1.1, 2, 0|Objdetect.CASCADE_SCALE_IMAGE, new Size((double)dFaceW, (double)dFaceH), new Size());
                            Rect[] eyesArray = eyes.toArray();

                            int eye1Index = -1;
                            double centerX = 0.0;
                            double centerY = (double)facesArray[i].height*0.2;
                            if (eyesArray.length > 0) {
                                double minDist = 10000.0;
                                for(int j = 0; j < eyesArray.length; j++) {
                                    centerX = (double)facesArray[i].width*0.3;
                                    double eyeX = (double)eyesArray[j].x + (double)eyesArray[j].width*0.5;
                                    double eyeY = (double)eyesArray[j].y + (double)eyesArray[j].height*0.5;
                                    double dist = calcDistance(centerX, centerY, eyeX, eyeY);
                                    if (dist < minDist) {
                                        minDist = dist;
                                        eye1Index = j;
                                    }
                                }
                                sb.append(getPartJSON(dFace, "firstEye", eyesArray[eye1Index]));
                            }
                            if (eyesArray.length > 1) {
                                double minDist = 10000.0;
                                int eye2Index = -1;
                                for(int j = 0; j < eyesArray.length; j++) {
                                    centerX = (double)facesArray[i].width*0.7;
                                    double eyeX = (double)eyesArray[j].x + (double)eyesArray[j].width*0.5;
                                    double eyeY = (double)eyesArray[j].y + (double)eyesArray[j].height*0.5;
                                    double dist = calcDistance(centerX, centerY, eyeX, eyeY);
                                    if (dist < minDist && eye1Index != j) {
                                        minDist = dist;
                                        eye2Index = j;
                                    }
                                }
                                sb.append(getPartJSON(dFace, "secondEye", eyesArray[eye2Index]));
                            }
                        }

                        if (mNoseClassifier != null) {
                            MatOfRect noses = new MatOfRect();
                            mNoseClassifier.detectMultiScale(dFace, noses, 1.1, 2);
                            //mEyesClassifier.detectMultiScale(dFace, eyes, 1.1, 2, 0|Objdetect.CASCADE_SCALE_IMAGE, new Size((double)dFaceW, (double)dFaceH), new Size());
                            Rect[] nosesArray = noses.toArray();
                            if (nosesArray.length > 0) {
                                double minDist = 10000.0;
                                int noseIndex = -1;
                                for(int j = 0; j < nosesArray.length; j++) {
                                    double centerX = (double)facesArray[i].width*0.5;
                                    double centerY = (double)facesArray[i].height*0.5;
                                    double noseX = (double)nosesArray[j].x + (double)nosesArray[j].width*0.5;
                                    double noseY = (double)nosesArray[j].y + (double)nosesArray[j].height*0.5;
                                    double dist = calcDistance(centerX, centerY, noseX, noseY);
                                    if (dist < minDist) {
                                        minDist = dist;
                                        noseIndex = j;
                                    }
                                }
                                sb.append(getPartJSON(dFace, "nose", nosesArray[noseIndex]));
                            }
                        }

                        if (mMouthClassifier != null) {
                            Rect mouthROI = new Rect(0,(int)Math.round(dFace.rows()*0.6),dFace.cols(),(int)Math.round(dFace.rows()*0.4));
                            Mat dFaceForMouthDetecting = dFace.submat(mouthROI);

                            MatOfRect mouths = new MatOfRect();
                            mMouthClassifier.detectMultiScale(dFaceForMouthDetecting, mouths, 1.1, 2);
                            //mEyesClassifier.detectMultiScale(dFace, eyes, 1.1, 2, 0|Objdetect.CASCADE_SCALE_IMAGE, new Size((double)dFaceW, (double)dFaceH), new Size());
                            Rect[] mouthsArray = mouths.toArray();
                            if (mouthsArray.length > 0) {
                                double minDist = 10000.0;
                                int mouthIndex = -1;
                                for(int j = 0; j < mouthsArray.length; j++) {
                                    double centerX = (double)facesArray[i].width*0.5;
                                    double centerY = (double)facesArray[i].height*0.8;
                                    double mouthX = (double)mouthsArray[j].x + (double)mouthsArray[j].width*0.5;
                                    double mouthY = (double)mouthsArray[j].y + (double)mouthsArray[j].height*0.5 + (double)facesArray[i].height*0.6;
                                    double dist = calcDistance(centerX, centerY, mouthX, mouthY);
                                    if (dist < minDist) {
                                        minDist = dist;
                                        mouthIndex = j;
                                    }
                                }
                                Rect dRect = new Rect(mouthsArray[mouthIndex].x,(int)Math.round(mouthsArray[mouthIndex].y + dFace.rows()*0.6),mouthsArray[mouthIndex].width,mouthsArray[mouthIndex].height);
                                sb.append(getPartJSON(dFace, "mouth", dRect));
                            }
                        }
                    }
                    if (mUseLandmarks) {
                        // fit landmarks for each found face
                        if (landmarksFound) {
                            sb.append(",\"landmarks\":[");
                            // draw them
                            MatOfPoint2f lm = landmarks.get(i);
                            for (int j = 0; j < lm.rows(); j++) {
                                double[] dp = lm.get(j, 0);
                                Point thePt = new Point(dp[0], dp[1]);
                                Point newPt = rotatePoint(ingray, thePt);
                                sb.append("{\"x\":" + newPt.x + ",\"y\":" + newPt.y + "}");
                                if (j != lm.rows() - 1) {
                                    sb.append(",");
                                }
                                /** drawing test code ...
                                if (mRotation == Core.ROTATE_90_CLOCKWISE || mRotation == Core.ROTATE_90_COUNTERCLOCKWISE) {
                                    newPt.x *= ingray.rows();
                                    newPt.y *= ingray.cols();
                                }
                                else {
                                    newPt.x *= ingray.cols();
                                    newPt.y *= ingray.rows();
                                }
                                Point pt0 = new Point(newPt.x, newPt.y);
                                Point pt1 = new Point(newPt.x + 1.0, newPt.y + 1.0);
                                Imgproc.rectangle(in, pt0, pt1, FACE_RECT_COLOR, 1);
                                 */
                            }
                            sb.append("]");
                        }
                    }
                    if (i != (facesArray.length - 1)) {
                        sb.append("},");
                    }
                    else {
                        sb.append("}");
                    }
                }
                sb.append("]}");
                faceInfo = sb.toString();
            }
            WritableMap response = new WritableNativeMap();
            //Log.d(TAG, "payload is: " + faceInfo);
            response.putString("payload", faceInfo);
            mContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
              .emit("onFacesDetected", response);
        }

        if (mCvInvokeGroup != null) {
            Log.d(TAG, "Fuckin' mCvInvokeGroup is: " + mCvInvokeGroup.toString());
            CvInvoke.getInstance().rgba = in;
            CvInvoke.getInstance().grey = inputFrame.gray();
            CvInvoke.getInstance().invokeCvMethods(RNOpencv3Module.reactContext, mCvInvokeGroup);
        }
        // hardcoded for right now to make sure it iw working ...
        // This is for CvInvoke outer tags ...
        //Log.d(TAG, "functions: " + this.mFunctions.getString(0) + " paramsArr: " + this.mParamsArr.getMap(0).toString() + " callbacks: " + this.mCallbacks.getString(0));
        //Log.d(TAG, "functions: " + this.mFunctions.getString(1) + " paramsArr: " + this.mParamsArr.getMap(1).toString() + " callbacks: " + this.mCallbacks.getString(1));

        //String dMap = this.mParamsArr.getMap(1).toString();

        //ReadableMap secondObject = dMap.getMap("p2");
        //Log.d(TAG, "Mat index is: " + dMap);

        //Log.d(TAG, "functions: " + this.functions.getString(2) + " paramsArr: " + this.paramsArr.getString(2) + " callbacks: " + this.callbacks.getString(2));
        //Log.d(TAG, "functions: " + this.functions.getString(3) + " paramsArr: " + this.paramsArr.getString(3) + " callbacks: " + this.callbacks.getString(3));


        //Mat in1 = new Mat(src.rows(), src.cols(), CvType.CV_8UC4);
        /**
        int numRows = src.rows();
        int numCols = src.cols();
        //Core.transpose(in.t(), in);
        Mat flipEm = src.t();
        Mat in = new Mat();

        Core.flip(flipEm, in, 1);
        Size sz = new Size(numCols, numRows);
        Imgproc.resize( in, in, sz );

        MakeAToast("width is: " + in.cols() + " height is: " + in.rows());
         */

        //Core.flip(src.t(), src, 1);
        if (mSuckUpFrames) {
            // AKA bowel movement!
            Bitmap bm = Bitmap.createBitmap(in.cols(), in.rows(), Bitmap.Config.ARGB_8888);
            Utils.matToBitmap(in, bm);
            //writeImage(bm);
            String encodedData = toBase64(bm, 60);
            WritableMap response = new WritableNativeMap();
            response.putString("payload", encodedData);
            mContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit("onCameraFrame", response);
        }

        return in;
    }

    @Override
    protected boolean connectCamera(int width, int height) {
      boolean supVal = super.connectCamera( width, height);
      Log.d(TAG, "In connectCamera ...");
      return supVal;
    }

    /**
     * Disconnects and release the particular camera object being connected to this surface view.
     * Called when syncObject lock is held
     */
    @Override
    protected void disconnectCamera() {
      super.disconnectCamera( );
      Log.d(TAG, "In disconnectCamera ...");
    }
}
