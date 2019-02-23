//
//  CvFunctionWrapper.h
//  RNOpencv3
//
//  Created by Adam G Freeman on 2/20/19.
//  Copyright © 2019 Adam G. Freeman. All rights reserved.
//
#include <iostream>
#include <tuple>
#include <utility>
#include <initializer_list>
#include <vector>

#import <objc/runtime.h>

#ifndef CvFunctionWrapper_h
#define CvFunctionWrapper_h

template<class... ArgTypes>
void callOpenCvMethod2(ArgTypes... p);

#endif /* CvFunctionWrapper_h */
