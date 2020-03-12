//
//  External.h
//  OpenCVSampleApp
//
//  Created by Adam G Freeman on 10/25/18.
//  Copyright © 2018 Adam Freeman. All rights reserved.
//

#ifndef External_h
#define External_h

#ifdef __cplusplus
#undef YES
#undef NO
#include <opencv2/opencv.hpp>
#include <opencv2/videoio/cap_ios.h>
#include <opencv2/face.hpp>
#include <opencv2/imgcodecs/ios.h>
using namespace cv;
#if __has_feature(objc_bool)
#define YES __objc_yes
#define NO  __objc_no
#else
#define YES ((BOOL)1)
#define NO  ((BOOL)0)
#endif
#endif

#endif /* External_h */

