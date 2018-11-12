// @author Adam G. Freeman - adamgf@gmail.com
package org.opencv.reactnative;

import android.view.SurfaceView;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.ViewGroupManager;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.annotations.ReactProp;
import org.opencv.android.CameraBridgeViewBase;
import org.opencv.android.JavaCameraView;

public class CameraViewManager extends SimpleViewManager<CameraPreview> {
    @Override
    public String getName() {
        return "AndroidCameraView";
    }

    @Override
    protected CameraPreview createViewInstance(ThemedReactContext reactContext) {
        return new CameraPreview(reactContext, -1);
    }

    @ReactProp(name = "type")
    public void setType(CameraPreview view, String type) {
        //view.changeCameraType(type.equals("front") ? 1 : 2);
    }
}
