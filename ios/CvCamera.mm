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

bool mUseFaceDetection;

CascadeClassifier face_cascade;

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

        NSBundle *podBundle = [NSBundle bundleForClass:CvCamera.class];
        NSURL *bundleURL = [podBundle URLForResource:@"ocvdata" withExtension:@"bundle"];
        NSBundle *dBundle = [NSBundle bundleWithURL:bundleURL];
        NSString *faceCascadePath = [dBundle pathForResource:@"haarcascade_frontalface_alt" ofType:@"xml"];

        if (faceCascadePath) {
            if (!face_cascade.load( std::string([faceCascadePath UTF8String]))) {
                NSLog(@"Unable to load cascade classifier at: %@", faceCascadePath);
            }
            else {
                mUseFaceDetection = true;
            }
        }
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

-(void)rotateImage:(cv::Mat&)image deviceOrientation:(UIDeviceOrientation)deviceOrientation {
    
    switch (deviceOrientation) {
        case UIDeviceOrientationLandscapeLeft:
            rotate(image, image, ROTATE_90_COUNTERCLOCKWISE);
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            rotate(image, image, ROTATE_180);
            break;
        case UIDeviceOrientationLandscapeRight:
            rotate(image, image, ROTATE_90_CLOCKWISE);
            break;
        default:
            break;
    }
}

- (void)processImage:(cv::Mat&)image {

    // Do some OpenCV stuff with the image
    cv::Mat image_copy;
    cvtColor(image, image_copy, COLOR_BGR2RGBA);

    if (mUseFaceDetection) {
        std::vector<cv::Rect> faces;
        Mat gray;
        cvtColor(image, gray, COLOR_BGR2GRAY);
        equalizeHist(gray, gray);
        UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
        [self rotateImage:gray deviceOrientation:deviceOrientation];
        //face_cascade.detectMultiScale(gray, faces, 1.1, 2, 0 |CV_HAAR_SCALE_IMAGE, cv::Size(50, 50));
        
        face_cascade.detectMultiScale(gray, faces, 1.3, 5);
        
        NSString *payloadJSON = @"";
        if (faces.size() > 0) {
            payloadJSON = [payloadJSON stringByAppendingString:@"{\"faces\":["];
            for(size_t i = 0; i < faces.size(); i++) {
                float widthToUse = image.cols;
                float heightToUse = image.rows;
                
                float X0 = faces[i].tl().x;
                float Y0 = faces[i].tl().y;
                float X1 = faces[i].br().x;
                float Y1 = faces[i].br().y;
                
                float x = X0/widthToUse;
                float y = Y0/heightToUse;
                float w = (X1 - X0)/widthToUse;
                float h = (Y1 - Y0)/heightToUse;
                switch(deviceOrientation) {
                    case UIDeviceOrientationLandscapeLeft:
                        x = 1.0 - Y1/widthToUse;
                        y = X0/heightToUse;
                        w = (Y1 - Y0)/widthToUse;
                        h = (X1 - X0)/heightToUse;
                        break;
                    case UIDeviceOrientationPortraitUpsideDown:
                        x = 1.0 - X1/widthToUse;
                        y = 1.0 - Y1/heightToUse;
                        break;
                    case UIDeviceOrientationLandscapeRight:
                        x = Y0/widthToUse;
                        y = 1.0 - X1/heightToUse;
                        w = (Y1 - Y0)/widthToUse;
                        h = (X1 - X0)/heightToUse;
                        break;
                    default:
                    case UIDeviceOrientationPortrait:
                        break;
                }
                
                NSString *faceIdStr = [NSString stringWithFormat:@"faceId%d", (int)i];
                NSString *faceData = [NSString stringWithFormat:@"{\"x\":%f,\"y\":%f,\"width\":%f,\"height\":%f,\"faceId\":\"%@\"}",
                    x,y,w,h,faceIdStr];
                payloadJSON = [payloadJSON stringByAppendingString:faceData];
                if (i != (faces.size() - 1)) {
                    payloadJSON = [payloadJSON stringByAppendingString:@","];
                }
                //rectangle(image_copy, faces[i].tl(), faces[i].br(), Scalar( 255, 255, 0 ), 3);
            }
            payloadJSON = [payloadJSON stringByAppendingString:@"]}"];
        }
        self.onFacesDetected(@{@"payload":payloadJSON});
    }

    // invert image
    //bitwise_not(image_copy, image_copy);

    //Convert BGR to BGRA (three channel to four channel)
    //Mat bgr;
    //cvtColor(image_copy, bgr, COLOR_GRAY2BGR);

    //cvtColor(bgr, image, COLOR_BGR2BGRA);
    UIImage *videoImage = [FileUtils UIImageFromCVMat:image_copy];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self setImage:videoImage];
    });
}

@end
