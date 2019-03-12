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

typedef std::variant<int,double,float,const char*,Mat,Scalar,cv::Point> ocvtypes;

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

Mat cvtColorW(std::vector<ocvtypes>& ps);

#endif /* CvFunctionWrapper_h */
