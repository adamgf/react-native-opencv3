// @author Adam G. Freeman - adamgf@gmail.com
package org.opencv.reactnative;

import com.facebook.react.uimanager.ThemedReactContext;
//import com.facebook.react.uimanager.ViewGroupManager;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.bridge.ReadableArray;

public class CvCameraViewManager extends SimpleViewManager<CvCameraView> {

    @Override
    public String getName() {
        return "CvCameraView";
    }

    @Override
    protected CvCameraView createViewInstance(ThemedReactContext reactContext) {
        return new CvCameraView(reactContext, -1);
    }

    @ReactProp(name = "facing")
    public void setFacing(CvCameraView view, String facing) {
        view.changeFacing(facing.equals("front") ? 1 : -1);
    }

    @ReactProp(name = "functions")
    public void setFunctions(CvCameraView view, ReadableArray functions) {
        view.setFunctions(functions);
    }

    @ReactProp(name = "paramsArr")
    public void setParamsArr(CvCameraView view, ReadableArray paramsArr) {
        view.setParamsArr(paramsArr);
    }

    @ReactProp(name = "cascadeClassifier")
    public void setCascadeClassifier(CvCameraView view, String cascadeClassifier) {
        view.setCascadeClassifier(cascadeClassifier);
    }
}
