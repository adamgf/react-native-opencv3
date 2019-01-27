// @author Adam G. Freeman - adamgf@gmail.com, 01/26/2019
package org.opencv.reactnative;

import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMapKeySetIterator;

import org.opencv.imgproc.Imgproc.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.core.Mat;
import org.opencv.core.MatOfInt;
import org.opencv.core.MatOfFloat;

import android.util.Log;

import java.lang.reflect.*;
import java.util.ArrayList;

class CvInvoke {

    private static CvInvoke cvInvoke = null;

    private static int arrMatIndex = -1;
    private static int dstMatIndex = -1;

    private CvInvoke() {
    }

    // static method to create instance of Singleton class
    public static CvInvoke getInstance()
    {
        if (cvInvoke == null)
            cvInvoke = new CvInvoke();

        return cvInvoke;
    }

    private static int getNumKeys(ReadableMap RM) {
        int numKeys = 0;
        ReadableMapKeySetIterator keyIterator = RM.keySetIterator();
        while (keyIterator.hasNextKey()) {
            keyIterator.nextKey();
            numKeys++;
        }
        return numKeys;
    }

    private static Object[] getObjectArr(ReadableMap RM, Class[] params) {

        int i = 1;
        ArrayList retObjs = new ArrayList<Object>();
        boolean secondMat = false;

        for (Class param : params) {
           String paramNum = "p" + i;

           if (param == Mat.class) {
                ReadableMap matMap = RM.getMap(paramNum);
                int matIndex = matMap.getInt("matIndex");
                Mat dMat = (Mat)MatManager.getInstance().matAtIndex(matIndex);
                retObjs.add(dMat);
                if (secondMat) {
                    // have to update the dst mat after op ...
                    arrMatIndex = i - 1;
                    dstMatIndex = matIndex;
                    secondMat = false;
                }
                else {
                    secondMat = true;
                }
           }
           else if (param == int.class) {
                int dInt = RM.getInt(paramNum);
                retObjs.add(dInt);
           }
           i++;
        }
        Object[] retArr = retObjs.toArray(new Object[retObjs.size()]);
        return retArr;
    }

    public static Object invokeCvMethods(ReadableMap cvInvokeMap) {
        Object ret = null;
        ReadableArray functions = cvInvokeMap.getArray("functions");
        ReadableArray paramsArr = cvInvokeMap.getArray("paramsArr");
        ReadableArray callbacks = cvInvokeMap.getArray("callbacks");

        return ret;
    }

    public static Object invokeCvMethod(String func, ReadableMap params) {

        Object result = null;
        int numParams = getNumKeys(params);

        try {
            Method[] methods = Imgproc.class.getDeclaredMethods();
            for (Method method : methods) {
                if (method.getName().equals(func)) {
                    Class<?>[] methodParams = method.getParameterTypes();
                    if (numParams == methodParams.length) {

                        Object[] objects = getObjectArr(params, methodParams);
                        result = method.invoke(null, objects);

                        if (dstMatIndex >= 0) {
                            Mat dstMat = (Mat)objects[arrMatIndex];
                            MatManager.getInstance().setMat(dstMat, dstMatIndex);
                            dstMatIndex = -1;
                            arrMatIndex = -1;
                        }
                    }
                }
            }
        }
        catch (SecurityException SE) {
            result = "Something fuckin' bad happened!  Security exception!!  Fuck!!";
        }
        catch (IllegalAccessException IAE) {
            result = "Something fuckin' bad happened!  Illegal access exception!!  Fuck!!";
        }
        catch (InvocationTargetException IAE) {
            result = "Something fuckin' bad happened!  Invocation target exception!!  Fuck!!";
        }

        return result;
    }
}
