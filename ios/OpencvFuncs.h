//
//  ImgprocFuncs.h
//  RNOpencv3
//
//  Created by Adam G Freeman on 3/11/19.
//  Copyright © 2019 Facebook. All rights reserved.
//
#include <variant>

#ifndef OpencvFuncs_h
#define OpencvFuncs_h

extern std::vector<std::string> Functions;

extern std::vector<std::string> types;

typedef std::variant<int,double,float,const char*,Mat,Scalar,cv::Point,cv::Size> ocvtypes;

Mat callOpencvMethod(int index, std::vector<ocvtypes>& args, Mat dMat = Mat());

#endif /* OpencvFuncs_h */
