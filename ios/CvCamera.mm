//
//  CvCameraViewManager.m
//  RNOpencv3
//
//  Created by Adam G Freeman on 11/11/18.
//  Copyright © 2018 Adam G Freeman. All rights reserved.
//

#import "CvCamera.h"
#import "FileUtils.h"

@implementation CvCamera

- (id)initWithBridge:(RCTBridge *)bridge
{
    if ((self = [super init])) {
        self.backgroundColor = [UIColor blackColor];
        self.bridge = bridge;
        CvVideoCamera *videoCamera = [[CvVideoCamera alloc] initWithParentView:self];
        videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
        videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset1280x720;
        videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
        videoCamera.defaultFPS = 30;
        videoCamera.grayscaleMode = false;
        videoCamera.delegate = self;
        self.videoCamera = videoCamera;
        
        [self.videoCamera start];
    }
    return self;
}

/** TODO: implement notifcations so these methods get called */
- (void)bridgeDidForeground:(NSNotification *)notification {
    [self.videoCamera start];
}

- (void)bridgeDidBackground:(NSNotification *)notification {
    [self.videoCamera stop];
}

- (void)processImage:(cv::Mat&)image {
    
    // Do some OpenCV stuff with the image
    
    cv::Mat image_copy;
    cvtColor(image, image_copy, COLOR_BGR2RGBA);
    
    // invert image
    //bitwise_not(image_copy, image_copy);
    
    //Convert BGR to BGRA (three channel to four channel)
    //Mat bgr;
    //cvtColor(image_copy, bgr, COLOR_GRAY2BGR);
    
    //cvtColor(bgr, image, COLOR_BGR2BGRA);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *videoImage = [FileUtils UIImageFromCVMat:image_copy];
        
        [self setImage:videoImage];
    });
}

@end
