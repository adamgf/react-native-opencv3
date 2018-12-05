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
import org.opencv.android.CameraBridgeViewBase.CvCameraViewListener2;

import java.io.ByteArrayOutputStream;
import java.io.IOException;

// useful for popping up an alert if needed ...
//import android.widget.Toast;

public class CvCameraView extends JavaCameraView implements CvCameraViewListener2 {

    private static final String TAG = CvCameraView.class.getSimpleName();

    private SurfaceHolder mHolder;
    private ThemedReactContext mContext;
    private ReadableArray functions;
    private ReadableArray paramsArr;

    public CvCameraView(ThemedReactContext context, int cameraId) {
      super( context, cameraId);
      Log.d(TAG, "Creating and setting view");
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
            Log.d(TAG, "In surfaceChanged surface is null ...");
            // preview surface does not exist
            return;
        }

        try {
            this.enableView();
        }
        catch (Exception e){
            Log.d("CameraPreview", "Error enabling camera preview: " + e.getMessage());
        }
    }

    // TODO: not sure if this is the right place for this ...
    public void changeCameraType(int type) {
        //if(mCameraType != type) {
        //    mCameraType = type;
            // TODO: restart camera preview
        //}
    }

    public void setFunctions(ReadableArray functions) {
      Log.d(TAG, "In setFunctions functions is: " + functions.getString(0));
      this.functions = functions;
    }

    public void setParamsArr(ReadableArray paramsArr) {
      Log.d(TAG, "In setParamsArr paramsArr is: " + paramsArr.getString(0));
      this.paramsArr = paramsArr;
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

    public Mat onCameraFrame(CvCameraViewFrame inputFrame) {
        // TODO: map camera settings to OpenCV frame modifications here ...
        Mat in = inputFrame.rgba();
        Log.d(TAG, "functions: " + this.functions.getString(0) + " paramsArr: " + this.paramsArr.getString(0));

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
