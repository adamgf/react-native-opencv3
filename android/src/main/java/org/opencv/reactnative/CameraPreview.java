// @author Adam G. Freeman - adamgf@gmail.com
package org.opencv.reactnative;

import android.content.Context;
import android.util.Log;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import org.opencv.android.JavaCameraView;

import org.opencv.android.CameraBridgeViewBase.CvCameraViewFrame;
import org.opencv.core.Mat;
import org.opencv.android.CameraBridgeViewBase.CvCameraViewListener2;
import android.widget.Toast;

public class CameraPreview extends JavaCameraView implements CvCameraViewListener2 {

    private static final String TAG = CameraPreview.class.getSimpleName();

    private SurfaceHolder mHolder;
    private Context mContext;

    public CameraPreview(Context context, int cameraId) {
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
        } catch (Exception e){
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

    public void onCameraViewStarted(int width, int height) {
      Log.d(TAG, "In onCameraViewStarted ... width is: " + width + " height is: " + height);
    }

    public void onCameraViewStopped() {
      Log.d(TAG, "In onCameraViewStopped ...");
      this.disableView();
    }

    public Mat onCameraFrame(CvCameraViewFrame inputFrame) {
        // TODO: map camera settings to OpenCV frame modifications here ...
        return inputFrame.rgba();
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
