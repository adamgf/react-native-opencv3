//
//  ImgprocFuncs.h
//  RNOpencv3
//
//  Created by Adam G Freeman on 3/11/19.
//  Copyright © 2019 Facebook. All rights reserved.
//
#include <variant>
#include <iostream>
#import "External.h"

#ifndef OpencvFuncs_h
#define OpencvFuncs_h

extern std::vector<std::string> Functions;

extern std::vector<std::string> types;

// for some reason std::variant is being reported as 'No template named 'variant' in namespace 'std''
//typedef std::variant<int,double,float,const char*,Mat,Scalar,cv::Point,cv::Size> ocvtypes;
class ocvtypes
{
public:
    enum {MAT, DOUBLE, FLOAT, INT, BOOLEAN, STR, SCALAR, POINT, SIZE} tag;

    ocvtypes(const Mat& val) {
        this->tag = MAT;
        this->m = val;
    }
    ocvtypes(double val) {
        this->tag = DOUBLE;
        this->d = val;
    }
    ocvtypes(float val) {
        this->tag = FLOAT;
        this->f = val;
    }
    ocvtypes(int val) {
        this->tag = INT;
        this->i = val;
    }
    ocvtypes(bool val) {
        this->tag = BOOLEAN;
        this->b = val;
    }
    ocvtypes(const char* val) {
        this->tag = STR;
        this->str = val;
    }
    ocvtypes(const Scalar& val) {
        this->tag = SCALAR;
        this->sc = val;
    }
    ocvtypes(const cv::Point& val) {
        this->tag = POINT;
        this->pt = val;
    }
    ocvtypes(const cv::Size& val) {
        this->tag = SIZE;
        this->sz = val;
    }
    ~ocvtypes() {
        if (this->tag == MAT) {
            (this->m).release();
            (this->m).~Mat();
        }
    }

    // TODO: put these in a union?
    Mat m;
    double d;
    float f;
    int i;
    bool b;
    const char *str;
    Scalar sc;
    cv::Point pt;
    cv::Size sz;
};

Mat callOpencvMethod(int index, std::vector<ocvtypes>& args, Mat dMat = Mat());

#endif /* OpencvFuncs_h */
