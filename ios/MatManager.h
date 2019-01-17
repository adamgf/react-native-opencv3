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

@interface MatManager : NSObject

@property (nonatomic, strong) NSMutableArray *mats;

+ (id)sharedMgr;

-(int)createEmptyMat;

-(int)addMat:(cv::Mat&)matToAdd;

-(cv::Mat)matAtIndex:(int)matIndex;

-(void)setMat:(cv::Mat&)matToSet atIndex:(int)matIndex;

@end

#endif
