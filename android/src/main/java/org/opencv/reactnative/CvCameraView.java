// @author Adam G. Freeman - adamgf@gmail.com
package org.opencv.reactnative;

import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeArray;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.ReadableArray;
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
import org.opencv.core.Rect;
import org.opencv.core.Scalar;
import org.opencv.core.Core;
import org.opencv.core.CvType;
import org.opencv.core.Size;
import org.opencv.imgproc.Imgproc;
import org.opencv.android.CameraBridgeViewBase.CvCameraViewListener2;
import org.opencv.objdetect.CascadeClassifier;
import org.opencv.objdetect.Objdetect;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.File;
import java.lang.Runnable;

// useful for popping up an alert if need be ...
//import android.widget.Toast;

public class CvCameraView extends JavaCameraView implements CvCameraViewListener2 {

    private static final String TAG = CvCameraView.class.getSimpleName();

    private SurfaceHolder          mHolder;
    private ThemedReactContext     mContext;

    // params
    private ReadableArray          mFunctions;
    private ReadableArray          mParamsArr;
    private int                    mCameraFacing;
    private File                   mCascadeFile;

    private static final Scalar    FACE_RECT_COLOR     = new Scalar(255, 255, 0, 255);
    private CascadeClassifier      mJavaDetector;
    private boolean                mUseFaceDetection   = false;
    private float                  mRelativeFaceSize   = 0.2f;
    private int                    mAbsoluteFaceSize   = 0;
    private int                    mRotation = -1;

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

    public void setFunctions(ReadableArray functions) {
      Log.d(TAG, "In setFunctions functions is: " + functions.getString(0));
      this.mFunctions = functions;
    }

    public void setParamsArr(ReadableArray paramsArr) {
      Log.d(TAG, "In setParamsArr paramsArr is: " + paramsArr.getString(0));
      this.mParamsArr = paramsArr;
    }

    public void setCascadeClassifier(String cascadeClassifier) {
      try {
          mUseFaceDetection = true;

          // load cascade file from application resources
          InputStream is = mContext.getAssets().open(cascadeClassifier + ".xml");

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

          mCascadeFile = new File(cacheDir, cascadeClassifier + ".xml");
          FileOutputStream os = new FileOutputStream(mCascadeFile);

          byte[] buffer = new byte[4096];
          int bytesRead;
          while ((bytesRead = is.read(buffer)) != -1) {
              os.write(buffer, 0, bytesRead);
          }
          is.close();
          os.close();

          mJavaDetector = new CascadeClassifier(mCascadeFile.getAbsolutePath());
          if (mJavaDetector.empty()) {
              //MakeAToast("Failed to load cascade classifier: " + mCascadeFile.getAbsolutePath());
              Log.e(TAG, "Failed to load cascade classifier");
              mJavaDetector = null;
          }
          else {
              //MakeAToast("Loaded cascade classifier from " + mCascadeFile.getAbsolutePath());
              Log.i(TAG, "Loaded cascade classifier from " + mCascadeFile.getAbsolutePath());
          }

          mCascadeFile.delete();
      }
      catch (IOException ioe) {
          Log.e(TAG, "Failed to load cascade. IOException thrown: " + ioe.getMessage());
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
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.JPEG, quality, outputStream);

        try {
            return outputStream.toByteArray();
        } finally {
            try {
                outputStream.close();
            } catch (IOException e) {
                Log.e(TAG, "problem compressing jpeg", e);
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
          if (mAbsoluteFaceSize == 0) {
                int height = ingray.rows();
                if (Math.round(height * mRelativeFaceSize) > 0) {
                    mAbsoluteFaceSize = Math.round(height * mRelativeFaceSize);
                }
            }

            Imgproc.equalizeHist(ingray, ingray);
            rotateImage(ingray);

            //-- Detect faces
            MatOfRect faces = new MatOfRect();
            if (mJavaDetector != null && ingray != null)
                mJavaDetector.detectMultiScale(ingray, faces, 1.3, 5);
                //mJavaDetector.detectMultiScale(ingray, faces, 1.1, 2, 0|Objdetect.CASCADE_SCALE_IMAGE, new Size(mAbsoluteFaceSize, mAbsoluteFaceSize), new Size());

            Rect[] facesArray = faces.toArray();

            String faceInfo = "";
            if (facesArray.length > 0) {
                StringBuffer sb = new StringBuffer();
                sb.append("{\"faces\":[");
                for (int i = 0; i < facesArray.length; i++) {

                    double widthToUse = ingray.cols();
                    double heightToUse = ingray.rows();

                    double X0 = facesArray[i].tl().x;
                    double Y0 = facesArray[i].tl().y;
                    double X1 = facesArray[i].br().x;
                    double Y1 = facesArray[i].br().y;

                    double x = X0/widthToUse;
                    double y = Y0/heightToUse;
                    double w = (X1 - X0)/widthToUse;
                    double h = (Y1 - Y0)/heightToUse;

                    switch(mRotation) {
                      case Core.ROTATE_90_CLOCKWISE:
                          x = Y0/heightToUse;
                          y = 1.0 - X1/widthToUse;
                          w = (X1 - X0)/heightToUse;
                          h = (Y1 - Y0)/widthToUse;
                          break;
                      case Core.ROTATE_180:
                          x = 1.0 - X1/widthToUse;
                          y = 1.0 - Y1/heightToUse;
                          break;
                      case Core.ROTATE_90_COUNTERCLOCKWISE:
                          x = 1.0 - Y1/heightToUse;
                          y = X0/widthToUse;
                          w = (X1 - X0)/heightToUse;
                          h = (Y1 - Y0)/widthToUse;
                          break;
                      default:
                          break;
                    }

                    String id = "faceId" + i;
                    sb.append("{\"x\":"+x+",\"y\":"+y+",\"width\":"+w+",\"height\":"+h+",\"faceId\":\""+id+"\"}");
                    if (i != (facesArray.length - 1)) {
                      sb.append(",");
                    }
                    //good for testing ...
                    //Imgproc.rectangle(in, facesArray[i].tl(), facesArray[i].br(), FACE_RECT_COLOR, 3);
                }
                sb.append("]}");
                faceInfo = sb.toString();
            }
            WritableMap response = new WritableNativeMap();
            response.putString("payload", faceInfo);
            mContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
              .emit("onFacesDetected", response);
        }
        // hardcoded for right now to make sure it iw working ...
        // This is for CvInvoke outer tags ...
        //Log.d(TAG, "functions: " + this.functions.getString(0) + " paramsArr: " + this.paramsArr.getString(0));
        //Log.d(TAG, "functions: " + this.functions.getString(1) + " paramsArr: " + this.paramsArr.getString(1));
        //Log.d(TAG, "functions: " + this.functions.getString(2) + " paramsArr: " + this.paramsArr.getString(2));

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
        // AKA bowel movement!
        Bitmap bm = Bitmap.createBitmap(in.cols(), in.rows(), Bitmap.Config.ARGB_8888);
        Utils.matToBitmap(in, bm);
        //writeImage(bm);
        String encodedData = toBase64(bm, 60);
        WritableMap response = new WritableNativeMap();
        response.putString("payload", encodedData);
        mContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
          .emit("onCameraFrame", response);

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
