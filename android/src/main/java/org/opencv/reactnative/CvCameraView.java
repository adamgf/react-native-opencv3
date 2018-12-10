// @author Adam G. Freeman - adamgf@gmail.com
package org.opencv.reactnative;

import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeArray;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import android.graphics.Bitmap;
import android.content.Context;
import android.util.Log;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.util.Base64;

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

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.File;

// useful for popping up an alert if need be ...
import android.widget.Toast;

public class CvCameraView extends JavaCameraView implements CvCameraViewListener2 {

    private static final String TAG = CvCameraView.class.getSimpleName();

    private SurfaceHolder          mHolder;
    private ThemedReactContext     mContext;

    // params
    private ReadableArray          mFunctions;
    private ReadableArray          mParamsArr;
    private int                    mCameraFacing;
    private File                   mCascadeFile;

    private static final Scalar    FACE_RECT_COLOR     = new Scalar(0, 255, 0, 255);
    private CascadeClassifier      mJavaDetector;
    private boolean                mUseFaceDetection   = false;
    private float                  mRelativeFaceSize   = 0.2f;
    private int                    mAbsoluteFaceSize   = 0;

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
            //releaseCamera();
            disableView();
            setCameraIndex(mCameraFacing);
            enableView();
            //initializeCamera(1080, 720);
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
            MakeAToast("Input stream is nullified!");
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

    private void MakeAToast(String message) {
      Toast.makeText(mContext, message, Toast.LENGTH_LONG).show();
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
          if (mAbsoluteFaceSize == 0) {
                int height = ingray.rows();
                if (Math.round(height * mRelativeFaceSize) > 0) {
                    mAbsoluteFaceSize = Math.round(height * mRelativeFaceSize);
                }
            }

            MatOfRect faces = new MatOfRect();
            if (mJavaDetector != null && ingray != null)
                mJavaDetector.detectMultiScale(ingray, faces, 1.1, 2, 2, // TODO: objdetect.CV_HAAR_SCALE_IMAGE
                    new Size(mAbsoluteFaceSize, mAbsoluteFaceSize), new Size());

            Rect[] facesArray = faces.toArray();
            for (int i = 0; i < facesArray.length; i++) {
                Imgproc.rectangle(in, facesArray[i].tl(), facesArray[i].br(), FACE_RECT_COLOR, 3);
            }
        }
        // hardcoded for right now to make sure it iw working ...
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
        String encodedData = toBase64(bm, 60);
        WritableMap response = new WritableNativeMap();
        response.putString("data", encodedData);
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
