//
//  CvFunctionWrapper.h
//  RNOpencv3
//
//  Created by Adam G Freeman on 2/20/19.
//  Copyright © 2019 Adam G. Freeman. All rights reserved.
//
#include <variant>

#ifndef CvFunctionWrapper_h
#define CvFunctionWrapper_h

typedef std::variant<int,double,float,const char*,Mat,Scalar,cv::Point,cv::Size> ocvtypes;

Mat callMethod(std::string functionName, std::vector<ocvtypes>& args);

#endif /* CvFunctionWrapper_h */
