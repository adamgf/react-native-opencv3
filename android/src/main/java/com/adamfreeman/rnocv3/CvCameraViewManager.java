// @author Adam G. Freeman - adamgf@gmail.com
package com.adamfreeman.rnocv3;

import com.facebook.react.uimanager.ThemedReactContext;
//import com.facebook.react.uimanager.ViewGroupManager;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.annotations.ReactProp;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.common.MapBuilder;

import java.util.Map;
import javax.annotation.Nullable;

import android.util.Log;

public class CvCameraViewManager extends SimpleViewManager<CvCameraView> {

    private static final String TAG = CvCameraViewManager.class.getSimpleName();

    public static final int CMD_OVERLAY_MAT = 1;

    @Override
    public String getName() {
        return "CvCameraView";
    }

    @Override
    protected CvCameraView createViewInstance(ThemedReactContext reactContext) {
        return new CvCameraView(reactContext, -1);
    }

    @Override
    public Map<String,Integer> getCommandsMap() {
     Log.d(TAG, "View manager getCommandsMap:");
     return MapBuilder.of(
       "setOverlay",
       CMD_OVERLAY_MAT);
    }

    @Override
    public void receiveCommand(CvCameraView view, int commandType, @Nullable ReadableArray args) {
        switch (commandType) {
            case CMD_OVERLAY_MAT: {
                view.setOverlay(args.getMap(0));
                return;
            }
            default:
                throw new IllegalArgumentException(String.format(
                    "Unsupported command %d received by %s.",
                    commandType,
                    getClass().getSimpleName()));

        }
    }

    @ReactProp(name = "facing")
    public void setFacing(CvCameraView view, String facing) {
        view.changeFacing(facing.equals("front") ? 1 : -1);
    }

    @ReactProp(name = "cvinvoke")
    public void setCvInvoke(CvCameraView view, ReadableMap cvinvoke) {
        view.setCvInvokeGroup(cvinvoke);
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

    @ReactProp(name = "overlayInterval")
    public void setOverlayInterval(CvCameraView view, int overlayInterval) {
        view.setOverlayInterval(overlayInterval);
    }

}
