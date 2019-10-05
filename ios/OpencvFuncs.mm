//
//  ImgprocFuncs.m
//  RNOpencv3
//
//  Created by Adam G Freeman on 3/11/19.
//  Copyright © 2019 Adam G. Freeman. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OpencvFuncs.h"

// There may be a better way to do these three things by encapsulating them in an array of structs
// still I like its simplicity ...
std::vector<std::string> Functions = {
    "cvtColor", // beginning ImgProc functions
    "cvtColor",
    "line",
    "line",
    "line",
    "line",
    "normalize",
    "normalize",
    "normalize",
    "normalize",
    "normalize",
    "normalize",
    "calcHist",
    "calcBackProject",
    "submat",
    "Canny",
    "Canny",
    "Canny",
    "release",
    "Sobel",
    "Sobel",
    "Sobel",
    "Sobel",
    "Sobel",
    "convertScaleAbs",
    "convertScaleAbs",
    "convertScaleAbs",
    "transform",
    "resize",
    "resize",
    "resize",
    "resize",
    "rectangle",
    "rectangle",
    "rectangle",
    "rectangle",
    "setTo",
    "medianBlur",
    "GaussianBlur",
    "GaussianBlur",
    "GaussianBlur",
    "bilateralFilter",
    "bilateralFilter",
    "boxFilter",
    "boxFilter",
    "boxFilter",
    "boxFilter",
    "sqrBoxFilter",
    "sqrBoxFilter",
    "sqrBoxFilter",
    "sqrBoxFilter",
    "blur",
    "blur",
    "blur",
    "filter2D",
    "filter2D",
    "filter2D",
    "filter2D",
    "sepFilter2D",
    "sepFilter2D",
    "sepFilter2D",
    "sepFilter2D",
    "Scharr",
    "Scharr",
    "Scharr",
    "Scharr",
    "Laplacian",
    "Laplacian",
    "Laplacian",
    "Laplacian",
    "Laplacian",
    "cornerMinEigenVal",
    "cornerMinEigenVal",
    "cornerMinEigenVal",
    "cornerHarris",
    "cornerHarris",
    "cornerEigenValsAndVecs",
    "cornerEigenValsAndVecs",
    "preCornerDetect",
    "preCornerDetect",
    "cornerSubPix",
    "goodFeaturesToTrack",
    "goodFeaturesToTrack",
    "goodFeaturesToTrack",
    "goodFeaturesToTrack",
    "goodFeaturesToTrack",
    "goodFeaturesToTrack",
    "HoughLines",
    "HoughLines",
    "HoughLines",
    "HoughLines",
    "HoughLines",
    "HoughLinesP",
    "HoughLinesP",
    "HoughLinesP",
    "HoughLinesPointSet",
    "HoughCircles",
    "HoughCircles",
    "HoughCircles",
    "HoughCircles",
    "HoughCircles",
    "erode",
    "erode",
    "erode",
    "erode",
    "erode",
    "dilate",
    "dilate",
    "dilate",
    "dilate",
    "dilate",
    "morphologyEx",
    "morphologyEx",
    "morphologyEx",
    "morphologyEx",
    "morphologyEx",
    "warpAffine",
    "warpAffine",
    "warpAffine",
    "warpAffine",
    "warpPerspective",
    "warpPerspective",
    "warpPerspective",
    "warpPerspective",
    "circle",
    "circle",
    "circle",
    "circle",
    "addWeighted",
    "addWeighted",
    "remap",
    "remap",
    "remap",
    "getRotationMatrix2D",
    "invertAffineTransform",
    "getPerspectiveTransform",
    "getAffineTransform",
    "getRectSubPix",
    "getRectSubPix",
    "logPolar",
    "linearPolar",
    "integral",
    "integral",
    "accumulate",
    "accumulate",
    "accumulateSquare",
    "accumulateSquare",
    "accumulateProduct",
    "accumulateProduct",
    "accumulateWeighted",
    "accumulateWeighted",
    "createHanningWindow",
    "threshold",
    "adaptiveThreshold",
    "pyrDown",
    "pyrDown",
    "pyrDown",
    "pyrUp",
    "pyrUp",
    "pyrUp",
    "undistort",
    "undistort",
    "getDefaultNewCameraMatrix",
    "getDefaultNewCameraMatrix",
    "getDefaultNewCameraMatrix",
    "undistortPoints",
    "undistortPoints",
    "undistortPoints",
    "equalizeHist",
    "watershed",
    "pyrMeanShiftFiltering",
    "distanceTransform",
    "distanceTransform",
    "cvtColorTwoPlane",
    "demosaicing",
    "demosaicing",
    "matchTemplate",
    "matchTemplate",
    "connectedComponents",
    "connectedComponents",
    "connectedComponents",
    "connectedComponents",
    "approxPolyDP",
    "minEnclosingTriangle",
    "convexHull",
    "convexHull",
    "convexHull",
    "convexityDefects",
    "intersectConvexConvex",
    "intersectConvexConvex",
    "fitLine",
    "blendLinear",
    "applyColorMap",
    "applyColorMap",
    "arrowedLine",
    "arrowedLine",
    "arrowedLine",
    "arrowedLine",
    "arrowedLine",
    "ellipse",
    "ellipse",
    "ellipse",
    "ellipse",
    "drawMarker",
    "drawMarker",
    "drawMarker",
    "drawMarker",
    "drawMarker",
    "fillConvexPoly",
    "fillConvexPoly",
    "fillConvexPoly",
    "putText",
    "putText",
    "putText",
    "putText",
    "copyMakeBorder", // beginning Core functions
    "copyMakeBorder",
    "add",
    "add",
    "add",
    "subtract",
    "subtract",
    "subtract",
    "multiply",
    "multiply",
    "multiply",
    "divide",
    "divide",
    "divide",
    "scaleAdd",
    "convertFp16",
    "LUT",
    "findNonZero",
    "reduce",
    "reduce",
    "extractChannel",
    "insertChannel",
    "flip",
    "repeat",
    "hconcat",
    "vconcat",
    "bitwise_and",
    "bitwise_and",
    "bitwise_or",
    "bitwise_or",
    "bitwise_xor",
    "bitwise_xor",
    "bitwise_not",
    "bitwise_not",
    "absdiff", 
    "inRange",
    "compare",
    "min",
    "max",
    "sqrt",
    "pow",
    "exp",
    "log",
    "phase",
    "phase",
    "magnitude",
    "patchNaNs",
    "patchNaNs",
    "gemm",
    "gemm",
    "mulTransposed",
    "mulTransposed",
    "mulTransposed",
    "mulTransposed",
    "transpose",
    "perspectiveTransform",
    "completeSymm",
    "completeSymm",
    "setIdentity",
    "setIdentity",
    "invert",
    "invert",
    "solve",
    "solve",
    "sort",
    "sortIdx",
    "solveCubic",
    "solvePoly",
    "dft",
    "dft",
    "dft",
    "idft",
    "idft",
    "idft",
    "dct",
    "dct",
    "idct",
    "idct",
    "mulSpectrums",
    "mulSpectrums",
    "randu",
    "randn",
    "rotate",
};

std::vector<std::string> types = {
    "Mat,OutMat,int", // beginning ImgProc functions
    "Mat,OutMat,int,int",
    "OutMat,Point,Point,Scalar",
    "OutMat,Point,Point,Scalar,int",
    "OutMat,Point,Point,Scalar,int,int",
    "OutMat,Point,Point,Scalar,int,int,int",
    "Mat,OutMat",
    "Mat,OutMat,double",
    "Mat,OutMat,double,double",
    "Mat,OutMat,double,double,int",
    "Mat,OutMat,double,double,int,int",
    "Mat,OutMat,double,double,int,int,Mat",
    "Mat,MatOfInt,Mat,OutMat,MatOfInt,MatOfFloat",
    "Mat,MatOfInt,Mat,OutMat,MatOfFloat",
    "double,double,double,double", // OutMat is implicitly incoming Mat ...
    "Mat,OutMat,double,double",
    "Mat,OutMat,double,double,int",
    "Mat,OutMat,double,double,int,bool",
    "", // OutMat is implicitly incoming Mat ...
    "Mat,OutMat,int,double,double",
    "Mat,OutMat,int,double,double,int",
    "Mat,OutMat,int,double,double,int,double",
    "Mat,OutMat,int,double,double,int,double,double",
    "Mat,OutMat,int,double,double,int,double,double,int",
    "Mat,OutMat",
    "Mat,OutMat,double",
    "Mat,OutMat,double,double",
    "Mat,OutMat,Mat",
    "Mat,OutMat,Size",
    "Mat,OutMat,Size,double",
    "Mat,OutMat,Size,double,double",
    "Mat,OutMat,Size,double,double,int",
    "OutMat,Point,Point,Scalar",
    "OutMat,Point,Point,Scalar,int",
    "OutMat,Point,Point,Scalar,int,int",
    "OutMat,Point,Point,Scalar,int,int,int",
    "OutMat,Scalar",
    "Mat,OutMat,int",
    "Mat,OutMat,Size,double",
    "Mat,OutMat,Size,double,double",
    "Mat,OutMat,Size,double,double,int",
    "Mat,OutMat,int,double,double",
    "Mat,OutMat,int,double,double,int",
    "Mat,OutMat,int,Size",
    "Mat,OutMat,int,Size,Point",
    "Mat,OutMat,int,Size,Point,bool",
    "Mat,OutMat,int,Size,Point,bool,int",
    "Mat,OutMat,int,Size",
    "Mat,OutMat,int,Size,Point",
    "Mat,OutMat,int,Size,Point,bool",
    "Mat,OutMat,int,Size,Point,bool,int",
    "Mat,OutMat,Size",
    "Mat,OutMat,Size,Point",
    "Mat,OutMat,Size,Point,int",
    "Mat,OutMat,int,Mat",
    "Mat,OutMat,int,Mat,Point",
    "Mat,OutMat,int,Mat,Point,double",
    "Mat,OutMat,int,Mat,Point,double,int",
    "Mat,OutMat,int,Mat,Mat",
    "Mat,OutMat,int,Mat,Mat,Point",
    "Mat,OutMat,int,Mat,Mat,Point,double",
    "Mat,OutMat,int,Mat,Mat,Point,double,int",
    "Mat,OutMat,int,int,int",
    "Mat,OutMat,int,int,int,double",
    "Mat,OutMat,int,int,int,double,double",
    "Mat,OutMat,int,int,int,double,double,int",
    "Mat,OutMat,int",
    "Mat,OutMat,int,int",
    "Mat,OutMat,int,int,double",
    "Mat,OutMat,int,int,double,double",
    "Mat,OutMat,int,int,double,double,int",
    "Mat,OutMat,int",
    "Mat,OutMat,int,int",
    "Mat,OutMat,int,int,int",
    "Mat,OutMat,int,int,double",
    "Mat,OutMat,int,int,double,int",
    "Mat,OutMat,int,int",
    "Mat,OutMat,int,int,int",
    "Mat,OutMat,int",
    "Mat,OutMat,int,int",
    "Mat,OutMat,Size,Size",
    "Mat,OutMat,int,double,double",
    "Mat,OutMat,int,double,double,Mat",
    "Mat,OutMat,int,double,double,Mat,int",
    "Mat,OutMat,int,double,double,Mat,int,int",
    "Mat,OutMat,int,double,double,Mat,int,int,bool",
    "Mat,OutMat,int,double,double,Mat,int,int,bool,double",
    "Mat,OutMat,double,double,int",
    "Mat,OutMat,double,double,int,double",
    "Mat,OutMat,double,double,int,double,double",
    "Mat,OutMat,double,double,int,double,double,double",
    "Mat,OutMat,double,double,int,double,double,double,double",
    "Mat,OutMat,double,double,int",
    "Mat,OutMat,double,double,int,double",
    "Mat,OutMat,double,double,int,double,double",
    "Mat,OutMat,int,int,double,double,double,double,double,double",
    "Mat,OutMat,int,double,double",
    "Mat,OutMat,int,double,double,double",
    "Mat,OutMat,int,double,double,double,double",
    "Mat,OutMat,int,double,double,double,double,int",
    "Mat,OutMat,int,double,double,double,double,int,int",
    "Mat,OutMat,Mat",
    "Mat,OutMat,Mat,Point",
    "Mat,OutMat,Mat,Point,int",
    "Mat,OutMat,Mat,Point,int,int",
    "Mat,OutMat,Mat,Point,int,int,Scalar",
    "Mat,OutMat,Mat",
    "Mat,OutMat,Mat,Point",
    "Mat,OutMat,Mat,Point,int",
    "Mat,OutMat,Mat,Point,int,int",
    "Mat,OutMat,Mat,Point,int,int,Scalar",
    "Mat,OutMat,int,Mat",
    "Mat,OutMat,int,Mat,Point",
    "Mat,OutMat,int,Mat,Point,int",
    "Mat,OutMat,int,Mat,Point,int,int",
    "Mat,OutMat,int,Mat,Point,int,int,Scalar",
    "Mat,OutMat,Mat,Size",
    "Mat,OutMat,Mat,Size,int",
    "Mat,OutMat,Mat,Size,int,int",
    "Mat,OutMat,Mat,Size,int,int,Scalar",
    "Mat,OutMat,Mat,Size",
    "Mat,OutMat,Mat,Size,int",
    "Mat,OutMat,Mat,Size,int,int",
    "Mat,OutMat,Mat,Size,int,int,Scalar",
    "OutMat,Point,int,Scalar",
    "OutMat,Point,int,Scalar,int",
    "OutMat,Point,int,Scalar,int,int",
    "OutMat,Point,int,Scalar,int,int,int",
    "Mat,double,Mat,double,double,OutMat",
    "Mat,double,Mat,double,double,OutMat,int",
    "Mat,OutMat,Mat,Mat,int",
    "Mat,OutMat,Mat,Mat,int,int",
    "Mat,OutMat,Mat,Mat,int,int,Scalar",
    "Point,double,double", // OutMat returned from function ...
    "Mat,OutMat",
    "Mat,Mat",
    "Mat,Mat",
    "Mat,Size,Point,OutMat",
    "Mat,Size,Point,OutMat,int",
    "Mat,OutMat,Point,double,int",
    "Mat,OutMat,Point,double,int",
    "Mat,OutMat",
    "Mat,OutMat,int",
    "Mat,OutMat",
    "Mat,OutMat,Mat",
    "Mat,OutMat",
    "Mat,OutMat,Mat",
    "Mat,Mat,OutMat",
    "Mat,Mat,OutMat,Mat",
    "Mat,OutMat,double",
    "Mat,OutMat,double,Mat",
    "OutMat,Size,int",
    "Mat,OutMat,double,double,int",
    "Mat,OutMat,double,int,int,int,double",
    "Mat,OutMat",
    "Mat,OutMat,Size",
    "Mat,OutMat,Size,int",
    "Mat,OutMat",
    "Mat,OutMat,Size",
    "Mat,OutMat,Size,int",
    "Mat,OutMat,Mat,Mat",
    "Mat,OutMat,Mat,Mat,Mat",
    "Mat", // OutMat is returned from function ...
    "Mat,Size",
    "Mat,Size,bool",
    "Mat,OutMat,Mat,Mat",
    "Mat,OutMat,Mat,Mat,Mat",
    "Mat,OutMat,Mat,Mat,Mat,Mat",
    "Mat,OutMat",
    "Mat,OutMat",
    "Mat,OutMat,double,double",
    "Mat,OutMat,int,int",
    "Mat,OutMat,int,int,int",
    "Mat,Mat,OutMat,int",
    "Mat,OutMat,int",
    "Mat,OutMat,int,int",
    "Mat,Mat,OutMat,int",
    "Mat,Mat,OutMat,int,Mat",
    "Mat,OutMat",
    "Mat,OutMat,int",
    "Mat,OutMat,int,int",
    "Mat,OutMat,int,int,int",
    "Mat,OutMat,double,bool",
    "Mat,OutMat",
    "Mat,OutMat",
    "Mat,OutMat,bool",
    "Mat,OutMat,bool,bool",
    "Mat,Mat,OutMat",
    "Mat,Mat,OutMat",
    "Mat,Mat,OutMat,bool",
    "Mat,OutMat,int,double,double,double",
    "Mat,Mat,Mat,Mat,OutMat",
    "Mat,OutMat,int",
    "Mat,OutMat,Mat",
    "OutMat,Point,Point,Scalar",
    "OutMat,Point,Point,Scalar,int",
    "OutMat,Point,Point,Scalar,int,int",
    "OutMat,Point,Point,Scalar,int,int,int",
    "OutMat,Point,Point,Scalar,int,int,int,double",
    "OutMat,Point,Size,double,double,double,Scalar",
    "OutMat,Point,Size,double,double,double,Scalar,int",
    "OutMat,Point,Size,double,double,double,Scalar,int,int",
    "OutMat,Point,Size,double,double,double,Scalar,int,int,int",
    "OutMat,Point,Scalar",
    "OutMat,Point,Scalar,int",
    "OutMat,Point,Scalar,int,int",
    "OutMat,Point,Scalar,int,int,int",
    "OutMat,Point,Scalar,int,int,int,int",
    "OutMat,Mat,Scalar",
    "OutMat,Mat,Scalar,int",
    "OutMat,Mat,Scalar,int,int",
    "OutMat,String,Point,int,double,Scalar",
    "OutMat,String,Point,int,double,Scalar,int",
    "OutMat,String,Point,int,double,Scalar,int,int",
    "OutMat,String,Point,int,double,Scalar,int,int,bool",
    "Mat,OutMat,int,int,int,int,int", // beginning Core functions
    "Mat,OutMat,int,int,int,int,int,Scalar",
    "Mat,Mat,OutMat",
    "Mat,Mat,OutMat,Mat",
    "Mat,Mat,OutMat,Mat,int",
    "Mat,Mat,OutMat",
    "Mat,Mat,OutMat,Mat",
    "Mat,Mat,OutMat,Mat,int",
    "Mat,Mat,OutMat",
    "Mat,Mat,OutMat,double",
    "Mat,Mat,OutMat,double,int",
    "Mat,Mat,OutMat",
    "Mat,Mat,OutMat,double",
    "Mat,Mat,OutMat,double,int",
    "Mat,double,Mat,OutMat",
    "Mat,OutMat",
    "Mat,Mat,OutMat",
    "Mat,OutMat",
    "Mat,OutMat,int,int",
    "Mat,OutMat,int,int,int",
    "Mat,OutMat,int",
    "Mat,OutMat,int",
    "Mat,OutMat,int",
    "Mat,int,int,OutMat",
    "Mat,Mat,OutMat",
    "Mat,Mat,OutMat",
    "Mat,Mat,OutMat",
    "Mat,Mat,OutMat,Mat",
    "Mat,Mat,OutMat",
    "Mat,Mat,OutMat,Mat",
    "Mat,Mat,OutMat",
    "Mat,Mat,OutMat,Mat",
    "Mat,OutMat",
    "Mat,OutMat,Mat",
    "Mat,Mat,OutMat",
    "Mat,Mat,Mat,OutMat",
    "Mat,Mat,OutMat,int",
    "Mat,Mat,OutMat",
    "Mat,Mat,OutMat",
    "Mat,OutMat",
    "Mat,double,OutMat",
    "Mat,OutMat",
    "Mat,OutMat",
    "Mat,Mat,OutMat",
    "Mat,Mat,OutMat,bool",
    "Mat,Mat,OutMat",
    "OutMat",
    "OutMat,double",
    "Mat,Mat,double,Mat,double,OutMat",
    "Mat,Mat,double,Mat,double,OutMat,int",
    "Mat,OutMat,bool",
    "Mat,OutMat,bool,Mat",
    "Mat,OutMat,bool,Mat,double",
    "Mat,OutMat,bool,Mat,double,int",
    "Mat,OutMat",
    "Mat,OutMat,Mat",
    "OutMat",
    "OutMat,bool",
    "OutMat",
    "OutMat,Scalar",
    "Mat,OutMat",
    "Mat,OutMat,int",
    "Mat,Mat,OutMat",
    "Mat,Mat,OutMat,int",
    "Mat,OutMat,int",
    "Mat,OutMat,int",
    "Mat,OutMat",
    "Mat,OutMat,int",
    "Mat,OutMat",
    "Mat,OutMat,int",
    "Mat,OutMat,int,int",
    "Mat,OutMat",
    "Mat,OutMat,int",
    "Mat,OutMat,int,int",
    "Mat,OutMat",
    "Mat,OutMat,int",
    "Mat,OutMat",
    "Mat,OutMat,int",
    "Mat,Mat,OutMat,int",
    "Mat,Mat,OutMat,int,bool",
    "OutMat,Mat,Mat",
    "OutMat,Mat,Mat",
    "Mat,OutMat,int",
};

typedef enum fns {
    CVTCOLOR, // beginning ImgProc functions
    CVTCOLOR2,
    LINE,
    LINE2,
    LINE3,
    LINE4,
    NORMALIZE,
    NORMALIZE2,
    NORMALIZE3,
    NORMALIZE4,
    NORMALIZE5,
    NORMALIZE6,
    CALCHIST,
    CALCBACKPROJECT,
    SUBMAT,
    CANNY,
    CANNY2,
    CANNY3,
    RELEASE,
    SOBEL,
    SOBEL2,
    SOBEL3,
    SOBEL4,
    SOBEL5,
    CONVERTSCALEABS,
    CONVERTSCALEABS2,
    CONVERTSCALEABS3,
    TRANSFORM,
    RESIZE,
    RESIZE2,
    RESIZE3,
    RESIZE4,
    RECTANGLE,
    RECTANGLE2,
    RECTANGLE3,
    RECTANGLE4,
    SETTO,
    MEDIANBLUR,
    GAUSSIANBLUR,
    GAUSSIANBLUR2,
    GAUSSIANBLUR3,
    BILATERALFILTER,
    BILATERALFILTER2,
    BOXFILTER,
    BOXFILTER2,
    BOXFILTER3,
    BOXFILTER4,
    SQRBOXFILTER,
    SQRBOXFILTER2,
    SQRBOXFILTER3,
    SQRBOXFILTER4,
    BLUR,
    BLUR2,
    BLUR3,
    FILTER2D,
    FILTER2D2,
    FILTER2D3,
    FILTER2D4,
    SEPFILTER2D,
    SEPFILTER2D2,
    SEPFILTER2D3,
    SEPFILTER2D4,
    SCHARR,
    SCHARR2,
    SCHARR3,
    SCHARR4,
    LAPLACIAN,
    LAPLACIAN2,
    LAPLACIAN3,
    LAPLACIAN4,
    LAPLACIAN5,
    CORNERMINEIGENVAL,
    CORNERMINEIGENVAL2,
    CORNERMINEIGENVAL3,
    CORNERHARRIS,
    CORNERHARRIS2,
    CORNEREIGENVALSANDVECS,
    CORNEREIGENVALSANDVECS2,
    PRECORNERDETECT,
    PRECORNERDETECT2,
    CORNERSUBPIX,
    GOODFEATURESTOTRACK,
    GOODFEATURESTOTRACK2,
    GOODFEATURESTOTRACK3,
    GOODFEATURESTOTRACK4,
    GOODFEATURESTOTRACK5,
    GOODFEATURESTOTRACK6,
    HOUGHLINES,
    HOUGHLINES2,
    HOUGHLINES3,
    HOUGHLINES4,
    HOUGHLINES5,
    HOUGHLINESP,
    HOUGHLINESP2,
    HOUGHLINESP3,
    HOUGHLINESPOINTSET,
    HOUGHCIRCLES,
    HOUGHCIRCLES2,
    HOUGHCIRCLES3,
    HOUGHCIRCLES4,
    HOUGHCIRCLES5,
    ERODE,
    ERODE2,
    ERODE3,
    ERODE4,
    ERODE5,
    DILATE,
    DILATE2,
    DILATE3,
    DILATE4,
    DILATE5,
    MORPHOLOGYEX,
    MORPHOLOGYEX2,
    MORPHOLOGYEX3,
    MORPHOLOGYEX4,
    MORPHOLOGYEX5,
    WARPAFFINE,
    WARPAFFINE2,
    WARPAFFINE3,
    WARPAFFINE4,
    WARPPERSPECTIVE,
    WARPPERSPECTIVE2,
    WARPPERSPECTIVE3,
    WARPPERSPECTIVE4,
    CIRCLE,
    CIRCLE2,
    CIRCLE3,
    CIRCLE4,
    ADDWEIGHTED,
    ADDWEIGHTED2,
    REMAP,
    REMAP2,
    REMAP3,
    GETROTATIONMATRIX2D,
    INVERTAFFINETRANSFORM,
    GETPERSPECTIVETRANSFORM,
    GETAFFINETRANSFORM,
    GETRECTSUBPIX,
    GETRECTSUBPIX2,
    LOGPOLAR,
    LINEARPOLAR,
    INTEGRAL,
    INTEGRAL2,
    ACCUMULATE,
    ACCUMULATE2,
    ACCUMULATESQUARE,
    ACCUMULATESQUARE2,
    ACCUMULATEPRODUCT,
    ACCUMULATEPRODUCT2,
    ACCUMULATEWEIGHTED,
    ACCUMULATEWEIGHTED2,
    CREATEHANNINGWINDOW,
    THRESHOLD,
    ADAPTIVETHRESHOLD,
    PYRDOWN,
    PYRDOWN2,
    PYRDOWN3,
    PYRUP,
    PYRUP2,
    PYRUP3,
    UNDISTORT,
    UNDISTORT2,
    GETDEFAULTNEWCAMERAMATRIX,
    GETDEFAULTNEWCAMERAMATRIX2,
    GETDEFAULTNEWCAMERAMATRIX3,
    UNDISTORTPOINTS,
    UNDISTORTPOINTS2,
    UNDISTORTPOINTS3,
    EQUALIZEHIST,
    WATERSHED,
    PYRMEANSHIFTFILTERING,
    DISTANCETRANSFORM,
    DISTANCETRANSFORM2,
    CVTCOLORTWOPLANE,
    DEMOSAICING,
    DEMOSAICING2,
    MATCHTEMPLATE,
    MATCHTEMPLATE2,
    CONNECTEDCOMPONENTS,
    CONNECTEDCOMPONENTS2,
    CONNECTEDCOMPONENTS3,
    CONNECTEDCOMPONENTS4,
    APPROXPOLYDP, // DP!
    MINENCLOSINGTRIANGLE,
    CONVEXHULL,
    CONVEXHULL2,
    CONVEXHULL3,
    CONVEXITYDEFECTS,
    INTERSECTCONVEXCONVEX,
    INTERSECTCONVEXCONVEX2,
    FITLINE,
    BLENDLINEAR,
    APPLYCOLORMAP,
    APPLYCOLORMAP2,
    ARROWEDLINE,
    ARROWEDLINE2,
    ARROWEDLINE3,
    ARROWEDLINE4,
    ARROWEDLINE5,
    ELLIPSE,
    ELLIPSE2,
    ELLIPSE3,
    ELLIPSE4,
    DRAWMARKER,
    DRAWMARKER2,
    DRAWMARKER3,
    DRAWMARKER4,
    DRAWMARKER5,
    FILLCONVEXPOLY,
    FILLCONVEXPOLY2,
    FILLCONVEXPOLY3,
    PUTTEXT,
    PUTTEXT2,
    PUTTEXT3,
    PUTTEXT4,
    COPYMAKEBORDER, // beginning Core functions
    COPYMAKEBORDER2,
    ADD,
    ADD2,
    ADD3,
    SUBTRACT,
    SUBTRACT2,
    SUBTRACT3,
    MULTIPLY,
    MULTIPLY2,
    MULTIPLY3,
    DIVIDE,
    DIVIDE2,
    DIVIDE3,
    SCALEADD,
    CONVERTFP16,
    LOOKUPTABLE,
    FINDNONZERO,
    REDUCE,
    REDUCE2,
    EXTRACTCHANNEL,
    INSERTCHANNEL,
    FLIP,
    REPEAT,
    HCONCAT,
    VCONCAT,
    BITWISE_AND,
    BITWISE_AND2,
    BITWISE_OR,
    BITWISE_OR2,
    BITWISE_XOR,
    BITWISE_XOR2,
    BITWISE_NOT,
    BITWISE_NOT2,
    ABSDIFF,
    INRANGE,
    COMPARE,
    MINIMUM,
    MAXIMUM,
    SQUAREROOT,
    POW,
    EXP,
    LOG,
    PHASE,
    PHASE2,
    MAGNITUDE,
    PATCHNANS,
    PATCHNANS2,
    GEMM,
    GEMM2,
    MULTRANSPOSED,
    MULTRANSPOSED2,
    MULTRANSPOSED3,
    MULTRANSPOSED4,
    TRANSPOSE,
    PERSPECTIVETRANSFORM,
    COMPLETESYMM,
    COMPLETESYMM2,
    SETIDENTITY,
    SETIDENTITY2,
    INVERT,
    INVERT2,
    SOLVE,
    SOLVE2,
    SORT,
    SORTIDX,
    SOLVECUBIC,
    SOLVEPOLY,
    DFT,
    DFT2,
    DFT3,
    IDFT,
    IDFT2,
    IDFT3,
    DCT,
    DCT2,
    IDCT,
    IDCT2,
    MULSPECTRUMS,
    MULSPECTRUMS2,
    RANDU,
    RANDN,
    ROTATE,
} ipfns;

// these were functions used in conjunction with std::variant
template <typename K>
inline K castit(ocvtypes* ocvtype) {
    return *reinterpret_cast<K*>(ocvtype);
}

inline Mat castmat(ocvtypes* ocvtype) {
    return castit<Mat>(ocvtype);
}

inline int castint(ocvtypes* ocvtype) {
    return castit<int>(ocvtype);
}

inline double castdub(ocvtypes* ocvtype) {
    return castit<double>(ocvtype);
}

inline CvPoint castpoint(ocvtypes* ocvtype) {
    return castit<CvPoint>(ocvtype);
}

inline Scalar castscalar(ocvtypes* ocvtype) {
    return castit<Scalar>(ocvtype);
}

inline CvSize castsize(ocvtypes* ocvtype) {
    return castit<CvSize>(ocvtype);
}

/** This is casting stuff that would *maybe* make this stuff simpler.
 Thee is really no way to shorten it down because you still have to have the method index number
 in any kind of templating solution ... and the existing code is more readable
 
 also std::visit is not supported until ios 12.0
 
struct MatType { };
struct IntType { };

struct Cast {
    auto cast(ocvtypes in, MatType) { return castit<Mat>(&in); }
    auto cast(ocvtypes in, IntType) { return castit<int>(&in); }
};

std::tuple<MatType,MatType,IntType> t0;
std::tuple<MatType,MatType> t1;
std::tuple<MatType,MatType,IntType> t2;

std::tuple<std::tuple<MatType,MatType,IntType>,std::tuple<MatType,MatType>,std::tuple<MatType,MatType,IntType>> allps = {
    t0,t1,t2
};
 */

// Note: std::visit or something similar may be able to be used to get rid of this huuuuge ftn.  I did not use it because it is not supported until iOS 12 ...
// if you figure out a way around this using variable arguments or something go for it!
// TODO: return arbitrary data in an NSArray instead of just one Mat ...
Mat callOpencvMethod(int index, std::vector<ocvtypes>& args, Mat dMat) {

    switch (index) {
        // Beginning of supported ImgProc functions ...
        case CVTCOLOR: {
            // auto p1 = castmat(&args[0]);
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            cvtColor(p1, p2, p3);
            return p2;
        }
        case CVTCOLOR2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].i;
            cvtColor(p1, p2, p3, p4);
            return p2;
        }
        case LINE: {
            auto p1 = args[0].m;
            auto p2 = args[1].pt;
            auto p3 = args[2].pt;
            auto p4 = args[3].sc;
            line(p1, p2, p3, p4);
            return p1;
        }
        case LINE2: {
            auto p1 = args[0].m;
            auto p2 = args[1].pt;
            auto p3 = args[2].pt;
            auto p4 = args[3].sc;
            auto p5 = args[4].i;
            line(p1, p2, p3, p4, p5);
            return p1;
        }
        case LINE3: {
            auto p1 = args[0].m;
            auto p2 = args[1].pt;
            auto p3 = args[2].pt;
            auto p4 = args[3].sc;
            auto p5 = args[4].i;
            auto p6 = args[5].i;
            line(p1, p2, p3, p4, p5, p6);
            return p1;
        }
        case LINE4: {
            auto p1 = args[0].m;
            auto p2 = args[1].pt;
            auto p3 = args[2].pt;
            auto p4 = args[3].sc;
            auto p5 = args[4].i;
            auto p6 = args[5].i;
            auto p7 = args[6].i;
            line(p1, p2, p3, p4, p5, p6, p7);
            return p1;
        }
        case NORMALIZE: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            normalize(p1, p2);
            return p2;
        }
        case NORMALIZE2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].d;
            normalize(p1, p2, p3);
            return p2;
        }
        case NORMALIZE3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].d;
            auto p4 = args[3].d;
            normalize(p1, p2, p3, p4);
            return p2;
        }
        case NORMALIZE4: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].d;
            auto p4 = args[3].d;
            auto p5 = args[4].i;
            normalize(p1, p2, p3, p4, p5);
            return p2;
        }
        case NORMALIZE5: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].d;
            auto p4 = args[3].d;
            auto p5 = args[4].i;
            auto p6 = args[5].i;
            normalize(p1, p2, p3, p4, p5, p6);
            return p2;
        }
        case NORMALIZE6: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].d;
            auto p4 = args[3].d;
            auto p5 = args[4].i;
            auto p6 = args[5].i;
            auto p7 = args[6].m;
            normalize(p1, p2, p3, p4, p5, p6, p7);
            return p2;
        }
        case CALCHIST: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].m;
            auto p5 = args[4].m;
            auto p6 = args[5].m;
            
            int channel = p2.at<int>(0,0);
            if (channel == 0) {
                channel = 2;
            }
            else if (channel == 2) {
                channel = 0;
            }
            int histSize = p5.at<int>(0,0);
            float lorange = p6.at<float>(0,0);
            float hirange = p6.at<float>(p6.cols-1,p6.rows-1) + 1; // exclusive
            float range[] = { lorange, hirange };
            
            std::vector<Mat> rgba_planes;
            split(p1, rgba_planes);
            const float* histRange = { range };
            bool uniform = true, accumulate = false;
            calcHist(&rgba_planes[channel], 1, 0, p3, p4, 1, &histSize, &histRange, uniform, accumulate);
            return p4;
        }
        case CALCBACKPROJECT: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].m;
            auto p5 = args[4].m;
            
            int channel = p2.at<int>(0,0);
            if (channel == 0) { // to maintain continuity between android and ios
                channel = 2;
            }
            else if (channel == 2) {
                channel = 0;
            }
            float lorange = p5.at<float>(0,0);
            float hirange = p5.at<float>(p5.cols-1,p5.rows-1) + 1; // exclusive
            float range[] = { lorange, hirange };
            
            std::vector<Mat> rgba_planes;
            split(p1, rgba_planes);
            const float* histRange = { range };

            calcBackProject(&rgba_planes[channel], 1, &channel, p3, p4, &histRange);
            return p4;
        }
        case SUBMAT: {
            auto p1 = args[0].d;
            auto p2 = args[1].d;
            auto p3 = args[2].d;
            auto p4 = args[3].d;
            cv::Rect rct(p3,p1,p4-p3,p2-p1);
            return dMat(rct);
        }
        case CANNY: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].d;
            auto p4 = args[3].d;
            Canny(p1, p2, p3, p4);
            return p2;
        }
        case CANNY2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].d;
            auto p4 = args[3].d;
            auto p5 = args[4].i;
            Canny(p1, p2, p3, p4, p5);
            return p2;
        }
        case CANNY3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].d;
            auto p4 = args[3].d;
            auto p5 = args[4].i;
            auto p6 = args[5].b;
            Canny(p1, p2, p3, p4, p5, p6);
            return p2;
        }
        case SOBEL: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].d;
            auto p5 = args[4].d;
            Sobel(p1, p2, p3, p4, p5);
            return p2;
        }
        case SOBEL2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].d;
            auto p5 = args[4].d;
            auto p6 = args[5].i;
            Sobel(p1, p2, p3, p4, p5, p6);
            return p2;
        }
        case SOBEL3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].d;
            auto p5 = args[4].d;
            auto p6 = args[5].i;
            auto p7 = args[6].d;
            Sobel(p1, p2, p3, p4, p5, p6, p7);
            return p2;
        }
        case SOBEL4: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].d;
            auto p5 = args[4].d;
            auto p6 = args[5].i;
            auto p7 = args[6].d;
            auto p8 = args[7].d;
            Sobel(p1, p2, p3, p4, p5, p6, p7, p8);
            return p2;
        }
        case SOBEL5: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].d;
            auto p5 = args[4].d;
            auto p6 = args[5].i;
            auto p7 = args[6].d;
            auto p8 = args[7].d;
            auto p9 = args[8].i;
            Sobel(p1, p2, p3, p4, p5, p6, p7, p8, p9);
            return p2;
        }
        case CONVERTSCALEABS: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            convertScaleAbs(p1, p2);
            return p2;
        }
        case CONVERTSCALEABS2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].d;
            convertScaleAbs(p1, p2, p3);
            return p2;
        }
        case CONVERTSCALEABS3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].d;
            auto p4 = args[3].d;
            convertScaleAbs(p1, p2, p3, p4);
            return p2;
        }
        case TRANSFORM: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            transform(p1, p2, p3);
            return p2;
        }
        case RESIZE: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].sz;
            resize(p1, p2, p3);
            return p2;
        }
        case RESIZE2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].sz;
            auto p4 = args[3].d;
            resize(p1, p2, p3, p4);
            return p2;
        }
        case RESIZE3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].sz;
            auto p4 = args[3].d;
            auto p5 = args[4].d;
            resize(p1, p2, p3, p4, p5);
            return p2;
        }
        case RESIZE4: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].sz;
            auto p4 = args[3].d;
            auto p5 = args[4].d;
            auto p6 = args[5].i;
            resize(p1, p2, p3, p4, p5, p6);
            return p2;
        }
        case RECTANGLE: {
            auto p1 = args[0].m;
            auto p2 = args[1].pt;
            auto p3 = args[2].pt;
            auto p4 = args[3].sc;
            rectangle(p1, p2, p3, p4);
            return p1;
        }
        case RECTANGLE2: {
            auto p1 = args[0].m;
            auto p2 = args[1].pt;
            auto p3 = args[2].pt;
            auto p4 = args[3].sc;
            auto p5 = args[4].i;
            rectangle(p1, p2, p3, p4, p5);
            return p1;
        }
        case RECTANGLE3: {
            auto p1 = args[0].m;
            auto p2 = args[1].pt;
            auto p3 = args[2].pt;
            auto p4 = args[3].sc;
            auto p5 = args[4].i;
            auto p6 = args[5].i;
            rectangle(p1, p2, p3, p4, p5, p6);
            return p1;
        }
        case RECTANGLE4: {
            auto p1 = args[0].m;
            auto p2 = args[1].pt;
            auto p3 = args[2].pt;
            auto p4 = args[3].sc;
            auto p5 = args[4].i;
            auto p6 = args[5].i;
            auto p7 = args[6].i;
            rectangle(p1, p2, p3, p4, p5, p6, p7);
            return p1;
        }
        case SETTO: {
            auto p1 = args[0].m;
            auto p2 = args[1].sc;
            p1 = p2;
            return p1;
        }
        case MEDIANBLUR: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            medianBlur(p1, p2, p3);
            return p2;
        }
        case GAUSSIANBLUR: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].sz;
            auto p4 = args[3].d;
            GaussianBlur(p1, p2, p3, p4);
            return p2;
        }
        case GAUSSIANBLUR2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].sz;
            auto p4 = args[3].d;
            auto p5 = args[4].d;
            GaussianBlur(p1, p2, p3, p4, p5);
            return p2;
        }
        case GAUSSIANBLUR3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].sz;
            auto p4 = args[3].d;
            auto p5 = args[4].d;
            auto p6 = args[5].i;
            GaussianBlur(p1, p2, p3, p4, p5, p6);
            return p2;
        }
        case BILATERALFILTER: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].d;
            auto p5 = args[4].d;
            bilateralFilter(p1, p2, p3, p4, p5);
            return p2;
        }
        case BILATERALFILTER2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].d;
            auto p5 = args[4].d;
            auto p6 = args[5].i;
            bilateralFilter(p1, p2, p3, p4, p5, p6);
            return p2;
        }
        case BOXFILTER: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].sz;
            boxFilter(p1, p2, p3, p4);
            return p2;
        }
        case BOXFILTER2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].sz;
            auto p5 = args[4].pt;
            boxFilter(p1, p2, p3, p4, p5);
            return p2;
        }
        case BOXFILTER3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].sz;
            auto p5 = args[4].pt;
            auto p6 = args[5].b;
            boxFilter(p1, p2, p3, p4, p5, p6);
            return p2;
        }
        case BOXFILTER4: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].sz;
            auto p5 = args[4].pt;
            auto p6 = args[5].b;
            auto p7 = args[6].i;
            boxFilter(p1, p2, p3, p4, p5, p6, p7);
            return p2;
        }
        case SQRBOXFILTER: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].sz;
            sqrBoxFilter(p1, p2, p3, p4);
            return p2;
        }
        case SQRBOXFILTER2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].sz;
            auto p5 = args[4].pt;
            sqrBoxFilter(p1, p2, p3, p4, p5);
            return p2;
        }
        case SQRBOXFILTER3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].sz;
            auto p5 = args[4].pt;
            auto p6 = args[5].b;
            sqrBoxFilter(p1, p2, p3, p4, p5, p6);
            return p2;
        }
        case SQRBOXFILTER4: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].sz;
            auto p5 = args[4].pt;
            auto p6 = args[5].b;
            auto p7 = args[6].i;
            sqrBoxFilter(p1, p2, p3, p4, p5, p6, p7);
            return p2;
        }
        case BLUR: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].sz;
            blur(p1, p2, p3);
            return p2;
        }
        case BLUR2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].sz;
            auto p4 = args[3].pt;
            blur(p1, p2, p3, p4);
            return p2;
        }
        case BLUR3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].sz;
            auto p4 = args[3].pt;
            auto p5 = args[4].i;
            blur(p1, p2, p3, p4, p5);
            return p2;
        }
        case FILTER2D: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].m;
            filter2D(p1, p2, p3, p4);
            return p2;
        }
        case FILTER2D2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].m;
            auto p5 = args[4].pt;
            filter2D(p1, p2, p3, p4, p5);
            return p2;
        }
        case FILTER2D3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].m;
            auto p5 = args[4].pt;
            auto p6 = args[5].d;
            filter2D(p1, p2, p3, p4, p5, p6);
            return p2;
        }
        case FILTER2D4: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].m;
            auto p5 = args[4].pt;
            auto p6 = args[5].d;
            auto p7 = args[6].i;
            filter2D(p1, p2, p3, p4, p5, p6, p7);
            return p2;
        }
        case SEPFILTER2D: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].m;
            auto p5 = args[4].m;
            sepFilter2D(p1, p2, p3, p4, p5);
            return p2;
        }
        case SEPFILTER2D2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].m;
            auto p5 = args[4].m;
            auto p6 = args[5].pt;
            sepFilter2D(p1, p2, p3, p4, p5, p6);
            return p2;
        }
        case SEPFILTER2D3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].m;
            auto p5 = args[4].m;
            auto p6 = args[5].pt;
            auto p7 = args[6].d;
            sepFilter2D(p1, p2, p3, p4, p5, p6, p7);
            return p2;
        }
        case SEPFILTER2D4: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].m;
            auto p5 = args[4].m;
            auto p6 = args[5].pt;
            auto p7 = args[6].d;
            auto p8 = args[7].i;
            sepFilter2D(p1, p2, p3, p4, p5, p6, p7, p8);
            return p2;
        }
        case SCHARR: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].i;
            auto p5 = args[4].i;
            Scharr(p1, p2, p3, p4, p5);
            return p2;
        }
        case SCHARR2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].i;
            auto p5 = args[4].i;
            auto p6 = args[5].d;
            Scharr(p1, p2, p3, p4, p5, p6);
            return p2;
        }
        case SCHARR3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].i;
            auto p5 = args[4].i;
            auto p6 = args[5].d;
            auto p7 = args[6].d;
            Scharr(p1, p2, p3, p4, p5, p6, p7);
            return p2;
        }
        case SCHARR4: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].i;
            auto p5 = args[4].i;
            auto p6 = args[5].d;
            auto p7 = args[6].d;
            auto p8 = args[7].i;
            Scharr(p1, p2, p3, p4, p5, p6, p7, p8);
            return p2;
        }
        case LAPLACIAN: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            Laplacian(p1, p2, p3);
            return p2;
        }
        case LAPLACIAN2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].i;
            Laplacian(p1, p2, p3, p4);
            return p2;
        }
        case LAPLACIAN3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].i;
            auto p5 = args[4].d;
            Laplacian(p1, p2, p3, p4, p5);
            return p2;
        }
        case LAPLACIAN4: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].i;
            auto p5 = args[4].d;
            auto p6 = args[5].d;
            Laplacian(p1, p2, p3, p4, p5, p6);
            return p2;
        }
        case LAPLACIAN5: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].i;
            auto p5 = args[4].d;
            auto p6 = args[5].d;
            auto p7 = args[6].i;
            Laplacian(p1, p2, p3, p4, p5, p6, p7);
            return p2;
        }
        case CORNERMINEIGENVAL: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            cornerMinEigenVal(p1, p2, p3);
            return p2;
        }
        case CORNERMINEIGENVAL2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].i;
            cornerMinEigenVal(p1, p2, p3, p4);
            return p2;
        }
        case CORNERMINEIGENVAL3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].i;
            auto p5 = args[4].i;
            cornerMinEigenVal(p1, p2, p3, p4, p5);
            return p2;
        }
        case CORNERHARRIS: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].i;
            auto p5 = args[4].d;
            cornerHarris(p1, p2, p3, p4, p5);
            return p2;
        }
        case CORNERHARRIS2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].i;
            auto p5 = args[4].d;
            auto p6 = args[5].i;
            cornerHarris(p1, p2, p3, p4, p5, p6);
            return p2;
        }
        case CORNEREIGENVALSANDVECS: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].i;
            cornerEigenValsAndVecs(p1, p2, p3, p4);
            return p2;
        }
        case CORNEREIGENVALSANDVECS2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].i;
            auto p5 = args[4].i;
            cornerEigenValsAndVecs(p1, p2, p3, p4, p5);
            return p2;
        }
        case PRECORNERDETECT: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            preCornerDetect(p1, p2, p3);
            return p2;
        }
        case PRECORNERDETECT2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].i;
            preCornerDetect(p1, p2, p3, p4);
            return p2;
        }
        case CORNERSUBPIX: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].sz;
            auto p4 = args[3].sz;
            cornerSubPix(p1, p2, p3, p4, TermCriteria());
            return p2;
        }
        case GOODFEATURESTOTRACK: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].d;
            auto p5 = args[4].d;
            goodFeaturesToTrack(p1, p2, p3, p4, p5);
            return p2;
        }
        case GOODFEATURESTOTRACK2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].d;
            auto p5 = args[4].d;
            auto p6 = args[5].m;
            goodFeaturesToTrack(p1, p2, p3, p4, p5, p6);
            return p2;
        }
        case GOODFEATURESTOTRACK3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].d;
            auto p5 = args[4].d;
            auto p6 = args[5].m;
            auto p7 = args[6].i;
            goodFeaturesToTrack(p1, p2, p3, p4, p5, p6, p7);
            return p2;
        }
        case GOODFEATURESTOTRACK4: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].d;
            auto p5 = args[4].d;
            auto p6 = args[5].m;
            auto p7 = args[6].i;
            auto p8 = args[7].i;
            goodFeaturesToTrack(p1, p2, p3, p4, p5, p6, p7, p8);
            return p2;
        }
        case GOODFEATURESTOTRACK5: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].d;
            auto p5 = args[4].d;
            auto p6 = args[5].m;
            auto p7 = args[6].i;
            auto p8 = args[7].i;
            auto p9 = args[8].b;
            goodFeaturesToTrack(p1, p2, p3, p4, p5, p6, p7, p8, p9);
            return p2;
        }
        case GOODFEATURESTOTRACK6: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].d;
            auto p5 = args[4].d;
            auto p6 = args[5].m;
            auto p7 = args[6].i;
            auto p8 = args[7].i;
            auto p9 = args[8].b;
            auto p10 = args[9].b;
            goodFeaturesToTrack(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10);
            return p2;
        }
        case HOUGHLINES: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].d;
            auto p4 = args[3].d;
            auto p5 = args[4].i;
            HoughLines(p1, p2, p3, p4, p5);
            return p2;
        }
        case HOUGHLINES2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].d;
            auto p4 = args[3].d;
            auto p5 = args[4].i;
            auto p6 = args[5].d;
            HoughLines(p1, p2, p3, p4, p5, p6);
            return p2;
        }
        case HOUGHLINES3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].d;
            auto p4 = args[3].d;
            auto p5 = args[4].i;
            auto p6 = args[5].d;
            auto p7 = args[6].d;
            HoughLines(p1, p2, p3, p4, p5, p6, p7);
            return p2;
        }
        case HOUGHLINES4: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].d;
            auto p4 = args[3].d;
            auto p5 = args[4].i;
            auto p6 = args[5].d;
            auto p7 = args[6].d;
            auto p8 = args[7].d;
            HoughLines(p1, p2, p3, p4, p5, p6, p7, p8);
            return p2;
        }
        case HOUGHLINES5: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].d;
            auto p4 = args[3].d;
            auto p5 = args[4].i;
            auto p6 = args[5].d;
            auto p7 = args[6].d;
            auto p8 = args[7].d;
            auto p9 = args[8].d;
            HoughLines(p1, p2, p3, p4, p5, p6, p7, p8, p9);
            return p2;
        }
        case HOUGHLINESP: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].d;
            auto p4 = args[3].d;
            auto p5 = args[4].i;
            HoughLinesP(p1, p2, p3, p4, p5);
            return p2;
        }
        case HOUGHLINESP2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].d;
            auto p4 = args[3].d;
            auto p5 = args[4].i;
            auto p6 = args[5].d;
            HoughLinesP(p1, p2, p3, p4, p5, p6);
            return p2;
        }
        case HOUGHLINESP3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].d;
            auto p4 = args[3].d;
            auto p5 = args[4].i;
            auto p6 = args[5].d;
            auto p7 = args[6].d;
            HoughLinesP(p1, p2, p3, p4, p5, p6, p7);
            return p2;
        }
        case HOUGHLINESPOINTSET: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].i;
            auto p5 = args[4].d;
            auto p6 = args[5].d;
            auto p7 = args[6].d;
            auto p8 = args[7].d;
            auto p9 = args[8].d;
            auto p10 = args[9].d;
            HoughLinesPointSet(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10);
            return p2;
        }
        case HOUGHCIRCLES: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].d;
            auto p5 = args[4].d;
            HoughCircles(p1, p2, p3, p4, p5);
            return p2;
        }
        case HOUGHCIRCLES2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].d;
            auto p5 = args[4].d;
            auto p6 = args[5].d;
            HoughCircles(p1, p2, p3, p4, p5, p6);
            return p2;
        }
        case HOUGHCIRCLES3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].d;
            auto p5 = args[4].d;
            auto p6 = args[5].d;
            auto p7 = args[6].d;
            HoughCircles(p1, p2, p3, p4, p5, p6, p7);
            return p2;
        }
        case HOUGHCIRCLES4: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].d;
            auto p5 = args[4].d;
            auto p6 = args[5].d;
            auto p7 = args[6].d;
            auto p8 = args[7].i;
            HoughCircles(p1, p2, p3, p4, p5, p6, p7, p8);
            return p2;
        }
        case HOUGHCIRCLES5: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].d;
            auto p5 = args[4].d;
            auto p6 = args[5].d;
            auto p7 = args[6].d;
            auto p8 = args[7].i;
            auto p9 = args[8].i;
            HoughCircles(p1, p2, p3, p4, p5, p6, p7, p8, p9);
            return p2;
        }
        case ERODE: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            erode(p1, p2, p3);
            return p2;
        }
        case ERODE2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].pt;
            erode(p1, p2, p3, p4);
            return p2;
        }
        case ERODE3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].pt;
            auto p5 = args[4].i;
            erode(p1, p2, p3, p4, p5);
            return p2;
        }
        case ERODE4: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].pt;
            auto p5 = args[4].i;
            auto p6 = args[5].i;
            erode(p1, p2, p3, p4, p5, p6);
            return p2;
        }
        case ERODE5: { //100
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].pt;
            auto p5 = args[4].i;
            auto p6 = args[5].i;
            auto p7 = args[6].sc;
            erode(p1, p2, p3, p4, p5, p6, p7);
            return p2;
        }
        case DILATE: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            dilate(p1, p2, p3);
            return p2;
        }
        case DILATE2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].pt;
            dilate(p1, p2, p3, p4);
            return p2;
        }
        case DILATE3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].pt;
            auto p5 = args[4].i;
            dilate(p1, p2, p3, p4, p5);
            return p2;
        }
        case DILATE4: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].pt;
            auto p5 = args[4].i;
            auto p6 = args[5].i;
            dilate(p1, p2, p3, p4, p5, p6);
            return p2;
        }
        case DILATE5: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].pt;
            auto p5 = args[4].i;
            auto p6 = args[5].i;
            auto p7 = args[6].sc;
            dilate(p1, p2, p3, p4, p5, p6, p7);
            return p2;
        }
        case MORPHOLOGYEX: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].m;
            morphologyEx(p1, p2, p3, p4);
            return p2;
        }
        case MORPHOLOGYEX2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].m;
            auto p5 = args[4].pt;
            morphologyEx(p1, p2, p3, p4, p5);
            return p2;
        }
        case MORPHOLOGYEX3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].m;
            auto p5 = args[4].pt;
            auto p6 = args[5].i;
            morphologyEx(p1, p2, p3, p4, p5, p6);
            return p2;
        }
        case MORPHOLOGYEX4: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].m;
            auto p5 = args[4].pt;
            auto p6 = args[5].i;
            auto p7 = args[6].i;
            morphologyEx(p1, p2, p3, p4, p5, p6, p7);
            return p2;
        }
        case MORPHOLOGYEX5: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].m;
            auto p5 = args[4].pt;
            auto p6 = args[5].i;
            auto p7 = args[6].i;
            auto p8 = args[7].sc;
            morphologyEx(p1, p2, p3, p4, p5, p6, p7, p8);
            return p2;
        }
        case WARPAFFINE: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].sz;
            warpAffine(p1, p2, p3, p4);
            return p2;
        }
        case WARPAFFINE2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].sz;
            auto p5 = args[4].i;
            warpAffine(p1, p2, p3, p4, p5);
            return p2;
        }
        case WARPAFFINE3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].sz;
            auto p5 = args[4].i;
            auto p6 = args[5].i;
            warpAffine(p1, p2, p3, p4, p5, p6);
            return p2;
        }
        case WARPAFFINE4: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].sz;
            auto p5 = args[4].i;
            auto p6 = args[5].i;
            auto p7 = args[6].sc;
            warpAffine(p1, p2, p3, p4, p5, p6, p7);
            return p2;
        }
        case WARPPERSPECTIVE: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].sz;
            warpPerspective(p1, p2, p3, p4);
            return p2;
        }
        case WARPPERSPECTIVE2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].sz;
            auto p5 = args[4].i;
            warpPerspective(p1, p2, p3, p4, p5);
            return p2;
        }
        case WARPPERSPECTIVE3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].sz;
            auto p5 = args[4].i;
            auto p6 = args[5].i;
            warpPerspective(p1, p2, p3, p4, p5, p6);
            return p2;
        }
        case WARPPERSPECTIVE4: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].sz;
            auto p5 = args[4].i;
            auto p6 = args[5].i;
            auto p7 = args[6].sc;
            warpPerspective(p1, p2, p3, p4, p5, p6, p7);
            return p2;
        }
        case CIRCLE: {
            auto p1 = args[0].m;
            auto p2 = args[1].pt;
            auto p3 = args[2].i;
            auto p4 = args[3].sc;
            circle(p1, p2, p3, p4);
            return p1;
        }
        case CIRCLE2: {
            auto p1 = args[0].m;
            auto p2 = args[1].pt;
            auto p3 = args[2].i;
            auto p4 = args[3].sc;
            auto p5 = args[4].i;
            circle(p1, p2, p3, p4, p5);
            return p1;
        }
        case CIRCLE3: {
            auto p1 = args[0].m;
            auto p2 = args[1].pt;
            auto p3 = args[2].i;
            auto p4 = args[3].sc;
            auto p5 = args[4].i;
            auto p6 = args[5].i;
            circle(p1, p2, p3, p4, p5, p6);
            return p1;
        }
        case CIRCLE4: {
            auto p1 = args[0].m;
            auto p2 = args[1].pt;
            auto p3 = args[2].i;
            auto p4 = args[3].sc;
            auto p5 = args[4].i;
            auto p6 = args[5].i;
            auto p7 = args[6].i;
            circle(p1, p2, p3, p4, p5, p6, p7);
            return p1;
        }
        case ADDWEIGHTED: {
            auto p1 = args[0].m;
            auto p2 = args[1].d;
            auto p3 = args[2].m;
            auto p4 = args[3].d;
            auto p5 = args[4].d;
            auto p6 = args[5].m;
            addWeighted(p1, p2, p3, p4, p5, p6);
            return p6;
        }
        case ADDWEIGHTED2: {
            auto p1 = args[0].m;
            auto p2 = args[1].d;
            auto p3 = args[2].m;
            auto p4 = args[3].d;
            auto p5 = args[4].d;
            auto p6 = args[5].m;
            auto p7 = args[6].i;
            addWeighted(p1, p2, p3, p4, p5, p6, p7);
            return p6;
        }
        case REMAP: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].m;
            auto p5 = args[4].i;
            remap(p1, p2, p3, p4, p5);
            return p2;
        }
        case REMAP2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].m;
            auto p5 = args[4].i;
            auto p6 = args[5].i;
            remap(p1, p2, p3, p4, p5, p6);
            return p2;
        }
        case REMAP3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].m;
            auto p5 = args[4].i;
            auto p6 = args[5].i;
            auto p7 = args[6].sc;
            remap(p1, p2, p3, p4, p5, p6, p7);
            return p2;
        }
        case GETROTATIONMATRIX2D: {
            auto p1 = args[0].pt;
            auto p2 = args[1].d;
            auto p3 = args[2].d;
            auto p4 = getRotationMatrix2D(p1, p2, p3);
            return p4;
        }
        case INVERTAFFINETRANSFORM: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            invertAffineTransform(p1, p2);
            return p2;
        }
        case GETPERSPECTIVETRANSFORM: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = getPerspectiveTransform(p1, p2);
            return p3;
        }
        case GETAFFINETRANSFORM: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = getAffineTransform(p1, p2);
            return p3;
        }
        case GETRECTSUBPIX: {
            auto p1 = args[0].m;
            auto p2 = args[1].sz;
            auto p3 = args[2].pt;
            auto p4 = args[3].m;
            getRectSubPix(p1, p2, p3, p4);
            return p4;
        }
        case GETRECTSUBPIX2: {
            auto p1 = args[0].m;
            auto p2 = args[1].sz;
            auto p3 = args[2].pt;
            auto p4 = args[3].m;
            auto p5 = args[4].i;
            getRectSubPix(p1, p2, p3, p4, p5);
            return p4;
        }
        case LOGPOLAR: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].pt;
            auto p4 = args[3].d;
            auto p5 = args[4].i;
            logPolar(p1, p2, p3, p4, p5);
            return p2;
        }
        case LINEARPOLAR: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].pt;
            auto p4 = args[3].d;
            auto p5 = args[4].i;
            linearPolar(p1, p2, p3, p4, p5);
            return p2;
        }
        case INTEGRAL: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            integral(p1, p2);
            return p2;
        }
        case INTEGRAL2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            integral(p1, p2, p3);
            return p2;
        }
        case ACCUMULATE: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            accumulate(p1, p2);
            return p2;
        }
        case ACCUMULATE2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            accumulate(p1, p2, p3);
            return p2;
        }
        case ACCUMULATESQUARE: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            accumulateSquare(p1, p2);
            return p2;
        }
        case ACCUMULATESQUARE2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            accumulateSquare(p1, p2, p3);
            return p2;
        }
        case ACCUMULATEPRODUCT: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            accumulateProduct(p1, p2, p3);
            return p3;
        }
        case ACCUMULATEPRODUCT2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].m;
            accumulateProduct(p1, p2, p3, p4);
            return p3;
        }
        case ACCUMULATEWEIGHTED: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].d;
            accumulateWeighted(p1, p2, p3);
            return p2;
        }
        case ACCUMULATEWEIGHTED2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].d;
            auto p4 = args[3].m;
            accumulateWeighted(p1, p2, p3, p4);
            return p2;
        }
        case CREATEHANNINGWINDOW: {
            auto p1 = args[0].m;
            auto p2 = args[1].sz;
            auto p3 = args[2].i;
            createHanningWindow(p1, p2, p3);
            return p1;
        }
        case THRESHOLD: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].d;
            auto p4 = args[3].d;
            auto p5 = args[4].i;
            threshold(p1, p2, p3, p4, p5);
            return p2;
        }
        case ADAPTIVETHRESHOLD: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].d;
            auto p4 = args[3].i;
            auto p5 = args[4].i;
            auto p6 = args[5].i;
            auto p7 = args[6].d;
            adaptiveThreshold(p1, p2, p3, p4, p5, p6, p7);
            return p2;
        }
        case PYRDOWN: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            pyrDown(p1, p2);
            return p2;
        }
        case PYRDOWN2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].sz;
            pyrDown(p1, p2, p3);
            return p2;
        }
        case PYRDOWN3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].sz;
            auto p4 = args[3].i;
            pyrDown(p1, p2, p3, p4);
            return p2;
        }
        case PYRUP: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            pyrUp(p1, p2);
            return p2;
        }
        case PYRUP2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].sz;
            pyrUp(p1, p2, p3);
            return p2;
        }
        case PYRUP3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].sz;
            auto p4 = args[3].i;
            pyrUp(p1, p2, p3, p4);
            return p2;
        }
        case UNDISTORT: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].m;
            undistort(p1, p2, p3, p4);
            return p2;
        }
        case UNDISTORT2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].m;
            auto p5 = args[4].m;
            undistort(p1, p2, p3, p4, p5);
            return p2;
        }
        case GETDEFAULTNEWCAMERAMATRIX: {
            auto p1 = args[0].m;
            auto p2 = getDefaultNewCameraMatrix(p1);
            return p2;
        }
        case GETDEFAULTNEWCAMERAMATRIX2: {
            auto p1 = args[0].m;
            auto p2 = args[1].sz;
            auto p3 = getDefaultNewCameraMatrix(p1, p2);
            return p3;
        }
        case GETDEFAULTNEWCAMERAMATRIX3: {
            auto p1 = args[0].m;
            auto p2 = args[1].sz;
            auto p3 = args[2].b;
            auto p4 = getDefaultNewCameraMatrix(p1, p2, p3);
            return p4;
        }
        case UNDISTORTPOINTS: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].m;
            undistortPoints(p1, p2, p3, p4);
            return p2;
        }
        case UNDISTORTPOINTS2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].m;
            auto p5 = args[4].m;
            undistortPoints(p1, p2, p3, p4, p5);
            return p2;
        }
        case UNDISTORTPOINTS3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].m;
            auto p5 = args[4].m;
            auto p6 = args[5].m;
            undistortPoints(p1, p2, p3, p4, p5, p6);
            return p2;
        }
        case EQUALIZEHIST: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            equalizeHist(p1, p2);
            return p2;
        }
        case WATERSHED: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            watershed(p1, p2);
            return p2;
        }
        case PYRMEANSHIFTFILTERING: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].d;
            auto p4 = args[3].d;
            pyrMeanShiftFiltering(p1, p2, p3, p4);
            return p2;
        }
        case DISTANCETRANSFORM: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].i;
            distanceTransform(p1, p2, p3, p4);
            return p2;
        }
        case DISTANCETRANSFORM2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].i;
            auto p5 = args[4].i;
            distanceTransform(p1, p2, p3, p4, p5);
            return p2;
        }
        case CVTCOLORTWOPLANE: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].i;
            cvtColorTwoPlane(p1, p2, p3, p4);
            return p3;
        }
        case DEMOSAICING: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            demosaicing(p1, p2, p3);
            return p2;
        }
        case DEMOSAICING2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].i;
            demosaicing(p1, p2, p3, p4);
            return p2;
        }
        case MATCHTEMPLATE: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].i;
            matchTemplate(p1, p2, p3, p4);
            return p3;
        }
        case MATCHTEMPLATE2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].i;
            auto p5 = args[4].m;
            matchTemplate(p1, p2, p3, p4, p5);
            return p3;
        }
        case CONNECTEDCOMPONENTS: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            connectedComponents(p1, p2);
            return p2;
        }
        case CONNECTEDCOMPONENTS2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            connectedComponents(p1, p2, p3);
            return p2;
        }
        case CONNECTEDCOMPONENTS3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].i;
            connectedComponents(p1, p2, p3, p4);
            return p2;
        }
        case CONNECTEDCOMPONENTS4: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].i;
            auto p5 = args[4].i;
            connectedComponents(p1, p2, p3, p4, p5);
            return p2;
        }
        case APPROXPOLYDP: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].d;
            auto p4 = args[3].b;
            approxPolyDP(p1, p2, p3, p4);
            return p2;
        }
        case MINENCLOSINGTRIANGLE: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            minEnclosingTriangle(p1, p2);
            return p2;
        }
        case CONVEXHULL: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            convexHull(p1, p2);
            return p2;
        }
        case CONVEXHULL2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].b;
            convexHull(p1, p2, p3);
            return p2;
        }
        case CONVEXHULL3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].b;
            auto p4 = args[3].b;
            convexHull(p1, p2, p3, p4);
            return p2;
        }
        case CONVEXITYDEFECTS: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            convexityDefects(p1, p2, p3);
            return p3;
        }
        case INTERSECTCONVEXCONVEX: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            intersectConvexConvex(p1, p2, p3);
            return p3;
        }
        case INTERSECTCONVEXCONVEX2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].b;
            intersectConvexConvex(p1, p2, p3, p4);
            return p2;
        }
        case FITLINE: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].d;
            auto p5 = args[4].d;
            auto p6 = args[5].d;
            fitLine(p1, p2, p3, p4, p5, p6);
            return p2;
        }
        case BLENDLINEAR: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].m;
            auto p5 = args[4].m;
            blendLinear(p1, p2, p3, p4, p5);
            return p5;
        }
        case APPLYCOLORMAP: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            applyColorMap(p1, p2, p3);
            return p2;
        }
        case APPLYCOLORMAP2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            applyColorMap(p1, p2, p3);
            return p2;
        }
        case ARROWEDLINE: {
            auto p1 = args[0].m;
            auto p2 = args[1].pt;
            auto p3 = args[2].pt;
            auto p4 = args[3].sc;
            arrowedLine(p1, p2, p3, p4);
            return p1;
        }
        case ARROWEDLINE2: {
            auto p1 = args[0].m;
            auto p2 = args[1].pt;
            auto p3 = args[2].pt;
            auto p4 = args[3].sc;
            auto p5 = args[4].i;
            arrowedLine(p1, p2, p3, p4, p5);
            return p1;
        }
        case ARROWEDLINE3: {
            auto p1 = args[0].m;
            auto p2 = args[1].pt;
            auto p3 = args[2].pt;
            auto p4 = args[3].sc;
            auto p5 = args[4].i;
            auto p6 = args[5].i;
            arrowedLine(p1, p2, p3, p4, p5, p6);
            return p1;
        }
        case ARROWEDLINE4: {
            auto p1 = args[0].m;
            auto p2 = args[1].pt;
            auto p3 = args[2].pt;
            auto p4 = args[3].sc;
            auto p5 = args[4].i;
            auto p6 = args[5].i;
            auto p7 = args[6].i;
            arrowedLine(p1, p2, p3, p4, p5, p6, p7);
            return p1;
        }
        case ARROWEDLINE5: {
            auto p1 = args[0].m;
            auto p2 = args[1].pt;
            auto p3 = args[2].pt;
            auto p4 = args[3].sc;
            auto p5 = args[4].i;
            auto p6 = args[5].i;
            auto p7 = args[6].i;
            auto p8 = args[7].d;
            arrowedLine(p1, p2, p3, p4, p5, p6, p7, p8);
            return p1;
        }
        case ELLIPSE: {
            auto p1 = args[0].m;
            auto p2 = args[1].pt;
            auto p3 = args[2].sz;
            auto p4 = args[3].d;
            auto p5 = args[4].d;
            auto p6 = args[5].d;
            auto p7 = args[6].sc;
            ellipse(p1, p2, p3, p4, p5, p6, p7);
            return p1;
        }
        case ELLIPSE2: {
            auto p1 = args[0].m;
            auto p2 = args[1].pt;
            auto p3 = args[2].sz;
            auto p4 = args[3].d;
            auto p5 = args[4].d;
            auto p6 = args[5].d;
            auto p7 = args[6].sc;
            auto p8 = args[7].i;
            ellipse(p1, p2, p3, p4, p5, p6, p7, p8);
            return p1;
        }
        case ELLIPSE3: {
            auto p1 = args[0].m;
            auto p2 = args[1].pt;
            auto p3 = args[2].sz;
            auto p4 = args[3].d;
            auto p5 = args[4].d;
            auto p6 = args[5].d;
            auto p7 = args[6].sc;
            auto p8 = args[7].i;
            auto p9 = args[8].i;
            ellipse(p1, p2, p3, p4, p5, p6, p7, p8, p9);
            return p1;
        }
        case ELLIPSE4: {
            auto p1 = args[0].m;
            auto p2 = args[1].pt;
            auto p3 = args[2].sz;
            auto p4 = args[3].d;
            auto p5 = args[4].d;
            auto p6 = args[5].d;
            auto p7 = args[6].sc;
            auto p8 = args[7].i;
            auto p9 = args[8].i;
            auto p10 = args[9].i;
            ellipse(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10);
            return p1;
        }
        case DRAWMARKER: {
            auto p1 = args[0].m;
            auto p2 = args[1].pt;
            auto p3 = args[2].sc;
            drawMarker(p1, p2, p3);
            return p1;
        }
        case DRAWMARKER2: {
            auto p1 = args[0].m;
            auto p2 = args[1].pt;
            auto p3 = args[2].sc;
            auto p4 = args[3].i;
            drawMarker(p1, p2, p3, p4);
            return p1;
        }
        case DRAWMARKER3: {
            auto p1 = args[0].m;
            auto p2 = args[1].pt;
            auto p3 = args[2].sc;
            auto p4 = args[3].i;
            auto p5 = args[4].i;
            drawMarker(p1, p2, p3, p4, p5);
            return p1;
        }
        case DRAWMARKER4: {
            auto p1 = args[0].m;
            auto p2 = args[1].pt;
            auto p3 = args[2].sc;
            auto p4 = args[3].i;
            auto p5 = args[4].i;
            auto p6 = args[5].i;
            drawMarker(p1, p2, p3, p4, p5, p6);
            return p1;
        }
        case DRAWMARKER5: {
            auto p1 = args[0].m;
            auto p2 = args[1].pt;
            auto p3 = args[2].sc;
            auto p4 = args[3].i;
            auto p5 = args[4].i;
            auto p6 = args[5].i;
            auto p7 = args[6].i;
            drawMarker(p1, p2, p3, p4, p5, p6, p7);
            return p1;
        }
        case FILLCONVEXPOLY: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].sc;
            fillConvexPoly(p1, p2, p3);
            return p1;
        }
        case FILLCONVEXPOLY2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].sc;
            auto p4 = args[3].i;
            fillConvexPoly(p1, p2, p3, p4);
            return p1;
        }
        case FILLCONVEXPOLY3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].sc;
            auto p4 = args[3].i;
            auto p5 = args[4].i;
            fillConvexPoly(p1, p2, p3, p4, p5);
            return p1;
        }
        case PUTTEXT: {
            auto p1 = args[0].m;
            auto p2 = args[1].str;
            auto p3 = args[2].pt;
            auto p4 = args[3].i;
            auto p5 = args[4].d;
            auto p6 = args[5].sc;
            putText(p1, p2, p3, p4, p5, p6);
            return p1;
        }
        case PUTTEXT2: {
            auto p1 = args[0].m;
            auto p2 = args[1].str;
            auto p3 = args[2].pt;
            auto p4 = args[3].i;
            auto p5 = args[4].d;
            auto p6 = args[5].sc;
            auto p7 = args[6].i;
            putText(p1, p2, p3, p4, p5, p6, p7);
            return p1;
        }
        case PUTTEXT3: {
            auto p1 = args[0].m;
            auto p2 = args[1].str;
            auto p3 = args[2].pt;
            auto p4 = args[3].i;
            auto p5 = args[4].d;
            auto p6 = args[5].sc;
            auto p7 = args[6].i;
            auto p8 = args[7].i;
            putText(p1, p2, p3, p4, p5, p6, p7, p8);
            return p1;
        }
        case PUTTEXT4: {
            auto p1 = args[0].m;
            auto p2 = args[1].str;
            auto p3 = args[2].pt;
            auto p4 = args[3].i;
            auto p5 = args[4].d;
            auto p6 = args[5].sc;
            auto p7 = args[6].i;
            auto p8 = args[7].i;
            auto p9 = args[8].b;
            putText(p1, p2, p3, p4, p5, p6, p7, p8, p9);
            return p1;
        }
        case COPYMAKEBORDER: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].i;
            auto p5 = args[4].i;
            auto p6 = args[5].i;
            auto p7 = args[6].i;
            copyMakeBorder(p1, p2, p3, p4, p5, p6, p7);
            return p2;
        }
        case COPYMAKEBORDER2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].i;
            auto p5 = args[4].i;
            auto p6 = args[5].i;
            auto p7 = args[6].i;
            auto p8 = args[7].sc;
            copyMakeBorder(p1, p2, p3, p4, p5, p6, p7, p8);
            return p2;
        }
        case ADD: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            add(p1, p2, p3);
            return p3;
        }
        case ADD2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].m;
            add(p1, p2, p3, p4);
            return p3;
        }
        case ADD3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].m;
            auto p5 = args[4].i;
            add(p1, p2, p3, p4, p5);
            return p3;
        }
        case SUBTRACT: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            subtract(p1, p2, p3);
            return p3;
        }
        case SUBTRACT2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].m;
            subtract(p1, p2, p3, p4);
            return p3;
        }
        case SUBTRACT3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].m;
            auto p5 = args[4].i;
            subtract(p1, p2, p3, p4, p5);
            return p3;
        }
        case MULTIPLY: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            multiply(p1, p2, p3);
            return p3;
        }
        case MULTIPLY2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].d;
            multiply(p1, p2, p3, p4);
            return p3;
        }
        case MULTIPLY3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].d;
            auto p5 = args[4].i;
            multiply(p1, p2, p3, p4, p5);
            return p3;
        }
        case DIVIDE: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            divide(p1, p2, p3);
            return p3;
        }
        case DIVIDE2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].d;
            divide(p1, p2, p3, p4);
            return p3;
        }
        case DIVIDE3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].d;
            auto p5 = args[4].i;
            divide(p1, p2, p3, p4, p5);
            return p3;
        }
        case SCALEADD: {
            auto p1 = args[0].m;
            auto p2 = args[1].d;
            auto p3 = args[2].m;
            auto p4 = args[3].m;
            scaleAdd(p1, p2, p3, p4);
            return p4;
        }
        case CONVERTFP16: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            convertFp16(p1, p2);
            return p2;
        }
        case LOOKUPTABLE: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            LUT(p1, p2, p3);
            return p3;
        }
        case FINDNONZERO: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            findNonZero(p1, p2);
            return p2;
        }
        case REDUCE: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].i;
            reduce(p1, p2, p3, p4);
            return p2;
        }
        case REDUCE2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].i;
            auto p5 = args[4].i;
            reduce(p1, p2, p3, p4, p5);
            return p2;
        }
        case EXTRACTCHANNEL: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            extractChannel(p1, p2, p3);
            return p2;
        }
        case INSERTCHANNEL: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            insertChannel(p1, p2, p3);
            return p2;
        }
        case FLIP: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            flip(p1, p2, p3);
            return p2;
        }
        case REPEAT: {
            auto p1 = args[0].m;
            auto p2 = args[1].i;
            auto p3 = args[2].i;
            auto p4 = args[3].m;
            repeat(p1, p2, p3, p4);
            return p4;
        }
        case HCONCAT: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            hconcat(p1, p2, p3);
            return p3;
        }
        case VCONCAT: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            vconcat(p1, p2, p3);
            return p3;
        }
        case BITWISE_AND: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            bitwise_and(p1, p2, p3);
            return p3;
        }
        case BITWISE_AND2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].m;
            bitwise_and(p1, p2, p3, p4);
            return p3;
        }
        case BITWISE_OR: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            bitwise_or(p1, p2, p3);
            return p3;
        }
        case BITWISE_OR2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].m;
            bitwise_or(p1, p2, p3, p4);
            return p3;
        }
        case BITWISE_XOR: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            bitwise_xor(p1, p2, p3);
            return p3;
        }
        case BITWISE_XOR2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].m;
            bitwise_xor(p1, p2, p3, p4);
            return p3;
        }
        case BITWISE_NOT: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            bitwise_not(p1, p2);
            return p2;
        }
        case BITWISE_NOT2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            bitwise_not(p1, p2, p3);
            return p2;
        }
        case ABSDIFF: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            absdiff(p1, p2, p3);
            return p3;
        }
        case INRANGE: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].m;
            inRange(p1, p2, p3, p4);
            return p4;
        }
        case COMPARE: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].i;
            compare(p1, p2, p3, p4);
            return p3;
        }
        case MINIMUM: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            min(p1, p2, p3);
            return p3;
        }
        case MAXIMUM: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            max(p1, p2, p3);
            return p3;
        }
        case SQUAREROOT: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            sqrt(p1, p2);
            return p2;
        }
        case POW: {
            auto p1 = args[0].m;
            auto p2 = args[1].d;
            auto p3 = args[2].m;
            pow(p1, p2, p3);
            return p3;
        }
        case EXP: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            exp(p1, p2);
            return p2;
        }
        case LOG: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            log(p1, p2);
            return p2;
        }
        case PHASE: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            phase(p1, p2, p3);
            return p3;
        }
        case PHASE2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].b;
            phase(p1, p2, p3, p4);
            return p3;
        }
        case MAGNITUDE: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            magnitude(p1, p2, p3);
            return p3;
        }
        case PATCHNANS: {
            auto p1 = args[0].m;
            patchNaNs(p1);
            return p1;
        }
        case PATCHNANS2: {
            auto p1 = args[0].m;
            auto p2 = args[1].d;
            patchNaNs(p1, p2);
            return p1;
        }
        case GEMM: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].d;
            auto p4 = args[3].m;
            auto p5 = args[4].d;
            auto p6 = args[5].m;
            gemm(p1, p2, p3, p4, p5, p6);
            return p6;
        }
        case GEMM2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].d;
            auto p4 = args[3].m;
            auto p5 = args[4].d;
            auto p6 = args[5].m;
            auto p7 = args[6].i;
            gemm(p1, p2, p3, p4, p5, p6, p7);
            return p6;
        }
        case MULTRANSPOSED: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].b;
            mulTransposed(p1, p2, p3);
            return p2;
        }
        case MULTRANSPOSED2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].b;
            auto p4 = args[3].m;
            mulTransposed(p1, p2, p3, p4);
            return p2;
        }
        case MULTRANSPOSED3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].b;
            auto p4 = args[3].m;
            auto p5 = args[4].d;
            mulTransposed(p1, p2, p3, p4, p5);
            return p2;
        }
        case MULTRANSPOSED4: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].b;
            auto p4 = args[3].m;
            auto p5 = args[4].d;
            auto p6 = args[5].i;
            mulTransposed(p1, p2, p3, p4, p5, p6);
            return p2;
        }
        case TRANSPOSE: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            transpose(p1, p2);
            return p2;
        }
        case PERSPECTIVETRANSFORM: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            perspectiveTransform(p1, p2, p3);
            return p2;
        }
        case COMPLETESYMM: {
            auto p1 = args[0].m;
            completeSymm(p1);
            return p1;
        }
        case COMPLETESYMM2: {
            auto p1 = args[0].m;
            auto p2 = args[1].b;
            completeSymm(p1, p2);
            return p1;
        }
        case SETIDENTITY: {
            auto p1 = args[0].m;
            setIdentity(p1);
            return p1;
        }
        case SETIDENTITY2: {
            auto p1 = args[0].m;
            auto p2 = args[1].sc;
            setIdentity(p1, p2);
            return p1;
        }
        case INVERT: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            invert(p1, p2);
            return p2;
        }
        case INVERT2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            invert(p1, p2, p3);
            return p2;
        }
        case SOLVE: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            solve(p1, p2, p3);
            return p3;
        }
        case SOLVE2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].i;
            solve(p1, p2, p3, p4);
            return p3;
        }
        case SORT: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            sort(p1, p2, p3);
            return p2;
        }
        case SORTIDX: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            sortIdx(p1, p2, p3);
            return p2;
        }
        case SOLVECUBIC: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            solveCubic(p1, p2);
            return p2;
        }
        case SOLVEPOLY: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            solvePoly(p1, p2, p3);
            return p2;
        }
        case DFT: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            dft(p1, p2);
            return p2;
        }
        case DFT2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            dft(p1, p2, p3);
            return p2;
        }
        case DFT3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].i;
            dft(p1, p2, p3, p4);
            return p2;
        }
        case IDFT: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            idft(p1, p2);
            return p2;
        }
        case IDFT2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            idft(p1, p2, p3);
            return p2;
        }
        case IDFT3: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].i;
            idft(p1, p2, p3, p4);
            return p2;
        }
        case DCT: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            dct(p1, p2);
            return p2;
        }
        case DCT2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            dct(p1, p2, p3);
            return p2;
        }
        case IDCT: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            idct(p1, p2);
            return p2;
        }
        case IDCT2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            idct(p1, p2, p3);
            return p2;
        }
        case MULSPECTRUMS: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].i;
            mulSpectrums(p1, p2, p3, p4);
            return p3;
        }
        case MULSPECTRUMS2: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            auto p4 = args[3].i;
            auto p5 = args[4].b;
            mulSpectrums(p1, p2, p3, p4, p5);
            return p3;
        }
        case RANDU: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            randu(p1, p2, p3);
            return p1;
        }
        case RANDN: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].m;
            randn(p1, p2, p3);
            return p1;
        }
        case ROTATE: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            rotate(p1, p2, p3);
            return p2;
        }

    }
    return Mat();
}


