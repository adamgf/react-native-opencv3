// @author Adam G. Freeman - adamgf@gmail.com
package org.opencv.reactnative;

import android.hardware.Camera;
import android.util.Log;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

public class CvCameraModule extends ReactContextBaseJavaModule {

    private static final String TAG = CvCameraModule.class.getSimpleName();

    public CvCameraModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "AndroidCameraModule";
    }

    /**
    @ReactMethod
    public void capturePicture(final Promise promise) {
        CameraManager cameraManager = CameraManager.getInstance();
        takePicture(cameraManager.getCurrentCamera(), promise);
    }

    private void takePicture(Camera camera, final Promise promise) {
        if (camera == null) {
            promise.reject("CAMERA_NOT_FOUND");
            return;
        } */

/**
        camera.takePicture(null, null, new Camera.PictureCallback() {
            @Override
            public void onPictureTaken(byte[] data, Camera camera) {
                FileOutputStream fos = null;
                try {
                    File outputFile = ImageFileUtils.getImageOutputFile();
                    Log.d(TAG, outputFile.getAbsolutePath());
                    fos = new FileOutputStream(outputFile);
                    fos.write(data);
                    ImageFileUtils.addToGalleryAndNotify(getReactApplicationContext(), outputFile, promise);
                } catch (IOException e) {
                    e.printStackTrace();
                    promise.reject(e);
                } finally {
                    try {
                        fos.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }

                    camera.startPreview();
                }
            }
        });
    } */
}
