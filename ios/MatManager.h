//
//  RNOpencv3Mat.h
//  RNOpencv3
//
//  Created by Adam G Freeman on 01/15/19.
//  Copyright © 2019 Adam G Freeman. All rights reserved.
//

#ifndef MatManager_h
#define MatManager_h

#import <AVFoundation/AVFoundation.h>

@interface MatWrapper : NSObject

@property (nonatomic, assign) cv::Mat myMat;

@end

@interface MatManager : NSObject

@property (nonatomic, strong) NSMutableArray *mats;

+ (id)sharedMgr;

@end

#endif
