//
//  CvFunctionWrapper.m
//  RNOpencv3
//
//  Created by Adam G Freeman on 2/20/19.
//  Copyright © 2019 Facebook. All rights reserved.
//
#import "CvFunctionWrapper.h"
#import "ImgprocFuncs.h"

int getMethodIndex(std::vector<std::string>& lookup, std::string functionName) {
    auto it = std::find(lookup.begin(), lookup.end(), functionName);
    if (it != lookup.end()) {
        int index = (int)std::distance(lookup.begin(), it);
        return index;
    }
    return -1;
}

Mat callMethod(std::string searchClass, std::string functionName, std::vector<ocvtypes>& args) {
    
    std::vector<std::string> lookup;
    if (searchClass.compare("Imgproc") == 0) {
        lookup = Imgproc;
        int index = getMethodIndex(lookup, functionName);
        return callImgprocMethod(index, args);
    }
    
    return Mat();
}

