//
//  CvFunctionWrapper.m
//  RNOpencv3
//
//  Created by Adam G Freeman on 2/20/19.
//  Copyright © 2019 Facebook. All rights reserved.
//
#import "CvFunctionWrapper.h"

Mat cvtColorW(std::vector<ocvtypes>& ps) {
    Mat m2 = castmat(&ps[1]);
    cvtColor(castmat(&ps[0]), m2, castint(&ps[2]), castint(&ps[3]));
    return m2;
}

