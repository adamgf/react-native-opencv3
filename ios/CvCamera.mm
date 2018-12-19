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

- (void)processImage:(cv::Mat&)image {

    // Do some OpenCV stuff with the image

    cv::Mat image_copy;
    cvtColor(image, image_copy, COLOR_BGR2RGBA);

    if (mUseFaceDetection) {
        std::vector<cv::Rect> faces;
        Mat gray;
        cvtColor(image, gray, COLOR_BGR2GRAY);
        equalizeHist(gray, gray);
        //face_cascade.detectMultiScale(gray, faces, 1.1, 2, 0 |CV_HAAR_SCALE_IMAGE, cv::Size(50, 50));

        face_cascade.detectMultiScale(gray, faces, 1.3, 5);
        if (faces.size() > 0) {
            NSString *payloadJSON = @"{\"faces\":[";
            for(size_t i = 0; i < faces.size(); i++) {
                float x = (float)faces[i].tl().x/(float)gray.cols;
                float y = (float)faces[i].tl().y/(float)gray.rows;
                float w = (float)(faces[i].br().x - faces[i].tl().x)/(float)gray.cols;
                float h = (float)(faces[i].br().y - faces[i].tl().y)/(float)gray.rows;
                
                NSString *faceIdStr = [NSString stringWithFormat:@"faceId%d", (int)i];
                NSString *faceData = [NSString stringWithFormat:@"{\"x\":%f,\"y\":%f,\"width\":%f,\"height\":%f,\"faceId\":\"%@\"}",
                    x,y,w,h,faceIdStr];
                payloadJSON = [payloadJSON stringByAppendingString:faceData];
                if (i != (faces.size() - 1)) {
                    payloadJSON = [payloadJSON stringByAppendingString:@","];
                }
                rectangle(image_copy, faces[i].tl(), faces[i].br(), Scalar( 255, 255, 0 ), 3);
            }
            payloadJSON = [payloadJSON stringByAppendingString:@"]}"];
            self.onFacesDetected(@{@"payload":payloadJSON});
        }
    }

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
