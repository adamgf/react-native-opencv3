// @author Adam G. Freeman - adamgf@gmail.com, 01/26/2019
package org.opencv.reactnative;

import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.ReadableType;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.ReactApplicationContext;

import org.opencv.imgproc.Imgproc.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.core.Core.*;
import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.MatOfInt;
import org.opencv.core.MatOfFloat;

import android.util.Log;

import java.lang.reflect.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

class CvInvoke {

    private static final String TAG = CvInvoke.class.getSimpleName();

    private static CvInvoke cvInvoke = null;

    private static int arrMatIndex = -1;
    private static int dstMatIndex = -1;
    // these mats come from the camera or image view ...
    public static Mat rgba = null;
    public static Mat grey = null;

    public static String callback = null;

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

        for (Class param : params) {
           String paramNum = "p" + i;

           ReadableType itsType = RM.getType(paramNum);
           if (itsType == ReadableType.String) {
               String paramStr = RM.getString(paramNum);
               Mat dstMat = null;
               // special case grabbing the current frame
               if (paramStr.equals("rgba")) {
                   dstMat = rgba;
               }
               else if (paramStr.equals("grey")) {
                   dstMat = grey;
               }
               if (dstMat != null) {
                   if (param == Mat.class) {
                       retObjs.add(dstMat);
                   }
                   else if (param == List.class) {
                       retObjs.add(Arrays.asList(dstMat));
                   }
               }
               else if (param == String.class) {
                   retObjs.add(paramStr);
               }
           }
           // TODO: check the types to make sure they are compatible
           // more exhaustive type-checking and error reporting ...
           else if (param == Mat.class) {
                if (itsType == ReadableType.Map) {
                    ReadableMap matMap = RM.getMap(paramNum);
                    int matIndex = matMap.getInt("matIndex");
                    Mat dMat = (Mat)MatManager.getInstance().matAtIndex(matIndex);
                    retObjs.add(dMat);

                    // have to update the dst mat after op ...
                    // should be last mat in function parameters
                    arrMatIndex = i - 1;
                    dstMatIndex = matIndex;
                }
           }
           else if (param == MatOfInt.class) {
               if (itsType == ReadableType.Map) {
                  ReadableMap matMap = RM.getMap(paramNum);
                  int matIndex = matMap.getInt("matIndex");
                  MatOfInt dMatOfInt = (MatOfInt)MatManager.getInstance().matAtIndex(matIndex);
                  retObjs.add(dMatOfInt);
               }
           }
           else if (param == MatOfFloat.class) {
                if (itsType == ReadableType.Map) {
                    ReadableMap matMap = RM.getMap(paramNum);
                    int matIndex = matMap.getInt("matIndex");
                    MatOfFloat dMatOfFloat = (MatOfFloat)MatManager.getInstance().matAtIndex(matIndex);
                    retObjs.add(dMatOfFloat);
                }
           }
           else if (param == int.class) {
                if (itsType == ReadableType.Number) {
                    int dInt = RM.getInt(paramNum);
                    retObjs.add(dInt);
                }
           }
           else if (param == double.class) {
                if (itsType == ReadableType.Number) {
                    double dDouble = RM.getDouble(paramNum);
                    retObjs.add(dDouble);
                }
           }
           else if (param == List.class) {
                // TODO: not sure how to check the objects here yet ... Adam
                if (itsType == ReadableType.Map) {
                    ReadableMap matMap = RM.getMap(paramNum);
                    int matIndex = matMap.getInt("matIndex");
                    Mat dMat = (Mat)MatManager.getInstance().matAtIndex(matIndex);
                    retObjs.add(Arrays.asList(dMat));

                    // have to update the dst mat after op ...
                    // should be last mat in function parameters
                    arrMatIndex = i - 1;
                    dstMatIndex = matIndex;
                }
                else if (itsType == ReadableType.Array) {
                    ReadableArray arr = RM.getArray(paramNum);
                    retObjs.add(arr.toArrayList());
                }
           }
           i++;
        }
        Object[] retArr = retObjs.toArray(new Object[retObjs.size()]);
        return retArr;
    }

    private static Method findMethod(String func, ReadableMap params, Class searchClass) {
        Method retMethod = null;
        int numParams = getNumKeys(params);
        Method[] methods = searchClass.getDeclaredMethods();
        for (Method method : methods) {
            if (method.getName().equals(func)) {
                Class<?>[] methodParams = method.getParameterTypes();
                if (numParams == methodParams.length) {
                    retMethod = method;
                    break;
                }
            }
        }
        return retMethod;
    }

    public static int invokeCvMethods(ReadableMap cvInvokeMap) {

        int ret = -1;
        ReadableArray functions = cvInvokeMap.getArray("functions");
        ReadableArray paramsArr = cvInvokeMap.getArray("paramsArr");
        ReadableArray callbacks = cvInvokeMap.getArray("callbacks");

        // back to front
        for (int i=(functions.size()-1);i >= 0;i--) {
            String function = functions.getString(i);
            ReadableMap params = paramsArr.getMap(i);

            ReadableType callbackType = callbacks.getType(i);
            if (i == 0 && callbackType == ReadableType.String) {
                callback = callbacks.getString(i);
                // last method in invoke group should have callback ...
                if (callback != null && !callback.equals("")) {
                    ret = invokeCvMethod(function, params);
                }
            }
            else {
                invokeCvMethod(function, params);
            }
        }
        return ret;
    }

    public static int invokeCvMethod(String func, ReadableMap params) {

        int result = -1;
        int numParams = getNumKeys(params);
        Object[] objects = null;

        try {
            Method method = findMethod(func, params, Imgproc.class);
            if (method == null) {
                method = findMethod(func, params, Core.class);
            }
            Class<?>[] methodParams = method.getParameterTypes();
            objects = getObjectArr(params, methodParams);

            if (method != null && objects != null) {
                method.invoke(null, objects);
            }

            if (dstMatIndex >= 0) {
                Mat dstMat = (Mat)objects[arrMatIndex];
                MatManager.getInstance().setMat(dstMat, dstMatIndex);
                result = dstMatIndex;
                dstMatIndex = -1;
                arrMatIndex = -1;
            }
        }
        catch (SecurityException SE) {
            result = 1000;
        }
        catch (IllegalAccessException IAE) {
            result = 1001;
        }
        catch (InvocationTargetException IAE) {
            result = 1002;
        }
        return result;
    }
}
