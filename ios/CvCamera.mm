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

// private properties
bool mUseFaceDetection;
bool mUseEyesDetection;
bool mUseNoseDetection;
bool mUseMouthDetection;
NSString *mFacing;

CascadeClassifier face_cascade;
CascadeClassifier eyes_cascade;
CascadeClassifier mouth_cascade;
CascadeClassifier nose_cascade;

- (id)initWithBridge:(RCTBridge *)bridge
{
    if ((self = [super init])) {
        self.backgroundColor = [UIColor blackColor];
        self.bridge = bridge;
        CvVideoCamera *videoCamera = [[CvVideoCamera alloc] initWithParentView:self];
        videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
        videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPresetMedium;
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

-(NSString*) getPartJSON:(cv::Mat&)dFace partKey:(NSString*)partKey part:(cv::Rect)part widthToUse:(double)widthToUse heightToUse:(double)heightToUse {
    
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    NSString* sb = @"";
    
    if (partKey && ![partKey isEqualToString:@""]) {
        NSString *partKeyStr = [NSString stringWithFormat:@",\"%@\":", partKey];
        sb = [sb stringByAppendingString:partKeyStr];
    }
    
    double X0 = part.tl().x;
    double Y0 = part.tl().y;
    double X1 = part.br().x;
    double Y1 = part.br().y;
    
    double x = X0/widthToUse;
    double y = Y0/heightToUse;
    double w = (X1 - X0)/widthToUse;
    double h = (Y1 - Y0)/heightToUse;
    
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
    
    NSString *partStr = [NSString stringWithFormat:@"{\"x\":%f,\"y\":%f,\"width\":%f,\"height\":%f", x, y, w, h];
    sb = [sb stringByAppendingString:partStr];
    
    if (partKey && ![partKey isEqualToString:@""]) {
        sb = [sb stringByAppendingString:@"}"];
    }
    return sb;
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
                
                NSString *faceJSON = [self getPartJSON:gray partKey:@"" part:faces[i] widthToUse:image.cols heightToUse:image.rows];
                payloadJSON = [payloadJSON stringByAppendingString:faceJSON];
                
                NSString *faceIdStr = [NSString stringWithFormat:@",\"faceId\":\"%d\"", (int)i];
                payloadJSON = [payloadJSON stringByAppendingString:faceIdStr];
                
                if (mUseEyesDetection || mUseNoseDetection || mUseMouthDetection) {
                    
                    //Mat dFace = gray.adjustROI();
                    cv::Mat dFace = cv::Mat(gray, faces[i]).clone();
                    
                    if (mUseEyesDetection) {
                        std::vector<cv::Rect> eyes;
                        eyes_cascade.detectMultiScale(dFace, eyes, 1.3, 5);
                        //mEyesClassifier.detectMultiScale(dFace, eyes, 1.1, 2, 0|Objdetect.CASCADE_SCALE_IMAGE, new Size((double)dFaceW, (double)dFaceH), new Size());
                        if (eyes.size() > 0) {
                            NSString *firstEyeJSON = [self getPartJSON:dFace partKey:@"firstEye" part:eyes[0] widthToUse:dFace.cols heightToUse:dFace.rows];
                            payloadJSON = [payloadJSON stringByAppendingString:firstEyeJSON];
                        }
                        if (eyes.size() > 1) {
                            NSString *secondEyeJSON = [self getPartJSON:dFace partKey:@"secondEye" part:eyes[1] widthToUse:dFace.cols heightToUse:dFace.rows];
                            payloadJSON = [payloadJSON stringByAppendingString:secondEyeJSON];
                        }
                    }
                    
                    if (mUseNoseDetection) {
                        std::vector<cv::Rect> noses;
                        nose_cascade.detectMultiScale(dFace, noses, 1.3, 5);
                        
                        if (noses.size() > 0) {
                            NSString *noseJSON = [self getPartJSON:dFace partKey:@"nose" part:noses[0] widthToUse:dFace.cols heightToUse:dFace.rows];
                            payloadJSON = [payloadJSON stringByAppendingString:noseJSON];
                        }
                    }
                    
                    if (mUseMouthDetection) {

                        cv::Rect dRectMouthROI;
                        dRectMouthROI.x = 0;
                        dRectMouthROI.y = (int)((double)dFace.rows * 0.6f);
                        dRectMouthROI.width = dFace.cols;
                        dRectMouthROI.height = (int)((double)dFace.rows * 0.4f);
                        
                        Mat dFaceForMouthDetecting = cv::Mat(dFace, dRectMouthROI).clone();
                        
                        std::vector<cv::Rect> mouths;
                        nose_cascade.detectMultiScale(dFaceForMouthDetecting, mouths, 1.3, 5);
                        if (mouths.size() > 0) {
                            cv::Rect dRect;
                            dRect.x = mouths[0].x;
                            dRect.y = mouths[0].y + (int)((double)dFace.rows * 0.6f);
                            dRect.width = mouths[0].width;
                            dRect.height = mouths[0].height;
                            
                            NSString *mouthJSON = [self getPartJSON:dFace partKey:@"mouth" part:dRect widthToUse:dFace.cols heightToUse:dFace.rows];
                            payloadJSON = [payloadJSON stringByAppendingString:mouthJSON];
                        }
                    }
                }
                
                if (i != (faces.size() - 1)) {
                    payloadJSON = [payloadJSON stringByAppendingString:@"},"];
                }
                else {
                    payloadJSON = [payloadJSON stringByAppendingString:@"}"];
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

#pragma Properties

- (void)changeFacing:(NSString*)facing {
    if (![facing isEqualToString:mFacing]) {
        mFacing = facing;
        [self.videoCamera stop];
        if ([mFacing isEqualToString:@"back"]) {
            [self.videoCamera setDefaultAVCaptureDevicePosition:AVCaptureDevicePositionBack];
        }
        else {
            [self.videoCamera setDefaultAVCaptureDevicePosition:AVCaptureDevicePositionFront];
        }
        [self.videoCamera start];
    }
}

- (void)setCascadeClassifier:(NSString*)cascadeClassifier whichOne:(Classifier)whichOne {
    NSBundle *podBundle = [NSBundle bundleForClass:CvCamera.class];
    NSURL *bundleURL = [podBundle URLForResource:@"ocvdata" withExtension:@"bundle"];
    NSBundle *dBundle = [NSBundle bundleWithURL:bundleURL];
    NSString *cascadePath = [dBundle pathForResource:cascadeClassifier ofType:@"xml"];
    
    CascadeClassifier cascade;
    if (cascadePath) {
        if (!cascade.load( std::string([cascadePath UTF8String]))) {
            NSLog(@"Unable to load cascade classifier at: %@", cascadePath);
        }
        else {
            switch (whichOne) {
                case ClassifierFace:
                    face_cascade = cascade;
                    mUseFaceDetection = true;
                    break;
                case ClassifierEyes:
                    eyes_cascade = cascade;
                    mUseEyesDetection = true;
                    break;
                case ClassifierNose:
                    nose_cascade = cascade;
                    mUseNoseDetection = true;
                    break;
                case ClassifierMouth:
                    mouth_cascade = cascade;
                    mUseMouthDetection = true;
                    break;
            }
        }
    }
}

@end
