// @author Adam G. Freeman - adamgf@gmail.com, 01/26/2019
package com.adamfreeman.rnocv3;

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
import java.util.HashMap;

class CvInvoke {

    private static final String TAG = CvInvoke.class.getSimpleName();

    // usually the last Mat in the params is used as the return mat except for
	// these function exceptions in which another Mat besides the dest Mat follows it in
	// the parameter list ... 
	// the first index is the ret Mat index the second int is for the number of minimum params for this to occur
	private final static HashMap<String, int[]> retExcs = new HashMap<String, int[]>();
	static {
		retExcs.put("add",new int[]{2,4});
		retExcs.put("accumulate",new int[]{1,3}); 
		retExcs.put("accumulateProduct",new int[]{2,4}); 
		retExcs.put("accumulateSquare",new int[]{1,3}); 
		retExcs.put("accumulateWeighted",new int[]{1,4}); 
		retExcs.put("applyColorMap",new int[]{1,3}); 
		retExcs.put("bitwise_and",new int[]{2,4});
		retExcs.put("bitwise_not",new int[]{1,3});
		retExcs.put("bitwise_or",new int[]{2,4});
		retExcs.put("bitwise_xor",new int[]{2,4});
		retExcs.put("connectedComponents",new int[]{0,2}); 		
		retExcs.put("connectedComponentsWithAlgorithm",new int[]{0,5}); 
		retExcs.put("connectedComponentsWithStatsWithAlgorithm",new int[]{0,7}); 
		retExcs.put("dilate",new int[]{1,3}); 
		retExcs.put("distanceTransformWithLabels",new int[]{1,5}); 
		retExcs.put("erode",new int[]{1,3}); 
		retExcs.put("filter2D",new int[]{1,4}); 
		retExcs.put("findContours",new int[]{1,5}); // not a Mat return object? need to deal with this ...	
		retExcs.put("floodFill",new int[]{0,4}); 
		retExcs.put("mulTransposed",new int[]{1,4}); 
		retExcs.put("normalize",new int[]{1,7}); 
		retExcs.put("morphologyEx",new int[]{1,4}); 
		retExcs.put("perspectiveTransform",new int[]{1,3}); 
		retExcs.put("remap",new int[]{1,5}); 
		retExcs.put("sepFilter2D",new int[]{1,5}); 
		retExcs.put("spatialGradient",new int[]{0,3}); 
		retExcs.put("subtract",new int[]{2,4});
		retExcs.put("transform",new int[]{1,3}); 
		retExcs.put("undistort",new int[]{1,4}); 
		retExcs.put("undistortPoints",new int[]{1,4}); 
		retExcs.put("undistortPointsIter",new int[]{1,7}); 
		retExcs.put("warpAffine",new int[]{1,4}); 
		retExcs.put("warpPerspective",new int[]{1,4}); 
		retExcs.put("warpPolar",new int[]{1,6}); 
		retExcs.put("watershed",new int[]{0,2}); 
	}
	
    private int arrMatIndex = -1;
    public int dstMatIndex = -1;
    // these mats come from the camera or image view ...
    private Mat rgba = null;
    private Mat gray = null;

    public String callback = null;

    private HashMap<String, Mat> matParams = new HashMap<String, Mat>();

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

    private Object[] getObjectArr(String func, ReadableMap RM, Class[] params) {

        int i = 1;
        ArrayList retObjs = new ArrayList<Object>();

        for (Class param : params) {
           String paramNum = "p" + i;

           ReadableType itsType = RM.getType(paramNum);
           if (itsType == ReadableType.String) {
               // special case the string rgba and rgbat is used
               // to represent the current frame in RGBA colorspace
               // the strings gray and grayt represent grayscale frame
               // the matParams key string represents the Mat returned
               // from a Mat function on the input frame
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
               else if (matParams.containsKey(paramStr)) {
                   dstMat = matParams.get(paramStr);
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
           else if (itsType == ReadableType.Map) {
               ReadableMap dMap = RM.getMap(paramNum);
		       if (param == Mat.class || param == List.class) {
                   int matIndex = dMap.getInt("matIndex");
                   Mat dMat = (Mat)MatManager.getInstance().matAtIndex(matIndex);
				   if (param == Mat.class) {
                       retObjs.add(dMat);
				   }
				   else {
	                   retObjs.add(Arrays.asList(dMat));
				   }

                   // have to update the dst mat after op ...
                   // should be last mat in function parameters unless exception function
				   if (retExcs.containsKey(func)) {
					   int[] testExcs = retExcs.get(func);
					   int minParams = testExcs[1];
					   if (params.length >= minParams) {
					       if (testExcs[0] == (i - 1)) {
					           arrMatIndex = testExcs[0];
						       dstMatIndex = matIndex;
					       }
				   	   }
					   else {
						   arrMatIndex = i - 1;
						   dstMatIndex = matIndex;
					   }
				   }
				   else {
                       arrMatIndex = i - 1;
                       dstMatIndex = matIndex;
				   }
               }
               else if (param == MatOfInt.class) {
                   int matIndex = dMap.getInt("matIndex");
                   MatOfInt dMatOfInt = (MatOfInt)MatManager.getInstance().matAtIndex(matIndex);
                   retObjs.add(dMatOfInt);
           	   }
               else if (param == MatOfFloat.class) {
                   int matIndex = dMap.getInt("matIndex");
                   MatOfFloat dMatOfFloat = (MatOfFloat)MatManager.getInstance().matAtIndex(matIndex);
                   retObjs.add(dMatOfFloat);
               }
               else if (param == Point.class) {
                   double xval = dMap.getDouble("x");
                   double yval = dMap.getDouble("y");
                   Point dPoint = new Point(xval, yval);
                   retObjs.add(dPoint);
               }
               else if (param == Scalar.class) {
                   ReadableArray scalarVal = dMap.getArray("vals");
                   Scalar dScalar = new Scalar(scalarVal.getDouble(0),scalarVal.getDouble(1),
                       scalarVal.getDouble(2),scalarVal.getDouble(3));
                   retObjs.add(dScalar);
               }
               else if (param == Size.class) {
                   double width = dMap.getDouble("width");
                   double height = dMap.getDouble("height");
                   Size dSize = new Size(width, height);
                   retObjs.add(dSize);
               }
			   else if (param == Rect.class) {
			       int top = dMap.getInt("top");
				   int left = dMap.getInt("left");
                   int width = dMap.getInt("width");
                   int height = dMap.getInt("height");
				   Rect dRect = new Rect(top, left, width, height);
				   retObjs.add(dRect);
			   }
	   	   }
		   else if (itsType == ReadableType.Number) {
               if (param == int.class) {
                  int dInt = RM.getInt(paramNum);
                  retObjs.add(dInt);
               }
               else if (param == double.class) {
                  double dDouble = RM.getDouble(paramNum);
                  retObjs.add(dDouble);
			   } 
           }
           else if (itsType == ReadableType.Array) {
                // TODO: not sure how to check the objects here yet ... Adam
                if (param == List.class) {
                    // this has not been tested yet ...
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
        int numParams = 0;
        if (params != null) {
            numParams = getNumKeys(params);
        }
        Method[] methods = searchClass.getDeclaredMethods();
        for (Method method : methods) {
            if (method.getName().equals(func)) {
                if (numParams > 0) {
                    Class<?>[] methodParams = method.getParameterTypes();
                    if (numParams == methodParams.length) {
                        retMethod = method;
                        break;
                    }
                }
                else {
                    retMethod = method;
                    break;
                }
            }
        }
        return retMethod;
    }

	// recursive serialization helper functions ...
    private static WritableArray readable2WritableArray(ReadableArray arr1) {
    	WritableArray arr2 = new WritableNativeArray();
		for (int i=0;i < arr1.size();i++) {
			ReadableType itsType = arr1.getType(i);
			switch (itsType) {
				case String:
					String strval = arr1.getString(i);
					arr2.pushString(strval);
					break;
				case Number:
					double dubval = arr1.getDouble(i);
					arr2.pushDouble(dubval);
					break;
				case Boolean:
					boolean boolval = arr1.getBoolean(i);
					arr2.pushBoolean(boolval);
					break;
				case Map:
					ReadableMap mapval = arr1.getMap(i);
					arr2.pushMap(readable2WritableMap(mapval));
					break;
				case Array:
					ReadableArray arrval = arr1.getArray(i);
					// recursive call
					arr2.pushArray(readable2WritableArray(arrval));
					break;
				case Null:
					arr2.pushString(null);
			}
		}
		return arr2;
    }
	
    private static WritableMap readable2WritableMap(ReadableMap map1) {
        WritableMap map2 = new WritableNativeMap();
        ReadableMapKeySetIterator iterator = map1.keySetIterator();
        while (iterator.hasNextKey()) {
            String key = iterator.nextKey();
            ReadableType itsType = map1.getType(key);
            switch (itsType) {
                case String:
                    String strval = map1.getString(key);
                    map2.putString(key, strval);
                    break;
                case Number:
                    double dubval = map1.getDouble(key);
                    map2.putDouble(key, dubval);
                    break;
                case Boolean:
                    boolean boolval = map1.getBoolean(key);
                    map2.putBoolean(key, boolval);
                    break;
                case Map:
                    ReadableMap mapval = map1.getMap(key);
                    // recursive call
                    map2.putMap(key, readable2WritableMap(mapval));
                    break;
				case Array:
					ReadableArray arrval = map1.getArray(key);
					map2.putArray(key, readable2WritableArray(arrval));
					break;
                case Null:
                    map2.putString(key, null);
            }
        }
        return map2;
    }

    public static Object[] populateInvokeGroups(ReadableMap cvInvokeGroup) {

        ArrayList invokeGroupList = new ArrayList<ReadableMap>();

        ReadableArray ins = cvInvokeGroup.getArray("ins");
        ReadableArray functions = cvInvokeGroup.getArray("functions");
        ReadableArray paramsArr = cvInvokeGroup.getArray("paramsArr");
        ReadableArray outs = cvInvokeGroup.getArray("outs");
        ReadableArray callbacks = cvInvokeGroup.getArray("callbacks");
        ReadableArray groupids  = cvInvokeGroup.getArray("groupids");
        WritableArray responseArr = new WritableNativeArray();

        if (groupids.size() > 0) {
            int i = 0;
            while (i < groupids.size()) {
                WritableMap invokeGroup = new WritableNativeMap();
                WritableArray inobs = new WritableNativeArray();
                WritableArray funcs = new WritableNativeArray();
                WritableArray parms = new WritableNativeArray();
                WritableArray otobs = new WritableNativeArray();
                WritableArray calls = new WritableNativeArray();
                String invokeGroupStr = groupids.getString(i);
                while (i < groupids.size() && groupids.getString(i).equals(invokeGroupStr)) {
                    String in = ins.getString(i);
                    String function = functions.getString(i);
                    WritableMap params = null;
                    if (paramsArr != null && paramsArr.getMap(i) != null) {
                        params = readable2WritableMap(paramsArr.getMap(i));
                    }
                    String out = outs.getString(i);
                    String callback = callbacks.getString(i);
                    inobs.pushString(in);
                    funcs.pushString(function);
                    parms.pushMap(params);
                    otobs.pushString(out);
                    calls.pushString(callback);
                    i++;
                }
                invokeGroup.putArray("ins", inobs);
                invokeGroup.putArray("functions", funcs);
                invokeGroup.putArray("paramsArr", parms);
                invokeGroup.putArray("outs", otobs);
                invokeGroup.putArray("callbacks", calls);
                invokeGroupList.add(invokeGroup);
            }
        }
        Object[] retMaps = invokeGroupList.toArray(new Object[invokeGroupList.size()]);
        return retMaps;
    }

    public int invokeCvMethods(ReadableMap cvInvokeMap) {

        int ret = -1;
        ReadableArray ins = cvInvokeMap.getArray("ins");
        ReadableArray functions = cvInvokeMap.getArray("functions");
        ReadableArray paramsArr = cvInvokeMap.getArray("paramsArr");
        ReadableArray outs = cvInvokeMap.getArray("outs");
        ReadableArray callbacks = cvInvokeMap.getArray("callbacks");

        // back to front
        for (int i=(functions.size()-1);i >= 0;i--) {
            String in = ins.getString(i);
            String function = functions.getString(i);
            ReadableMap params = paramsArr.getMap(i);
            String out = outs.getString(i);

            ReadableType callbackType = callbacks.getType(i);
            if (i == 0) {
                callback = callbacks.getString(i);
                // last method in invoke group might have callback ...
                ret = invokeCvMethod(in, function, params, out);
            }
            else {
                invokeCvMethod(in, function, params, out);
            }
        }
        return ret;
    }

    public int invokeCvMethod(String in, String func, ReadableMap params, String out) {

        int result = -1;
        int numParams = 0;
        if (params != null) {
            numParams = getNumKeys(params);
        }
        Object[] objects = null;

        try {
            Method method = null;
            if (in != null && !in.equals("") && (in.equals("rgba") || in.equals("rgbat") ||
                in.equals("gray") || in.equals("grayt") || matParams.containsKey(in)))
            {
                method = findMethod(func, params, Mat.class);
            }
            else {
                method = findMethod(func, params, Imgproc.class);
                if (method == null) {
                    method = findMethod(func, params, Core.class);
                }
            }

            if (method == null) {
                throw new Exception(func + " not found make sure method exists and is part of Opencv Imgproc, Core or Mat.");
            }
            if (numParams > 0) {
                Class<?>[] methodParams = method.getParameterTypes();
                objects = getObjectArr(func, params, methodParams);

                if (numParams != objects.length) {
                    throw new Exception("One of the parameters is invalid and " + func + " cannot be invoked.");
                }
            }
            if (method != null) {
                Mat matToUse = null;

                if (in != null && in.equals("rgba")) {
                    matToUse = rgba;
                }
                else if (in != null && in.equals("rgbat")) {
                    matToUse = rgba.t();
                }
                else if (in != null && in.equals("gray")) {
                    matToUse = gray;
                }
                else if (in != null && in.equals("grayt")) {
                    matToUse = gray.t();
                }
                else if (in != null && matParams.containsKey(in)) {
                    matToUse = matParams.get(in);
                }

                if (out != null && !out.equals("")) {
                    Mat matParam = (Mat)method.invoke(matToUse, objects);
                    matParams.put(out, matParam);
                }
                else {
                    if (func.equals("release")) {
                        // special case deleting the last Mat
                        matToUse.release();
                        matParams.remove(in);
                    }
                    else {
                        method.invoke(matToUse, objects);
                    }
                }
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
        catch (InvocationTargetException ITE) {
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
	
	public WritableArray parseInvokeMap(ReadableMap cvInvokeMap) {
        WritableArray responseArr = null;
        ReadableArray groupids = null;
        if (cvInvokeMap.hasKey("groupids")) {
            groupids = cvInvokeMap.getArray("groupids");
            if (groupids != null && groupids.size() > 0) {
                Object[] invokeGroups = CvInvoke.populateInvokeGroups(cvInvokeMap);
                responseArr = new WritableNativeArray();
                for (int i=invokeGroups.length-1;i >= 0;i--) {
                    dstMatIndex = invokeCvMethods((ReadableMap)invokeGroups[i]);
                    if (callback != null && !callback.equals("") && dstMatIndex >= 0 && dstMatIndex < 1000) {
                        WritableArray retArr = MatManager.getInstance().getMatData(dstMatIndex, 0, 0);
                        responseArr.pushArray(retArr);
                    }
                }
            }
        }
        else {
            dstMatIndex = invokeCvMethods(cvInvokeMap);
            if (callback != null && !callback.equals("") && dstMatIndex >= 0 && dstMatIndex < 1000) {
                responseArr = MatManager.getInstance().getMatData(dstMatIndex, 0, 0);
            }
        }
		return responseArr;
	}
}
