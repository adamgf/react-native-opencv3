// @author Adam G. Freeman - adamgf@gmail.com
package org.opencv.reactnative;

import com.facebook.react.uimanager.ThemedReactContext;
//import com.facebook.react.uimanager.ViewGroupManager;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.annotations.ReactProp;

public class CvCameraViewManager extends SimpleViewManager<CvCameraView> {
    @Override
    public String getName() {
        return "AndroidCameraView";
    }

    @Override
    protected CvCameraView createViewInstance(ThemedReactContext reactContext) {
        return new CvCameraView(reactContext, -1);
    }

    @ReactProp(name = "type")
    public void setType(CvCameraView view, String type) {
        view.changeCameraType(type.equals("front") ? 1 : 2);
    }
}
