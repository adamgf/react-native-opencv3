//
//  CvCamera.h
//  RNOpencv3
//
//  Created by Adam G Freeman on 11/11/18.
//  Copyright © 2018 Adam G Freeman. All rights reserved.
//

#ifndef CvCamera_h
#define CvCamera_h

#import "External.h"
#import <AVFoundation/AVFoundation.h>
#import <React/RCTBridge.h>
#import <React/RCTBridgeModule.h>
#import <UIKit/UIKit.h>
#import <React/UIView+React.h>

enum {
    ClassifierFace,
    ClassifierEyes,
    ClassifierNose,
    ClassifierMouth
};

typedef NSInteger Classifier;

@class CvVideoCamera;

@protocol CvVideoCameraDelegate;

@class MatWrapper;

typedef void (^TakePicBlock)(MatWrapper*);

typedef void (^RecordVidBlock)(NSNumber*,NSNumber*,NSString*);

@interface CvCamera : UIImageView <CvVideoCameraDelegate>

@property (nonatomic, weak) RCTBridge *bridge;

@property (nonatomic, copy) TakePicBlock takePicBlock;

@property (nonatomic, copy) RecordVidBlock recordVidBlock;

//@property (nonatomic, retain) CvVideoCamera* videoCamera;

@property (nonatomic, copy) RCTBubblingEventBlock onFacesDetectedCv;

@property (nonatomic, copy) RCTBubblingEventBlock onFrameSize;

@property (nonatomic, copy) RCTBubblingEventBlock onPayload;

@property (nonatomic, copy) NSDictionary *mCvInvokeGroup;

@property (nonatomic, copy) NSDictionary *mOverlay;

@property (nonatomic, copy) NSNumber *mOverlayInterval;

@property (nonatomic, copy) NSString *mFilename;

@property (nonatomic, copy) NSString *mFacing;

@property (nonatomic, strong) NSDate *startDate;

- (id)initWithBridge:(RCTBridge*)bridge;

- (void)changeFacing:(NSString*)facing;

- (void)setCascadeClassifier:(NSString*)cascadeClassifier whichOne:(Classifier)whichOne;

- (void)setLandmarksModel:(NSString*)landmarksModel;

- (void)takePicture:(TakePicBlock)takePicBlock;

- (void)startRecording:(NSString*)filename;

- (void)stopRecording:(RecordVidBlock)recordVidBlock;

@end

#endif
