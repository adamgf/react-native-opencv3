// @author Adam G. Freeman - adamgf@gmail.com, 01/26/2019
package org.opencv.reactnative;

import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableNativeArray;
import com.facebook.react.bridge.ReadableType;
import com.facebook.react.bridge.ReadableMapKeySetIterator;
import com.facebook.react.bridge.ReactApplicationContext;

import org.opencv.imgproc.Imgproc.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.core.Core.*;
import org.opencv.core.*;

import android.util.Log;

import java.lang.reflect.*;
import java.lang.Exception;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

class CvInvoke {

    private static final String TAG = CvInvoke.class.getSimpleName();

    //private static CvInvoke cvInvoke = null;
    private int arrMatIndex = -1;
    private int dstMatIndex = -1;
    // these mats come from the camera or image view ...
    private Mat rgba = null;
    private Mat gray = null;

    public String callback = null;

    public CvInvoke() {
    }

    public CvInvoke(Mat rgba, Mat gray) {
        if (rgba != null) {
            this.rgba = rgba;
        }
        if (gray != null) {
            this.gray = gray;
        }
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

    private Object[] getObjectArr(ReadableMap RM, Class[] params) {

        int i = 1;
        ArrayList retObjs = new ArrayList<Object>();

        for (Class param : params) {
           String paramNum = "p" + i;

           ReadableType itsType = RM.getType(paramNum);
           if (itsType == ReadableType.String) {
               // special case the string rgba and rgbat is used
               // to represent the current frame in RGBA colorspace
               // the strings gray and grayt represent grayscale frame
               String paramStr = RM.getString(paramNum);
               Mat dstMat = null;
               if (paramStr.equals("rgba")) {
                   dstMat = rgba;
               }
               else if (paramStr.equals("rgbat")) {
                   dstMat = rgba.t();
               }
               else if (paramStr.equals("gray")) {
                   dstMat = gray;
               }
               else if (paramStr.equals("grayt")) {
                   dstMat = gray.t();
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
           else if (param == Point.class) {
              if (itsType == ReadableType.Map) {
                  ReadableMap pointMap = RM.getMap(paramNum);
                  double xval = pointMap.getDouble("x");
                  double yval = pointMap.getDouble("y");
                  Point dPoint = new Point(xval, yval);
                  retObjs.add(dPoint);
              }
           }
           else if (param == Scalar.class) {
              if (itsType == ReadableType.Map) {
                  ReadableMap scalarMap = RM.getMap(paramNum);
                  ReadableArray scalarVal = scalarMap.getArray("vals");
                  Scalar dScalar = new Scalar(scalarVal.getDouble(0),scalarVal.getDouble(1),
                      scalarVal.getDouble(2),scalarVal.getDouble(3));
                  retObjs.add(dScalar);
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
                    // should be last mat in function parameters probably
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

    private Method findMethod(String func, ReadableMap params, Class searchClass) {
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

    private static WritableMap readable2WritableMap(ReadableMap map1) {
        WritableMap map2 = new WritableNativeMap();
        ReadableMapKeySetIterator iterator = map1.keySetIterator();
        while (iterator.hasNextKey()) {
            String key = iterator.nextKey();
            ReadableType itsType = map1.getType(key);
            switch (itsType) {
                case String:
                    String snewval = map1.getString(key);
                    map2.putString(key, snewval);
                    break;
                case Number:
                    double dnewval = map1.getDouble(key);
                    map2.putDouble(key, dnewval);
                    break;
                case Boolean:
                    boolean bnewval = map1.getBoolean(key);
                    map2.putBoolean(key, bnewval);
                    break;
                case Map:
                    ReadableMap mnewval = map1.getMap(key);
                    // recursive call
                    map2.putMap(key, readable2WritableMap(mnewval));
                    break;
                // TODO: implement ReadableType.Array
                // but then Readable2WritableArray needs to be implemented
                default:
                case Null:
                    map2.putString(key, null);
            }
        }
        return map2;
    }

    public static Object[] populateInvokeGroups(ReadableMap cvInvokeGroup) {

        ArrayList invokeGroupList = new ArrayList<ReadableMap>();

        ReadableArray functions = cvInvokeGroup.getArray("functions");
        ReadableArray paramsArr = cvInvokeGroup.getArray("paramsArr");
        ReadableArray callbacks = cvInvokeGroup.getArray("callbacks");
        ReadableArray groupids  = cvInvokeGroup.getArray("groupids");
        WritableArray responseArr = new WritableNativeArray();

        if (groupids.size() > 0) {
            int i = 0;
            while (i < groupids.size()) {
                WritableMap invokeGroup = new WritableNativeMap();
                WritableArray funcs = new WritableNativeArray();
                WritableArray parms = new WritableNativeArray();
                WritableArray calls = new WritableNativeArray();
                String invokeGroupStr = groupids.getString(i);
                while (i < groupids.size() && groupids.getString(i).equals(invokeGroupStr)) {
                    String function = functions.getString(i);
                    WritableMap params = readable2WritableMap(paramsArr.getMap(i));
                    String callback = callbacks.getString(i);
                    funcs.pushString(function);
                    parms.pushMap(params);
                    calls.pushString(callback);
                    i++;
                }
                invokeGroup.putArray("functions", funcs);
                invokeGroup.putArray("paramsArr", parms);
                invokeGroup.putArray("callbacks", calls);
                invokeGroupList.add(invokeGroup);
            }
        }
        Object[] retMaps = invokeGroupList.toArray(new Object[invokeGroupList.size()]);
        return retMaps;
    }

    public int invokeCvMethods(ReadableMap cvInvokeMap) {

        int ret = -1;
        ReadableArray functions = cvInvokeMap.getArray("functions");
        ReadableArray paramsArr = cvInvokeMap.getArray("paramsArr");
        ReadableArray callbacks = cvInvokeMap.getArray("callbacks");

        // back to front
        for (int i=(functions.size()-1);i >= 0;i--) {
            String function = functions.getString(i);
            ReadableMap params = paramsArr.getMap(i);

            ReadableType callbackType = callbacks.getType(i);
            if (i == 0) {
                callback = callbacks.getString(i);
                // last method in invoke group should have callback ...
                ret = invokeCvMethod(function, params);
            }
            else {
                invokeCvMethod(function, params);
            }
        }
        return ret;
    }

    public int invokeCvMethod(String func, ReadableMap params) {

        int result = -1;
        int numParams = getNumKeys(params);
        Object[] objects = null;

        try {
            Method method = findMethod(func, params, Imgproc.class);
            if (method == null) {
                method = findMethod(func, params, Core.class);
            }

            if (method == null) {
                throw new Exception(func + " not found make sure method exists and is part of Opencv Imgproc or Core.");
            }
            Class<?>[] methodParams = method.getParameterTypes();
            objects = getObjectArr(params, methodParams);

            if (numParams != objects.length) {
                throw new Exception("One of the parameters is invalid and " + func + " cannot be invoked.");
            }

            if (method != null && objects != null) {
                method.invoke(null, objects);
            }

            if (dstMatIndex >= 0) {
                Mat dstMat = (Mat)objects[arrMatIndex];
                MatManager.getInstance().setMat(dstMatIndex, dstMat);
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
        catch (Exception EXC) {
            result = 1003;
            Log.e(TAG, EXC.getMessage());
        }
        finally {
            return result;
        }
    }
}
