// author Adam G. Freeman, adamgf@gmail.com 01/17/2019
package org.opencv.reactnative;

import com.facebook.react.bridge.WritableNativeArray;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.File;
import java.lang.Runnable;
import java.util.ArrayList;

import org.opencv.core.Mat;
import org.opencv.core.MatOfInt;
import org.opencv.core.MatOfFloat;

class MatManager {

  private ArrayList mats = new ArrayList<Object>();

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

    public int createMat(int cols, int rows, int cvtype) {
        int matIndex = mats.size();
        Mat matToAdd = new Mat(cols, rows, cvtype);
        mats.add(matToAdd);
        return matIndex;
    }

    public int createMatOfInt(int matval) {
        int matIndex = mats.size();
        MatOfInt matToAdd = new MatOfInt(matval);
        mats.add(matToAdd);
        return matIndex;
    }

    public int createMatOfFloat(float lomatval, float himatval) {
        int matIndex = mats.size();
        MatOfFloat matToAdd = new MatOfFloat(lomatval, himatval);
        mats.add(matToAdd);
        return matIndex;
    }

    public int createEmptyMat() {
        int matIndex = mats.size();
        Mat emptyMat = new Mat();
        mats.add(emptyMat);
        return matIndex;
    }

    public int addMat(Object matToAdd) {
        int matIndex = mats.size();
        mats.add(matToAdd);
        return matIndex;
    }

    public Object matAtIndex(int matIndex) {
        if (matIndex >= 0 && matIndex < mats.size()) {
            Object mat = mats.get(matIndex);
            return mat;
        }
        return null;
    }

    public void setMat(Object matToSet, int matIndex) {
        mats.set(matIndex, matToSet);
    }

    public void deleteMatAtIndex(int matIndex) {
        mats.remove(matIndex);
    }

    public void deleteAllMats() {
        mats.clear();
    }
}
