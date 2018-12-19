//
//  CvCameraManager.m
//  RNOpencv3
//
//  Created by Adam G Freeman on 11/11/18.
//  Copyright © 2018 Adam G Freeman. All rights reserved.
//

#import "CvCamera.h"
#import "CvCameraView.h"
#import <React/RCTBridge.h>
#import <React/RCTUIManager.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTLog.h>
#import <React/RCTUtils.h>
#import <React/UIView+React.h>

@implementation CvCameraView

RCT_EXPORT_MODULE(CvCameraView);

RCT_EXPORT_VIEW_PROPERTY(onFacesDetected, RCTBubblingEventBlock)

RCT_CUSTOM_VIEW_PROPERTY(facing, NSString *, CvCamera) {

}

// And you sent event you want from objectC to react-native
- (UIView *)view {
    return [[CvCamera alloc] initWithBridge:self.bridge];
}

@end
