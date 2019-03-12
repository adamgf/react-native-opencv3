//
//  CvFunctionWrapper.m
//  RNOpencv3
//
//  Created by Adam G Freeman on 2/20/19.
//  Copyright © 2019 Facebook. All rights reserved.
//
#import "CvFunctionWrapper.h"
#import "ImgprocFuncs.h"

Mat callMethod(std::string searchClass, std::string functionName, std::vector<ocvtypes>& args) {
    
    std::vector<std::string> lookup;
    if (searchClass.compare("Imgproc") == 0) {
        lookup = Imgproc;
    
        auto it = std::find(lookup.begin(), lookup.end(), functionName);
        if (it != lookup.end()) {
            auto index = std::distance(lookup.begin(), it);
        
            switch(index) {
                case CVTCOLOR: {
                    return cvtColorW(args);
                }
                default:
                    break;
            }
        }
    }
    return Mat();
}

