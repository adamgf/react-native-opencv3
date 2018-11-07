
// @author Adam G. Freeman - adamgf@gmail.com
package org.opencv.reactnative;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.WritableNativeMap;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.support.v7.app.AppCompatActivity;
import android.os.Environment;

import org.opencv.android.Utils;
import org.opencv.core.CvType;
import org.opencv.core.Mat;
import org.opencv.imgproc.Imgproc;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.FileNotFoundException;

public class RNOpencv3Module extends ReactContextBaseJavaModule {

    static {
        System.loadLibrary("opencv_java3");
    }

    private final ReactApplicationContext reactContext;

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

    /**
     * PUBLIC REACT API
     *
     *  cvtColorGray   Converts to grayscale png or jpeg image using OpenCV
     */
    @ReactMethod
    public void cvtColorGray(String inPath, String outPath, final Promise promise) {
        try {
            if (inPath == null || inPath.length() == 0) {
                rejectInvalidParam(promise, inPath);
                return;
            }
            if (outPath == null || outPath.length() == 0) {
                rejectInvalidParam(promise, outPath);
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

            WritableNativeMap result = new WritableNativeMap();

            Bitmap bitmap = BitmapFactory.decodeFile(inPath);
            if (bitmap == null) {
                throw new IOException("Decoding error unable to decode: " + inPath);
            }
            Mat img = new Mat(bitmap.getWidth(), bitmap.getHeight(), CvType.CV_8UC4);
            Utils.bitmapToMat(bitmap, img);

            Mat gryimg =  new Mat(img.size(), CvType.CV_8U);
            Imgproc.cvtColor(img, gryimg, Imgproc.COLOR_RGB2GRAY);
            Bitmap bm = Bitmap.createBitmap(gryimg.cols(), gryimg.rows(), Bitmap.Config.ARGB_8888);
            Utils.matToBitmap(gryimg, bm);

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

            result.putInt("width", width);
            result.putInt("height", height);
            result.putString("uri", outPath);
            promise.resolve(result);
        }
        catch (Exception ex) {
            reject(promise, "EGENERIC", ex);
        }
    }
}
