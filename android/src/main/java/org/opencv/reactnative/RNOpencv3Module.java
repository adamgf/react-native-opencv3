
// @author Adam G. Freeman - adamgf@gmail.com
package org.opencv.reactnative;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.ReadableNativeMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableType;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.support.v7.app.AppCompatActivity;
import android.os.Environment;
import android.util.Log;

import org.opencv.android.Utils;
import org.opencv.core.CvType;
import org.opencv.core.Mat;
import org.opencv.core.MatOfInt;
import org.opencv.core.MatOfFloat;
import org.opencv.core.Scalar;
import org.opencv.core.Point;
import org.opencv.imgproc.Imgproc.*;
import org.opencv.imgproc.Imgproc;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.FileNotFoundException;

import android.widget.Toast;

public class RNOpencv3Module extends ReactContextBaseJavaModule {

    private static final String TAG = RNOpencv3Module.class.getSimpleName();

    static {
        System.loadLibrary("opencv_java3");
    }

    private ReactApplicationContext reactContext;


    public RNOpencv3Module(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "RNOpencv3";
    }

    private void reject(Promise promise, String filepath, Exception ex) {
        if (ex instanceof FileNotFoundException) {
            rejectFileNotFound(promise, filepath);
            return;
        }

        promise.reject(null, ex.getMessage());
    }

    private void rejectFileNotFound(Promise promise, String filepath) {
        promise.reject("ENOENT", "ENOENT: no such file or directory, open '" + filepath + "'");
    }

    private void rejectFileIsDirectory(Promise promise, String filepath) {
        promise.reject("EISDIR", "EISDIR: illegal operation on a directory, open '" + filepath + "'");
    }

    private void rejectInvalidParam(Promise promise, String param) {
        promise.reject("EINVAL", "EINVAL: invalid parameter, read '" + param + "'");
    }

    private void MakeAToast(String message) {
        Toast.makeText(reactContext, message, Toast.LENGTH_LONG).show();
    }

    @ReactMethod
    public void drawLine(ReadableMap inMat, ReadableMap pt1, ReadableMap pt2, ReadableMap scalarVal, int thickness) {
        int matIndex = inMat.getInt("matIndex");
        Mat testMat = (Mat)MatManager.getInstance().matAtIndex(matIndex);
        double x1 = pt1.getDouble("x");
        double y1 = pt1.getDouble("y");
        double x2 = pt2.getDouble("x");
        double y2 = pt2.getDouble("y");
        Point p1 = new Point(x1,y1);
        Point p2 = new Point(x2,y2);
        Scalar dScalar = Scalar.all(255);
        Imgproc.line(testMat,p1,p2,dScalar,thickness);
        MatManager.getInstance().setMat(matIndex, testMat);
    }

    @ReactMethod
    public void imageToMat(String inPath, final Promise promise) {
        try {
            if (inPath == null || inPath.length() == 0) {
                rejectInvalidParam(promise, inPath);
                return;
            }

            java.io.File inFileTest = new java.io.File(inPath);
            if(!inFileTest.exists()) {
                rejectFileNotFound(promise, inPath);
                return;
            }
            if (inFileTest.isDirectory()) {
                rejectFileIsDirectory(promise, inPath);
                return;
            }

            Bitmap bitmap = BitmapFactory.decodeFile(inPath);
            if (bitmap == null) {
                throw new IOException("Decoding error unable to decode: " + inPath);
            }
            Mat img = new Mat(bitmap.getWidth(), bitmap.getHeight(), CvType.CV_8UC4);
            Utils.bitmapToMat(bitmap, img);
            int matIndex = MatManager.getInstance().addMat(img);

            WritableNativeMap result = new WritableNativeMap();
            result.putInt("cols", img.cols());
            result.putInt("rows", img.rows());
            result.putInt("matIndex", matIndex);
            promise.resolve(result);
        }
        catch (Exception ex) {
            reject(promise, "EGENERIC", ex);
        }
    }

    @ReactMethod
    public void matToImage(ReadableMap srcMat, String outPath, final Promise promise) {
        try {
            if (outPath == null || outPath.length() == 0) {
                // TODO: if no path sent in then auto-generate??!!!?
                rejectInvalidParam(promise, outPath);
                return;
            }

            int matIndex = srcMat.getInt("matIndex");
            Mat mat = (Mat)MatManager.getInstance().matAtIndex(matIndex);
            Bitmap bm = Bitmap.createBitmap(mat.cols(), mat.rows(), Bitmap.Config.ARGB_8888);
            Utils.matToBitmap(mat, bm);

            int width = bm.getWidth();
            int height = bm.getHeight();

            FileOutputStream file = new FileOutputStream(outPath);

            if (file != null) {
                String fileType = "";
                int i = outPath.lastIndexOf('.');
                if (i > 0) {
                    fileType = outPath.substring(i+1).toLowerCase();
                }
                else {
                    rejectInvalidParam(promise, outPath);
                    file.close();
                    return;
                }

                if (fileType.equals("png")) {
                    bm.compress(Bitmap.CompressFormat.PNG, 100, file);
                }
                else if (fileType.equals("jpg") || fileType.equals("jpeg")) {
                    bm.compress(Bitmap.CompressFormat.JPEG, 92, file);
                }
                else {
                    rejectInvalidParam(promise, outPath);
                    file.close();
                    return;
                }
                file.close();
            }
            else {
                rejectFileNotFound(promise, outPath);
                return;
            }

            WritableNativeMap result = new WritableNativeMap();
            result.putInt("width", width);
            result.putInt("height", height);
            result.putString("uri", outPath);
            promise.resolve(result);
        }
        catch (Exception ex) {
            reject(promise, "EGENERIC", ex);
        }
    }

    @ReactMethod
    public void cvtColor(ReadableMap sourceMat, ReadableMap destMat, int convColorCode) {
        int srcMatIndex = sourceMat.getInt("matIndex");
        int dstMatIndex = destMat.getInt("matIndex");

        Mat srcMat = (Mat)MatManager.getInstance().matAtIndex(srcMatIndex);
        Mat dstMat = (Mat)MatManager.getInstance().matAtIndex(dstMatIndex);

        Imgproc.cvtColor(srcMat, dstMat, convColorCode);
        MatManager.getInstance().setMat(dstMatIndex, dstMat);
    }

    @ReactMethod
    public void invokeMethods(ReadableMap cvInvokeMap) {
        CvInvoke invoker = new CvInvoke();
        int dstMatIndex = invoker.invokeCvMethods(cvInvokeMap);
        String callback = invoker.callback;
        sendCallbackData(dstMatIndex, callback);
    }

    public void sendCallbackData(int dstMatIndex, String callback) {
        if (callback != null && !callback.equals("") && dstMatIndex >= 0 && dstMatIndex < 1000) {
            // not sure how this should be handled yet for different return objects ...
            Mat dstMat = (Mat)MatManager.getInstance().matAtIndex(dstMatIndex);
            WritableArray retArr = MatManager.getInstance().getMatData(0, 0, dstMatIndex);
            WritableMap response = new WritableNativeMap();
            response.putArray("payload", retArr);
            reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(callback, response);
        }
        else {
            // not necessarily error condition unless dstMatIndex >= 1000
            if (dstMatIndex == 1000) {
                Log.e(TAG, "SecurityException thrown attempting to invoke method.  Check your method name and parameters and make sure they are correct.");
            }
            else if (dstMatIndex == 1001) {
                Log.e(TAG, "IllegalAccessException thrown attempting to invoke method.  Check your method name and parameters and make sure they are correct.");
            }
            else if (dstMatIndex == 1002) {
                Log.e(TAG, "InvocationTargetException thrown attempting to invoke method.  Check your method name and parameters and make sure they are correct.");
            }
        }
    }

    @ReactMethod
    public void invokeMethodWithCallback(String func, ReadableMap params, String callback) {
        int dstMatIndex = (new CvInvoke()).invokeCvMethod(func, params);
        sendCallbackData(dstMatIndex, callback);
    }

    @ReactMethod
    public void invokeMethod(String func, ReadableMap params) {
        (new CvInvoke()).invokeCvMethod(func, params);
    }

    private void resolveMatPromise(int rows, int cols, int cvtype, int matIndex, final Promise promise) {
        WritableNativeMap result = new WritableNativeMap();
        result.putInt("rows", rows);
        result.putInt("cols", cols);
        if (cvtype != -1) {
            result.putInt("CvType", cvtype);
        }
        result.putInt("matIndex", matIndex);
        promise.resolve(result);
    }

    @ReactMethod
    public void MatWithScalar(int rows, int cols, int cvtype, ReadableMap scalarMap, final Promise promise) {
        ReadableArray scalarVal = scalarMap.getArray("vals");
        //MakeAToast("Scalar values are: " + scalarVal.getDouble(0) + "," + scalarVal.getDouble(1) + "," + scalarVal.getDouble(2) + "," + scalarVal.getDouble(3)  );
        Scalar dScalar = new Scalar(scalarVal.getDouble(0),scalarVal.getDouble(1),
          scalarVal.getDouble(2),scalarVal.getDouble(3));
        int matIndex = MatManager.getInstance().createMat(cols, rows, cvtype, dScalar);
        resolveMatPromise(rows, cols, cvtype, matIndex, promise);
    }

    @ReactMethod
    public void MatWithParams(int rows, int cols, int cvtype, final Promise promise) {
        int matIndex = MatManager.getInstance().createMat(cols, rows, cvtype, null);
        resolveMatPromise(rows, cols, cvtype, matIndex, promise);
    }

    @ReactMethod
    public void Mat(final Promise promise) {
        int matIndex = MatManager.getInstance().createEmptyMat();
        resolveMatPromise(0, 0, -1, matIndex, promise);
    }

    @ReactMethod
    public void getMatData(ReadableMap mat, int rownum, int colnum, final Promise promise) {
        promise.resolve(MatManager.getInstance().getMatData(mat.getInt("matIndex"), rownum, colnum));
    }

    // TODO: not sure if this code should be moved to MatManager
    @ReactMethod
    public void setTo(ReadableMap mat, ReadableMap cvscalar) {
        MatManager.getInstance().setTo(mat.getInt("matIndex"), cvscalar);
    }

    // TODO: ditto previous
    @ReactMethod
    public void put(ReadableMap mat, int rownum, int colnum, ReadableArray data) {
        MatManager.getInstance().put(mat.getInt("matIndex"), rownum, colnum, data);
    }

    @ReactMethod
    public void transpose(ReadableMap mat) {
        MatManager.getInstance().transpose(mat.getInt("matIndex"));
    }

    @ReactMethod
    public void deleteMat(ReadableMap mat) {
        MatManager.getInstance().deleteMatAtIndex(mat.getInt("matIndex"));
    }

    @ReactMethod
    public void deleteMats() {
        MatManager.getInstance().deleteAllMats();
    }

    @ReactMethod
    public void MatOfInt(int matInt, final Promise promise) {
        int matIndex = MatManager.getInstance().createMatOfInt(matInt);
        WritableNativeMap result = new WritableNativeMap();
        result.putInt("matIndex", matIndex);
        promise.resolve(result);
    }

    @ReactMethod
    public void MatOfFloat(float lomatfloat, float himatfloat, final Promise promise) {
        int matIndex = MatManager.getInstance().createMatOfFloat(lomatfloat, himatfloat);
        WritableNativeMap result = new WritableNativeMap();
        result.putInt("matIndex", matIndex);
        promise.resolve(result);
    }
}
