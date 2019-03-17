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

std::vector<std::string> Functions = {
    "cvtColor","bitwise_not","rotate"
};

std::vector<std::string> types = {
    "Mat,Mat,int","Mat,Mat","Mat,Mat,int"
};

typedef enum fns {
    CVTCOLOR,BITWISE_NOT,ROTATE
} ipfns;

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
            auto p1 = castmat(&args[0]);auto p2 = castmat(&args[1]);auto p3 = castint(&args[2]);
            cvtColor(p1, p2, p3);
            return p2;
        }
        case BITWISE_NOT: {
            auto p1 = castmat(&args[0]);auto p2 = castmat(&args[1]);
            //cvtColor(p1, p2, COLOR_BGR2GRAY);
            bitwise_not(p1, p2);
            return p2;
        }
        case ROTATE: {
            auto p1 = castmat(&args[0]);auto p2 = castmat(&args[1]);auto p3 = castint(&args[2]);
            rotate(p1, p2, p3);
            return p2;
        }
    }
    return Mat();
}


