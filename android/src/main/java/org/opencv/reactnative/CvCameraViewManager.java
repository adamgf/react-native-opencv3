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

    @ReactProp(name = "callbacks")
    public void setCallbacks(CvCameraView view, ReadableArray callbacks) {
        view.setCallbacks(callbacks);
    }

    @ReactProp(name = "faceClassifier")
    public void setFaceClassifier(CvCameraView view, String cascadeClassifier) {
        view.setCascadeClassifier(cascadeClassifier, whichOne.FACE_CLASSIFIER);
    }

    @ReactProp(name = "eyesClassifier")
    public void setEyesClassifier(CvCameraView view, String cascadeClassifier) {
        view.setCascadeClassifier(cascadeClassifier, whichOne.EYES_CLASSIFIER);
    }

    @ReactProp(name = "noseClassifier")
    public void setNoseClassifier(CvCameraView view, String cascadeClassifier) {
        view.setCascadeClassifier(cascadeClassifier, whichOne.NOSE_CLASSIFIER);
    }

    @ReactProp(name = "mouthClassifier")
    public void setMouthClassifier(CvCameraView view, String cascadeClassifier) {
        view.setCascadeClassifier(cascadeClassifier, whichOne.MOUTH_CLASSIFIER);
    }

    @ReactProp(name = "landmarksModel")
    public void setLandmarksModel(CvCameraView view, String landmarksModel) {
        view.setLandmarksModel(landmarksModel);
    }

}
