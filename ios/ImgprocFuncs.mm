//
//  ImgprocFuncs.m
//  RNOpencv3
//
//  Created by Adam G Freeman on 3/11/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CvFunctionWrapper.h"
#import "ImgprocFuncs.h"

std::vector<std::string> Imgproc = {
    "cvtColor"
};

std::vector<std::string> iptypes = {
    "Mat,Mat,int,int"
};

Mat cvtColorW(std::vector<ocvtypes>& ps) {
    Mat m2 = castmat(&ps[1]);
    cvtColor(castmat(&ps[0]), m2, castint(&ps[2]), castint(&ps[3]));
    return m2;
}

