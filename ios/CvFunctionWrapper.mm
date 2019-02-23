//
//  CvFunctionWrapper.m
//  RNOpencv3
//
//  Created by Adam G Freeman on 2/20/19.
//  Copyright © 2019 Facebook. All rights reserved.
//
#import "CvFunctionWrapper.h"

std::vector<std::string> lookup = {
"cvtColor"
};

typedef enum fns {
    CVTCOLOR
} fns;

// I tried writing code to invoke opencv2.framework at run-time and it turned out to
// be not something that is easily achievable but I gave that up once I considered that
// Apple will probably reject any app that invokes run-time code anyways unfortunately
// you just have to wrap the Opencv functions ...
template<class... ArgTypes>
void callOpenCvMethod2(ArgTypes... p) {

    std::string functionName("cvtColor");
    auto it = std::find(lookup.begin(), lookup.end(), functionName);
    if (it != lookup.end()) {
        auto index = std::distance(lookup.begin(), it);
    
        switch(index) {
            case CVTCOLOR: {
                //cvtColor(p...);
                break;
            }
            default:
                break;
        }
    }
}

void justdoitplease() {
    callOpenCvMethod(1, ':', " Hello", ',', " ", "World!" );
}
