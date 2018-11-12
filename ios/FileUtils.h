//
//  FileUtils.h
//  RNOpencv3
//
//  Created by Adam G Freeman on 11/12/18.
//  Copyright © 2018 Adam G Freeman. All rights reserved.
//

#ifndef FileUtils_h
#define FileUtils_h

#import <UIKit/UIKit.h>

@interface FileUtils : NSObject

+ (cv::Mat)cvMatFromUIImage:(UIImage *)image;

+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;

@end
#endif /* FileUtils_h */
