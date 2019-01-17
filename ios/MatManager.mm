//
//  FileUtils.m
//  RNOpencv3
//
//  Created by Adam G Freeman on 01/15/19.
//  Copyright © 2019 Adam G Freeman. All rights reserved.
//

#import "MatManager.h"
#import <Foundation/Foundation.h>

// simple opaque object that wraps a cv::Mat
@implementation MatWrapper

-(id)init {
    if (self = [super init]) {
        
    }
    return self;
}
@end

// For react-native purposes cv::Mat is an opaque type that is contained in an NSMutableArray and
// accessed by indexing into the array.  Eventually it has to be converted into an image to be useable
// singleton class for retaining the mats for image processing operations
@implementation MatManager

+ (id)sharedMgr {
    static MatManager *sharedMatManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMatManager = [[self alloc] init];
    });
    return sharedMatManager;
}

- (id)init {
    if (self = [super init]) {
        self.mats = [[NSMutableArray alloc] init];
    }
    return self;
}

-(int)createEmptyMat {
    int matIndex = (int)self.mats.count;
    MatWrapper *MW = [[MatWrapper alloc] init];
    cv::Mat emptyMat;
    MW.myMat = emptyMat;
    [self.mats addObject:MW];
    return matIndex;
}

-(int)addMat:(cv::Mat&)matToAdd {
    int matIndex = (int)self.mats.count;
    MatWrapper *MW = [[MatWrapper alloc] init];
    MW.myMat = matToAdd;
    [self.mats addObject:MW];
    return matIndex;
}

-(cv::Mat)matAtIndex:(int)matIndex {
    MatWrapper *MW = (MatWrapper*)self.mats[matIndex];
    return MW.myMat;
}

-(void)dealloc {
    [self.mats removeAllObjects];
    self.mats = nil;
}

@end
