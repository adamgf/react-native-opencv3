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
    "release",
    "Sobel",
    "convertScaleAbs",
    "transform",
    "resize",
    "rectangle",
    "setTo"
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
    "",
    "Mat,OutMat,int,double,double",
    "Mat,OutMat,double,double",
    "Mat,OutMat,Mat",
    "Mat,OutMat,Size,double,double,int",
    "OutMat,Point,Point,Scalar,int",
    "OutMat,Scalar"
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
    RELEASE,
    SOBEL,
    CONVERTSCALEABS,
    TRANSFORM,
    RESIZE,
    RECTANGLE,
    SETTO
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
        case SOBEL: {
            auto p1 = args[0].m;
            auto p2 = args[1].m;
            auto p3 = args[2].i;
            auto p4 = args[3].d;
            auto p5 = args[4].d;
            Sobel(p1, p2, p3, p4, p5);
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
    }
    return Mat();
}


