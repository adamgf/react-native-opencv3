//
//  CvFunctionWrapper.m
//  RNOpencv3
//
//  Created by Adam G Freeman on 2/20/19.
//  Copyright © 2019 Facebook. All rights reserved.
//
#import "CvFunctionWrapper.h"
#import "OpencvFuncs.h"

int getMethodIndex(std::string functionName) {
    auto it = std::find(Functions.begin(), Functions.end(), functionName);
    if (it != Functions.end()) {
        int index = (int)std::distance(Functions.begin(), it);
        return index;
    }
    return -1;
}

Mat callMethod(std::string functionName, std::vector<ocvtypes>& args) {
    int index = getMethodIndex(functionName);
    if (index >= 0) {
        return callOpencvMethod(index, args);
    }
    return Mat();
}

