//
//  CvCamera.h
//  RNOpencv3
//
//  Created by Adam G Freeman on 11/11/18.
//  Copyright © 2018 Adam G Freeman. All rights reserved.
//

#ifndef CvCamera_h
#define CvCamera_h

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

@interface CvCamera : UIImageView <CvVideoCameraDelegate>

@property (nonatomic, weak) RCTBridge *bridge;

@property (nonatomic, strong) CvVideoCamera* videoCamera;

@property (nonatomic, copy) RCTBubblingEventBlock onFacesDetected;

@property (nonatomic, copy) RCTBubblingEventBlock onFrameSize;

@property (nonatomic, copy) RCTBubblingEventBlock onPayload;

- (id)initWithBridge:(RCTBridge *)bridge;

- (void)setOverlay:(NSDictionary*)overlay;

- (void)setOverlayInterval:(NSNumber*)overlayInterval;

- (void)setCvInvokeGroup:(NSDictionary*)cvinvoke;

- (void)changeFacing:(NSString*)facing;

- (void)setCascadeClassifier:(NSString*)cascadeClassifier whichOne:(Classifier)whichOne;

- (void)setLandmarksModel:(NSString*)landmarksModel;

@end

#endif
