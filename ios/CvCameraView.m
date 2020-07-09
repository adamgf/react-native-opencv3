//
//  CvCameraManager.m
//  RNOpencv3
//
//  Created by Adam G Freeman on 11/11/18.
//  Copyright © 2018 Adam G Freeman. All rights reserved.
//

#import "CvCamera.h"
#import "CvCameraView.h"
#import "FileUtils.h"
#import <React/RCTBridge.h>
#import <React/RCTUIManager.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTLog.h>
#import <React/RCTUtils.h>
#import <React/UIView+React.h>

@implementation CvCameraView

RCT_EXPORT_MODULE(CvCameraView)

RCT_EXPORT_VIEW_PROPERTY(onFacesDetectedCv, RCTBubblingEventBlock)
	
RCT_EXPORT_VIEW_PROPERTY(onFrameSize, RCTBubblingEventBlock)

RCT_EXPORT_VIEW_PROPERTY(onPayload, RCTBubblingEventBlock)

// And you sent event you want from objectC to react-native
- (UIView *)view {
    return [[CvCamera alloc] initWithBridge:self.bridge];
}

RCT_CUSTOM_VIEW_PROPERTY(cvinvoke, NSDictionary*, CvCamera) {
    view.mCvInvokeGroup = json;
}

RCT_CUSTOM_VIEW_PROPERTY(facing, NSString*, CvCamera) {
    [view changeFacing:json];
}

RCT_CUSTOM_VIEW_PROPERTY(faceClassifier, NSString*, CvCamera) {
    [view setCascadeClassifier:json whichOne:ClassifierFace];
}

RCT_CUSTOM_VIEW_PROPERTY(eyesClassifier, NSString*, CvCamera) {
    [view setCascadeClassifier:json whichOne:ClassifierEyes];
}

RCT_CUSTOM_VIEW_PROPERTY(noseClassifier, NSString*, CvCamera) {
    [view setCascadeClassifier:json whichOne:ClassifierNose];
}

RCT_CUSTOM_VIEW_PROPERTY(mouthClassifier, NSString*, CvCamera) {
    [view setCascadeClassifier:json whichOne:ClassifierMouth];
}

RCT_CUSTOM_VIEW_PROPERTY(landmarksModel, NSString*, CvCamera) {
    [view setLandmarksModel:json];
}

RCT_CUSTOM_VIEW_PROPERTY(overlay, NSDictionary*, CvCamera) {
    view.mOverlay = json;
}

RCT_CUSTOM_VIEW_PROPERTY(overlayInterval, NSNumber*, CvCamera) {
    view.mOverlayInterval = json;
}

RCT_REMAP_METHOD(setOverlay,
                 options:(NSDictionary *)options
                 reactTag:(nonnull NSNumber *)reactTag)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, CvCamera *> *viewRegistry) {
        CvCamera *view = viewRegistry[reactTag];
        if (![view isKindOfClass:[CvCamera class]]) {
            RCTLogError(@"Invalid view returned from registry, expecting CvCamera, got: %@", view);
        }
        else {
            NSDictionary *overlayMat = [options valueForKey:@"overlayMat"];
            view.mOverlay = overlayMat;
        }
    }];
}

RCT_REMAP_METHOD(takePicture,
                 options:(NSDictionary *)options
                 reactTag:(nonnull NSNumber *)reactTag
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, CvCamera *> *viewRegistry) {
        CvCamera *view = viewRegistry[reactTag];
        if (![view isKindOfClass:[CvCamera class]]) {
            RCTLogError(@"Invalid view returned from registry, expecting CvCamera, got: %@", view);
        }
        else {
            TakePicBlock takePicBlock = ^(MatWrapper* MW) {
                [FileUtils matToImage:MW outPath:[options valueForKey:@"filename"] resolver:resolve rejecter:reject];
            };
            
            [view takePicture:takePicBlock];
        }
    }];
}

RCT_REMAP_METHOD(startRecording,
                 withOptions:(NSDictionary *)options
                 reactTag:(nonnull NSNumber *)reactTag)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, CvCamera *> *viewRegistry) {
        CvCamera *view = viewRegistry[reactTag];
        if (![view isKindOfClass:[CvCamera class]]) {
            RCTLogError(@"Invalid view returned from registry, expecting CvCamera, got: %@", view);
        }
        else {
            [view startRecording:[options valueForKey:@"filename"]];
        }
    }];
}

RCT_REMAP_METHOD(stopRecording,
                 reactTag:(nonnull NSNumber *)reactTag
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
    [self.bridge.uiManager addUIBlock:^(__unused RCTUIManager *uiManager, NSDictionary<NSNumber *, CvCamera *> *viewRegistry) {
        CvCamera *view = viewRegistry[reactTag];
        if (![view isKindOfClass:[CvCamera class]]) {
            RCTLogError(@"Invalid view returned from registry, expecting CvCamera, got: %@", view);
        }
        else {
            RecordVidBlock recordVidBlock = ^(NSNumber *wid, NSNumber *hei, NSString *outPath) {
                NSDictionary *returnDict = @{ @"width" : wid, @"height" : hei,
                                              @"uri" : outPath };
                
                resolve(returnDict);
            };
            [view stopRecording:recordVidBlock];
        }
    }];
}
@end
