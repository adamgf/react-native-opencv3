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
    "cvtColor",
    "cvtColor",
    "bitwise_not",
    "rotate",
    "line",
    "normalize",
    "calcHist",
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
    "transform",
    "resize",
    "resize",
    "resize",
    "resize",
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
    "warpPerspective"
};

std::vector<std::string> types = {
    "Mat,OutMat,int",
    "Mat,OutMat,int,int",
    "Mat,OutMat",
    "Mat,OutMat,int",
    "OutMat,Point,Point,Scalar,int",
    "Mat,OutMat,double,double,int",
    "Mat,MatOfInt,Mat,OutMat,MatOfInt,MatOfFloat",
    "double,double,double,double",
    "Mat,OutMat,double,double",
    "Mat,OutMat,double,double,int",
    "Mat,OutMat,double,double,int,bool",
    "",
    "Mat,OutMat,int,double,double",
    "Mat,OutMat,int,double,double,int",
    "Mat,OutMat,int,double,double,int,double",
    "Mat,OutMat,int,double,double,int,double,double",
    "Mat,OutMat,int,double,double,int,double,double,int",
    "Mat,OutMat,double,double",
    "Mat,OutMat,Mat",
    "Mat,OutMat,Size",
    "Mat,OutMat,Size,double",
    "Mat,OutMat,Size,double,double",
    "Mat,OutMat,Size,double,double,int",
    "OutMat,Point,Point,Scalar,int",
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
    "Mat,OutMat,Mat,Size,int,int,Scalar"
};

typedef enum fns {
    CVTCOLOR,
    CVTCOLOR2,
    BITWISE_NOT,
    ROTATE,
    LINE,
    NORMALIZE,
    CALCHIST,
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
    TRANSFORM,
    RESIZE,
    RESIZE2,
    RESIZE3,
    RESIZE4,
    RECTANGLE,
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
    WARPPERSPECTIVE4
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

Mat callOpencvMethod(int index, std::vector<ocvtypes>& args, Mat dMat) {

    switch (index) {
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
        case BITWISE_NOT: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            bitwise_not(p1, p2);
            return p2;
        }
        case ROTATE: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            rotate(p1, p2, p3);
            return p2;
        }
        case LINE: {
            auto p1 = args[0].m;
            auto p2 = args[1].pt;
            auto p3 = args[2].pt;
            auto p4 = args[3].sc;
            auto p5 = args[4].i;
            line(p1, p2, p3, p4, p5);
            return p1;
        }
        case NORMALIZE: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].d;
            auto p4 = args[3].d;
            auto p5 = args[4].i;
            normalize(p1, p2, p3, p4, p5);
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
            auto p5 = args[4].i;
            rectangle(p1, p2, p3, p4, p5);
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
        case ERODE5: {
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

    }
    return Mat();
}


