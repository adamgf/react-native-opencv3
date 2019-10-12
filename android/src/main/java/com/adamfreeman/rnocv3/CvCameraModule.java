// @author Adam G. Freeman - adamgf@gmail.com
package com.adamfreeman.rnocv3;

import android.hardware.Camera;
import android.util.Log;

import com.facebook.react.uimanager.NativeViewHierarchyManager;
import com.facebook.react.uimanager.UIManagerModule;
import com.facebook.react.uimanager.UIBlock;
import com.facebook.react.bridge.ReadableMap;
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
        return "CvCameraModule";
    }

    private ReadableMap mVideoOptions;
	
    @ReactMethod
    public void takePicture(final ReadableMap options, final int viewTag, final Promise promise) {
      final ReactApplicationContext context = getReactApplicationContext();
      UIManagerModule uiManager = context.getNativeModule(UIManagerModule.class);
      uiManager.addUIBlock(new UIBlock() {
          @Override
          public void execute(NativeViewHierarchyManager nativeViewHierarchyManager) {
              CvCameraView cameraView = (CvCameraView) nativeViewHierarchyManager.resolveView(viewTag);
              try {				  
			      TakePicBlock takePicBlock = new TakePicBlock(options, promise);
                  cameraView.takePicture(takePicBlock);
              } 
		      catch (Exception e) {
                  promise.reject("E_CAMERA_BAD_VIEWTAG", "takePicture: Expected a Camera component");
              }
          }
      });
    }

    @ReactMethod
    public void initCamera(final int viewTag, final Promise promise) {
        final ReactApplicationContext context = getReactApplicationContext();
        UIManagerModule uiManager = context.getNativeModule(UIManagerModule.class);
        uiManager.addUIBlock(new UIBlock() {
            @Override
            public void execute(NativeViewHierarchyManager nativeViewHierarchyManager) {
                CvCameraView cameraView = (CvCameraView) nativeViewHierarchyManager.resolveView(viewTag);
                try {
                    InitCameraBlock initCameraBlock = new InitCameraBlock(cameraView, promise);
                    cameraView.initCamera(initCameraBlock);
                }
                catch (Exception e) {
                    promise.reject("E_CAMERA_BAD_VIEWTAG", "initCamera: Expected a Camera component");
                }
            }
        });
    }

    @ReactMethod
    public void startRecording(final ReadableMap options, final int viewTag) {
      final ReactApplicationContext context = getReactApplicationContext();
      UIManagerModule uiManager = context.getNativeModule(UIManagerModule.class);
	  	  
      uiManager.addUIBlock(new UIBlock() {
          @Override
          public void execute(NativeViewHierarchyManager nativeViewHierarchyManager) {
              CvCameraView cameraView = (CvCameraView) nativeViewHierarchyManager.resolveView(viewTag);				
		      mVideoOptions = options;
              cameraView.startRecording(mVideoOptions);
          }
      });
    }
	
    @ReactMethod
    public void stopRecording(final int viewTag, final Promise promise) {
      final ReactApplicationContext context = getReactApplicationContext();
      UIManagerModule uiManager = context.getNativeModule(UIManagerModule.class);
      uiManager.addUIBlock(new UIBlock() {
        @Override
        public void execute(NativeViewHierarchyManager nativeViewHierarchyManager) {
            CvCameraView cameraView = (CvCameraView) nativeViewHierarchyManager.resolveView(viewTag);
            try {				  
                RecordVidBlock recordVidBlock = new RecordVidBlock(mVideoOptions, promise);
                cameraView.stopRecording(recordVidBlock);
            } 
		    catch (Exception e) {
                promise.reject("E_CAMERA_BAD_VIEWTAG", "stopRecording: Expected a Camera component");
            }
        }
      });
    }
}
