//
//  ImgprocFuncs.m
//  RNOpencv3
//
//  Created by Adam G Freeman on 3/11/19.
//  Copyright © 2019 Adam G. Freeman. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CvFunctionWrapper.h"
#import "OpencvFuncs.h"

std::vector<std::string> Functions = {
    "cvtColor",
    "bitwise_not",
    "rotate",
    "line",
    "normalize",
    "calcHist"
};

std::vector<std::string> types = {
    "Mat,Mat,int",
    "Mat,Mat",
    "Mat,Mat,int",
    "Mat,Point,Point,Scalar,int",
    "Mat,Mat,double,double,int",
    "Mat,MatOfInt,Mat,Mat,MatOfInt,MatOfFloat"
};

typedef enum fns {
    CVTCOLOR,
    BITWISE_NOT,
    ROTATE,
    LINE,
    NORMALIZE,
    CALCHIST
} ipfns;

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

/**
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

Mat callOpencvMethod(int index, std::vector<ocvtypes>& args) {

    switch (index) {
        case CVTCOLOR: {
            auto p1 = castmat(&args[0]);
            auto p2 = castmat(&args[1]);
            auto p3 = castint(&args[2]);
            cvtColor(p1, p2, p3);
            return p2;
        }
        case BITWISE_NOT: {
            auto p1 = castmat(&args[0]);
            auto p2 = castmat(&args[1]);
            bitwise_not(p1, p2);
            return p2;
        }
        case ROTATE: {
            auto p1 = castmat(&args[0]);
            auto p2 = castmat(&args[1]);
            auto p3 = castint(&args[2]);
            rotate(p1, p2, p3);
            return p2;
        }
        case LINE: {
            auto p1 = castmat(&args[0]);
            auto p2 = castpoint(&args[1]);
            auto p3 = castpoint(&args[2]);
            auto p4 = castscalar(&args[3]);
            auto p5 = castint(&args[4]);
            line(p1, p2, p3, p4, p5);
            return p1;
        }
        case NORMALIZE: {
            auto p1 = castmat(&args[0]);
            auto p2 = castmat(&args[1]);
            auto p3 = castdub(&args[2]);
            auto p4 = castdub(&args[3]);
            auto p5 = castint(&args[4]);
            normalize(p1, p2, p3, p4, p5);
            return p2;
        }
        case CALCHIST: {
            Mat p1 = castmat(&args[0]);
            Mat p2 = castmat(&args[1]);
            Mat p3 = castmat(&args[2]);
            Mat p4 = castmat(&args[3]);
            Mat p5 = castmat(&args[4]);
            Mat p6 = castmat(&args[5]);
            
            int channel = p2.at<int>(0,0);
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
    }
    return Mat();
}


