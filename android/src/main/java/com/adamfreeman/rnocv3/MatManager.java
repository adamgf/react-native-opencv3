// author Adam G. Freeman, adamgf@gmail.com 01/17/2019
package com.adamfreeman.rnocv3;

import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableNativeArray;

import java.util.ArrayList;

import org.opencv.core.Scalar;
import org.opencv.core.Mat;
import org.opencv.core.MatOfInt;
import org.opencv.core.MatOfFloat;

import android.util.Log;

/*
 *  In javascript land a Mat is an opaque object represented by an integer index into an array ...
 *  That way large amounts of data do not need to be encoded decoded and passed back-and-forth
 */
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

    public static int createEmptyMat() {
        int matIndex = mats.size();
        Mat emptyMat = new Mat();
        mats.add(emptyMat);
        return matIndex;
    }

    public static int createMat(int rows, int cols, int cvtype, ReadableMap scalarMap) {
        int matIndex = mats.size();
        Mat matToAdd = null;

        if (scalarMap != null) {
	        ReadableArray cvscalar = scalarMap.getArray("vals");
	        Scalar scalarVal = new Scalar(cvscalar.getDouble(0),cvscalar.getDouble(1),
	          cvscalar.getDouble(2),cvscalar.getDouble(3));
            matToAdd = new Mat(rows, cols, cvtype, scalarVal);
        }
        else {
            matToAdd = new Mat(rows, cols, cvtype);
        }
        mats.add(matToAdd);//cv::Mat mat(480, 640, CV_8UC3, cv::Scalar(255,0,255));

        return matIndex;
    }

    public static int createMatOfInt(int lomatval, int himatval) {
        int matIndex = mats.size();
        MatOfInt matToAdd;
		if (lomatval == himatval) {
			matToAdd = new MatOfInt(lomatval);
		}
		else {
			matToAdd = new MatOfInt(lomatval, himatval);
		}
        mats.add(matToAdd);
        return matIndex;
    }

    public static int createMatOfFloat(float lomatval, float himatval) {
        int matIndex = mats.size();
        MatOfFloat matToAdd;
		if (lomatval == himatval) {
			matToAdd = new MatOfFloat(lomatval);
		}
		else {
			matToAdd = new MatOfFloat(lomatval, himatval);
		}
        mats.add(matToAdd);
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

    public static void setMat(int matIndex, Object matToSet) {
        mats.set(matIndex, matToSet);
    }

    // This method should only be used for sending data to a callback in the RN app ...
    // TODO: get this to work for different data types checking CvType
    public static WritableArray getMatData(int matIndex, int rownum, int colnum) {
        WritableArray retArr = new WritableNativeArray();
        Mat mat = (Mat)matAtIndex(matIndex);
		
		if (mat.rows() > 0 && mat.cols() > 0) {
        	float[] retFloats = new float[mat.rows() * mat.cols() * mat.channels()];
        	mat.get(rownum, colnum, retFloats);
        	for (float retFloat : retFloats) {
          		retArr.pushDouble(retFloat);
        	}
		}
        return retArr;
    }

    public static void setTo(int matIndex, ReadableMap cvscalar) {
        Mat dMat = (Mat)matAtIndex(matIndex);
        ReadableArray scalarVal = cvscalar.getArray("vals");
        Scalar dScalar = new Scalar(scalarVal.getDouble(0),scalarVal.getDouble(1),
          scalarVal.getDouble(2),scalarVal.getDouble(3));
        dMat.setTo(dScalar);
        setMat(matIndex, dMat);
    }

    // TODO: check type to use different types ...
    public static void put(int matIndex, int rownum, int colnum, ReadableArray data) {
        Mat dMat = (Mat)matAtIndex(matIndex);
        ArrayList listOfObjs = data.toArrayList();
        float[] arr = new float[listOfObjs.size()];
        int i = 0;
        for (Object listObj : listOfObjs) {
            double dd = (double)listObj;
            arr[i++] = (float)dd;
        }
        dMat.put(rownum, colnum, arr);
        setMat(matIndex, dMat);
    }

    public static void transpose(int matIndex) {
        Mat dMat = (Mat)matAtIndex(matIndex);
        dMat.t();
        setMat(matIndex, dMat);
    }

    private static void releaseMat(Object dMat) {

        String objType = dMat.getClass().getSimpleName();
        if (objType.equals("Mat")) {
            ((Mat)dMat).release();
        }
        else if (objType.equals("MatOfInt")) {
            ((MatOfInt)dMat).release();
        }
        else if (objType.equals("MatOfFloat")) {
            ((MatOfFloat)dMat).release();
        }
        dMat = null;
    }

    public static void deleteMatAtIndex(int matIndex) {
        Object mat = matAtIndex(matIndex);
        releaseMat(mat);
        mats.remove(matIndex);
    }

    public static void deleteAllMats() {
        int matsSize = mats.size();
        for (int i=0;i < matsSize;i++) {
            Object mat = matAtIndex(i);
            releaseMat(mat);
        }
        mats.clear();
    }
}
