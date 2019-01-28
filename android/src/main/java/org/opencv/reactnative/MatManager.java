// author Adam G. Freeman, adamgf@gmail.com 01/17/2019
package org.opencv.reactnative;

import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableNativeArray;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.File;
import java.lang.Runnable;
import java.util.ArrayList;

import android.util.Log;

import org.opencv.core.Mat;
import org.opencv.core.MatOfInt;
import org.opencv.core.MatOfFloat;

class MatManager {

    private static final String TAG = MatManager.class.getSimpleName();

    private static ArrayList mats = new ArrayList<Object>();

    private static MatManager matManager = null;

    private MatManager() {
    }

    // static method to create instance of Singleton class
    public static MatManager getInstance()
    {
        if (matManager == null)
            matManager = new MatManager();

        return matManager;
    }

    public static int createMat(int rows, int cols, int cvtype) {
        int matIndex = mats.size();
        Mat matToAdd = new Mat(rows, cols, cvtype);
        mats.add(matToAdd);
        return matIndex;
    }

    public static int createMatOfInt(int matval) {
        int matIndex = mats.size();
        MatOfInt matToAdd = new MatOfInt(matval);
        mats.add(matToAdd);
        return matIndex;
    }

    public static int createMatOfFloat(float lomatval, float himatval) {
        int matIndex = mats.size();
        MatOfFloat matToAdd = new MatOfFloat(lomatval, himatval);
        mats.add(matToAdd);
        return matIndex;
    }

    public static int createEmptyMat() {
        int matIndex = mats.size();
        Mat emptyMat = new Mat();
        mats.add(emptyMat);
        return matIndex;
    }

    public static int addMat(Object matToAdd) {
        int matIndex = mats.size();
        mats.add(matToAdd);
        return matIndex;
    }

    public static Object matAtIndex(int matIndex) {
        if (matIndex >= 0 && matIndex < mats.size()) {
            Object mat = mats.get(matIndex);
            return mat;
        }
        return null;
    }

    public static void setMat(Object matToSet, int matIndex) {
        mats.set(matIndex, matToSet);
    }

    public static WritableArray getMatData(int rownum, int colnum, int matIndex) {
        Mat mat = (Mat)matAtIndex(matIndex);
        // TODO: check CvType to determine what type of data is stored in Mat ... Adam
        float[] retFloats = new float[mat.rows() * mat.cols()];
        mat.get(rownum, colnum, retFloats);

        WritableArray retArr = new WritableNativeArray();
        for (float retFloat : retFloats) {
            retArr.pushDouble((double)retFloat);
        }
        return retArr;
    }

    public static void deleteMatAtIndex(int matIndex) {
        Object mat = matAtIndex(matIndex);
        mat.release();
        mats.remove(matIndex);
    }

    public static void deleteAllMats() {
        int matsSize = mats.size();
        for (int i=0;i < matsSize;i++) {
            Object mat = (Mat)matAtIndex(i);
            mat.release();
        }
        mats.clear();
    }
}
