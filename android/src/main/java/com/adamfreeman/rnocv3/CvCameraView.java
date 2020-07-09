// @author Adam G. Freeman - adamgf@gmail.com
package com.adamfreeman.rnocv3;

import com.facebook.react.bridge.Promise;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import android.Manifest;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.util.Log;
import android.view.SurfaceHolder;
import android.view.TextureView;
import android.util.Base64;
import android.view.OrientationEventListener;
import android.util.Log;
import androidx.core.content.ContextCompat;

import org.opencv.videoio.VideoWriter;
import org.opencv.android.Utils;
import org.opencv.android.JavaCameraView;
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
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.File;
import java.lang.Runnable;
import java.util.ArrayList;
import java.util.Timer;
import java.util.TimerTask;

enum whichOne {
    FACE_CLASSIFIER,
    EYES_CLASSIFIER,
    NOSE_CLASSIFIER,
    MOUTH_CLASSIFIER
}

class RecordVidBlock implements Runnable {

	ReadableMap options;
	int width;
	int height;
	Promise promise;
	
   	public RecordVidBlock(ReadableMap options, Promise promise) {
		this.options = options;
		this.promise = promise;
   	}
   
    public void setWidth(int width) {
        this.width = width;	
    }
	
    public void setHeight(int height) {
        this.height = height;	
    }
	
   	public void run() {
        WritableNativeMap result = new WritableNativeMap();
        result.putInt("width", width);
        result.putInt("height", height);
        result.putString("uri", options.getString("filename"));
        promise.resolve(result);
   	}
}

class TakePicBlock implements Runnable {

	Mat mat;
	ReadableMap options;
	Promise promise;
	
   	public TakePicBlock(ReadableMap options, Promise promise) {
		this.options = options;
		this.promise = promise;
   	}

   	public void setMat(Mat mat) {
	   this.mat = mat;
   	}
   
   	public void run() {
        FileUtils.getInstance().matToImage(mat, options.getString("filename"), promise);
   	}
}

class InitCameraBlock implements Runnable {

    Promise promise;
    CvCameraView cameraView;

    public InitCameraBlock(CvCameraView cameraView, Promise promise) {
        this.cameraView = cameraView;
        this.promise = promise;
    }

    public void run() {
        cameraView.setVisibility(TextureView.VISIBLE);

        if (this.promise != null) {
            WritableNativeMap result = new WritableNativeMap();
            result.putBoolean("cameraInitialized", true);
            promise.resolve(result);
        }
    }
}

public class CvCameraView extends JavaCameraView implements CvCameraViewListener2 {

    private static final String TAG = CvCameraView.class.getSimpleName();

    public  SurfaceHolder          mHolder;
    public  ThemedReactContext     mContext;

    // params
    private ReadableMap            mOverlay;
    private Mat                    mOverlayMat;
    private int                    mOverlayInterval = 0;
    private ReadableMap            mCvInvokeGroup;
    private int                    mCameraFacing;
    private CascadeClassifier      mFaceClassifier;
    private CascadeClassifier      mEyesClassifier;
    private CascadeClassifier      mNoseClassifier;
    private CascadeClassifier      mMouthClassifier;
    private boolean                mSuckUpFrames;
    private Facemark               mLandmarks;

    private static final Scalar    FACE_RECT_COLOR     = new Scalar(255, 255, 0, 255);
    private boolean                mUseLandmarks       = false;
    private boolean                mUseFaceDetection   = false;
    private boolean                mUpdateOverlay      = false;
    private boolean                mSendFrameSize      = true;
    private float                  mRelativeFaceSize   = 0.2f;
    private int                    mAbsoluteFaceSize   = 0;
    private int                    mRotation           = -1;
    private int                    mRecRotation        = -1;
    private long                   mCurrentMillis      = -1;
    private int                    mCurrOverlayIndex   = -1;
    private boolean				   mTakePicture	       = false;
	private TakePicBlock	       takePicBlock;
	private RecordVidBlock	       recordVidBlock;
	private InitCameraBlock        initCameraBlock;
	
	// video and audio recording stuff
	private VideoWriter 	       mVideoWriter        = null;
	private boolean	               mRecording          = false;
	private ReadableMap	   		   mVideoOptions;
	
    public CvCameraView(ThemedReactContext context, int cameraFacing) {
        super( context, cameraFacing);
        Log.d(TAG, "Creating and setting view");
        mCameraFacing = cameraFacing;
        mContext = context;

        this.setVisibility(TextureView.INVISIBLE);
        this.setCvCameraViewListener(this);

        System.loadLibrary("opencv_java3");

        mHolder = getHolder();
        mHolder.addCallback(this);

        // this is for older devices might as well keep it in here ...
        mHolder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);

        if (ContextCompat.checkSelfPermission(getContext(),
            	Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED) {
            this.initCameraBlock = new InitCameraBlock(this, null);
            this.initCameraBlock.run();
        }

        OrientationEventListener orientationEventListener = new OrientationEventListener(mContext) {
            @Override
            public void onOrientationChanged(int rotation) {
                if (((rotation >= 0) && (rotation <= 45)) || (rotation > 315)) {
                    mRotation = Core.ROTATE_90_CLOCKWISE;
                } else if ((rotation > 45) && (rotation <= 135)) {
                    mRotation = Core.ROTATE_180;
                } else if ((rotation > 135) && (rotation <= 225)) {
                    mRotation = Core.ROTATE_90_COUNTERCLOCKWISE;
                } else {
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
        if (mCameraFacing != facing) {
            mCameraFacing = facing;
            // TODO: restart camera preview
            disableView();
            setCameraIndex(mCameraFacing);
            enableView();
        }
    }

    public void setCvInvokeGroup(ReadableMap cvinvoke) {
        //Log.d(TAG, "In setCvInvoke cvinvoke is: " + cvinvoke.toString());
        this.mCvInvokeGroup = cvinvoke;
    }

    private File readClassifierFile(String cascadeClassifier) {
      File cascadeFile = null;
      try {
          // load cascade file from application resources
          InputStream is = mContext.getAssets().open(cascadeClassifier);

          if (is == null) {
              Log.e(TAG, "Input stream is nullified!");
          }

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

    public void setOverlay(ReadableMap overlay) {
        //Log.d(TAG, "About to set overlay.");
        if (overlay != null) {
            mOverlay = overlay;
            int matIndex = overlay.getInt("matIndex");
            Mat overlayMat = (Mat)MatManager.getInstance().matAtIndex(matIndex);
            if (mOverlayMat == null) {
                mOverlayMat = new Mat(overlayMat.rows(), overlayMat.cols(), CvType.CV_8UC4);
            }
            overlayMat.copyTo(mOverlayMat);
            Scalar clearColor = Scalar.all(0);
            overlayMat.setTo(clearColor);
            MatManager.getInstance().setMat(matIndex, overlayMat);
            mUpdateOverlay = true;
        }
    }

    public void setOverlayInterval(int overlayInterval) {
        this.mOverlayInterval = overlayInterval;
    }

    public void setLandmarksModel(String landmarksModel) {
        mUseLandmarks = true;
        File landmarksFile = readClassifierFile(landmarksModel + ".yaml");
        // setup landmarks detector
        mLandmarks = Face.createFacemarkLBF();
        mLandmarks.loadModel(landmarksFile.getAbsolutePath());
    }

    public void setCascadeClassifier(String cascadeClassifier, whichOne classifierType) {
        mUseFaceDetection = true;
        File cascadeFile = readClassifierFile(cascadeClassifier + ".xml");
        if (cascadeFile != null) {
            CascadeClassifier classifier = new CascadeClassifier(cascadeFile.getAbsolutePath());
            if (classifier.empty()) {
                Log.e(TAG, "Failed to load cascade classifier");
                classifier = null;
            }
            else {
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

    private void rotateImage(Mat image) {
        if (mRotation != -1) {
            Core.rotate(image, image, mRotation);
        }
    }

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
        Mat in = inputFrame.rgba();

        Mat ingray = inputFrame.gray();

        if (mCurrentMillis == -1) {
            mCurrentMillis = System.currentTimeMillis();
        }

        WritableMap fsResponse = new WritableNativeMap();
        //Log.d(TAG, "payload is: " + faceInfo);
        String frameSizeStr = "{\"frameSize\":{\"frameWidth\":" + (double)in.size().width + ",\"frameHeight\":" + (double)in.size().height + "}}";
        fsResponse.putString("payload", frameSizeStr);
        mContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
            .emit("onFrameSize", fsResponse);

        if (mCameraFacing == 1) {
            Core.flip(in, in, 1);
            Core.flip(ingray, ingray, 1);
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
                            //mEyesClassifier.detectMultiScale(dFace, eyes, 1.1, 2, 0|Objdetect.CASCADE_SCALE_IMAGE, new Size(dFaceW, dFaceH), new Size());
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
                            //mNoseClassifier.detectMultiScale(dFace, noses, 1.1, 2, 0|Objdetect.CASCADE_SCALE_IMAGE, new Size(dFaceW, dFaceH), new Size());
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
                            //mMouthClassifier.detectMultiScale(dFaceForMouthDetecting, mouths, 1.1, 2, 0|Objdetect.CASCADE_SCALE_IMAGE, new Size(dFaceW, dFaceH), new Size());
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
              .emit("onFacesDetectedCv", response);
        }

        boolean sendCallbackData = false;

        if (mCvInvokeGroup != null) {
            long currMillis = System.currentTimeMillis();
            long diff = (currMillis - mCurrentMillis);
            if (diff >= mOverlayInterval) {
                mCurrentMillis = currMillis;
		        CvInvoke invoker = new CvInvoke(in, ingray);
		        WritableArray responseArr = invoker.parseInvokeMap(mCvInvokeGroup);
		        String lastCall = invoker.callback;
				int dstMatIndex = invoker.dstMatIndex;
				// TODO: move this into RNOpencv3Util class ...
		        if (lastCall != null && !lastCall.equals("") && dstMatIndex >= 0 && dstMatIndex < 1000) {
		            WritableMap response = new WritableNativeMap();
		            response.putArray("payload", responseArr);
		            mContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
		                .emit(lastCall, response);
		        }
		        else {
		            // not necessarily error condition unless dstMatIndex >= 1000
		            if (dstMatIndex == 1000) {
		                Log.e(TAG, "SecurityException thrown attempting to invoke method.  Check your method name and parameters and make sure they are correct.");
		            }
		            else if (dstMatIndex == 1001) {
		                Log.e(TAG, "IllegalAccessException thrown attempting to invoke method.  Check your method name and parameters and make sure they are correct.");
		            }
		            else if (dstMatIndex == 1002) {
		                Log.e(TAG, "InvocationTargetException thrown attempting to invoke method.  Check your method name and parameters and make sure they are correct.");
		            }
		        }
            }
        }
		
        if (mOverlayMat != null) {
            Core.addWeighted(in, 1.0, mOverlayMat, 1.0, 0.0, in);
        }
		
		if (mTakePicture) {
			mTakePicture = false;
			this.takePicBlock.setMat(in);
			this.takePicBlock.run();
		}

        if (mRecording) {
		    if (mVideoWriter == null) {
                Size dSize = in.size();
				mRecRotation = mRotation;
				if (mRecRotation == Core.ROTATE_90_CLOCKWISE || mRecRotation == Core.ROTATE_90_COUNTERCLOCKWISE) {
				    dSize = new Size(in.size().height, in.size().width);
			    }
				
		        mVideoWriter = new VideoWriter(mVideoOptions.getString("filename"), VideoWriter.fourcc('M', 'J', 'P', 'G'), 30.0, dSize);
		    }
			Mat rotMat = new Mat();
			Core.rotate(in, rotMat, mRecRotation);
		    mVideoWriter.write(rotMat);
			rotMat.release();
		} 
		else {
			if (mVideoWriter != null) {
		    	mVideoWriter.release();
				mVideoWriter = null;
				if (mRecRotation == Core.ROTATE_90_CLOCKWISE || mRecRotation == Core.ROTATE_90_COUNTERCLOCKWISE) {
					recordVidBlock.setWidth((int)in.size().height);
					recordVidBlock.setHeight((int)in.size().width);
				}
				else {
					recordVidBlock.setWidth((int)in.size().width);
					recordVidBlock.setHeight((int)in.size().height);					
				}
				recordVidBlock.run();
		    }
		}
        
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

    public void initCamera(InitCameraBlock initCameraBlock) {
        this.initCameraBlock = initCameraBlock;
        this.initCameraBlock.run();
    }

    public void takePicture(TakePicBlock takePicBlock) {
        this.takePicBlock = takePicBlock;
		mTakePicture = true;
    }
	
	public void startRecording(ReadableMap options) {
		mVideoOptions = options;
		mRecording = true;
	}
	
	public void stopRecording(RecordVidBlock recordVidBlock) {
		this.recordVidBlock = recordVidBlock;
		mRecording = false;
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
