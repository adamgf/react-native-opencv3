//
//  CvCameraViewManager.m
//  RNOpencv3
//
//  Created by Adam G Freeman on 11/11/18.
//  Copyright © 2018 Adam G Freeman. All rights reserved.
//

#import "CvCamera.h"
#import "FileUtils.h"

@implementation CvCamera {
    // private properties
    NSDictionary           *mOverlay;
    Mat                    *mOverlayMat;
    int                    mOverlayInterval;
    NSDictionary           *mCvInvokeGroup;

    bool mUseFaceDetection;
    bool mUseEyesDetection;
    bool mUseNoseDetection;
    bool mUseMouthDetection;
    bool mUseLandmarks;
    NSString *mFacing;
    CGFloat mRelativeFaceSize;
    int mAbsoluteFaceSize;
    
    CascadeClassifier face_cascade;
    CascadeClassifier eyes_cascade;
    CascadeClassifier mouth_cascade;
    CascadeClassifier nose_cascade;
    Ptr<face::Facemark> landmarks;
}

- (id)initWithBridge:(RCTBridge *)bridge
{
    if ((self = [super init])) {
        mOverlayInterval = 0;
        mRelativeFaceSize = 0.2f;
        mAbsoluteFaceSize = 0;
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

// What is the point?
- (void)rotatePoint:(Mat)dFace thePoint:(cv::Point&)thePoint {
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];

    double widthToUse = dFace.cols;
    double heightToUse = dFace.rows;
    double tempX;

    switch(deviceOrientation) {
        case UIDeviceOrientationLandscapeLeft:
            tempX = thePoint.x;
            thePoint.x = heightToUse - thePoint.y;
            thePoint.y = tempX;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            thePoint.x = widthToUse - thePoint.x;
            thePoint.y = heightToUse - thePoint.y;
            break;
        case UIDeviceOrientationLandscapeRight:
            tempX = thePoint.x;
            thePoint.x = thePoint.y;
            thePoint.y = widthToUse - tempX;
            break;
        default:
        case UIDeviceOrientationPortrait:
            // don't do nuthin'
            break;
    }
}

- (CGFloat)calcDistance:(CGFloat)centerX centerY:(CGFloat)centerY pointX:(CGFloat)pointX pointY:(CGFloat)pointY {
    CGFloat distX = pointX - centerX;
    CGFloat distY = pointY - centerY;

    distX = (distX < 0.0) ? -distX : distX;
    distY = (distY < 0.0) ? -distY : distY;
    return (distX + distY);
}

- (void)processImage:(cv::Mat&)image {

    // Do some OpenCV stuff with the image
    Mat gray;
    cv::Mat image_copy; // image in corrected colorspace ...
    cvtColor(image, image_copy, COLOR_BGR2RGBA);
    cvtColor(image, gray, COLOR_BGR2GRAY);
    
    //Log.d(TAG, "payload is: " + faceInfo);
    if (self && self.onFrameSize) {
        NSString *frameSizeStr = [NSString stringWithFormat:@"{\"frameSize\":{\"frameWidth\":%d,\"frameHeight\":%d}}",image.cols,image.rows];
        self.onFrameSize(@{@"payload":frameSizeStr});
    }
    
    if (mUseFaceDetection) {
        std::vector<cv::Rect> faces;

        equalizeHist(gray, gray);

        UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
        [self rotateImage:gray deviceOrientation:deviceOrientation];

        CGFloat height = gray.rows;
        if (height * mRelativeFaceSize > 0.0f) {
            CGFloat absoluteFaceSizeF = height * mRelativeFaceSize;
            mAbsoluteFaceSize = (int)absoluteFaceSizeF;
            CGFloat remainder = absoluteFaceSizeF - (CGFloat)mAbsoluteFaceSize;
            if (remainder >= 0.5f) {
                mAbsoluteFaceSize++;
            }
        }

        std::vector<std::vector<Point2f>> fits;
        bool landmarksFound = false;
        if (mUseLandmarks) {
            // less sensitive if determining landmarks
            face_cascade.detectMultiScale(gray, faces, 1.3, 5, 0 |CV_HAAR_SCALE_IMAGE, cv::Size(mAbsoluteFaceSize, mAbsoluteFaceSize), cv::Size());
            landmarksFound = landmarks->fit(gray, faces, fits);
        }
        else {
            face_cascade.detectMultiScale(gray, faces, 1.1, 2, 0 |CV_HAAR_SCALE_IMAGE, cv::Size(mAbsoluteFaceSize, mAbsoluteFaceSize), cv::Size());
        }

        NSString *payloadJSON = @"";
        if (faces.size() > 0) {
            payloadJSON = [payloadJSON stringByAppendingString:@"{\"faces\":["];
            for(size_t i = 0; i < faces.size(); i++) {

                NSString *faceJSON = [self getPartJSON:gray partKey:@"" part:faces[i] widthToUse:image.cols heightToUse:image.rows];
                payloadJSON = [payloadJSON stringByAppendingString:faceJSON];

                NSString *faceIdStr = [NSString stringWithFormat:@",\"faceId\":\"%d\"", (int)i];
                payloadJSON = [payloadJSON stringByAppendingString:faceIdStr];

                if (mUseEyesDetection || mUseNoseDetection || mUseMouthDetection || mUseLandmarks) {

                    cv::Mat dFace = cv::Mat(gray, faces[i]).clone();

                    if (mUseEyesDetection) {
                        std::vector<cv::Rect> eyes;
                        eyes_cascade.detectMultiScale(dFace, eyes, 1.1, 2);
                        //mEyesClassifier.detectMultiScale(dFace, eyes, 1.1, 2, 0|Objdetect.CASCADE_SCALE_IMAGE, new Size((double)dFaceW, (double)dFaceH), new Size());
                        int eye1Index = -1;
                        CGFloat centerX = 0.0f;
                        CGFloat centerY = (CGFloat)faces[i].height*0.2f;
                        if (eyes.size() > 0) {
                            CGFloat minDist = 10000.0f;
                            for(size_t j = 0; j < eyes.size(); j++) {
                                centerX = (CGFloat)faces[i].width*0.3f;
                                CGFloat eyeX = (CGFloat)eyes[j].x + (CGFloat)eyes[j].width*0.5f;
                                CGFloat eyeY = (CGFloat)eyes[j].y + (CGFloat)eyes[j].height*0.5f;
                                CGFloat dist = [self calcDistance:centerX centerY:centerY pointX:eyeX pointY:eyeY];
                                if (dist < minDist) {
                                    minDist = dist;
                                    eye1Index = (int)j;
                                }
                            }
                            NSString *firstEyeJSON = [self getPartJSON:dFace partKey:@"firstEye" part:eyes[eye1Index] widthToUse:dFace.cols heightToUse:dFace.rows];
                            payloadJSON = [payloadJSON stringByAppendingString:firstEyeJSON];
                        }
                        if (eyes.size() > 1) {
                            CGFloat minDist = 10000.0f;
                            int eye2Index = -1;
                            for(size_t j = 0; j < eyes.size(); j++) {
                                centerX = (CGFloat)faces[i].width*0.7f;
                                CGFloat eyeX = (CGFloat)eyes[j].x + (CGFloat)eyes[j].width*0.5f;
                                CGFloat eyeY = (CGFloat)eyes[j].y + (CGFloat)eyes[j].height*0.5f;
                                CGFloat dist = [self calcDistance:centerX centerY:centerY pointX:eyeX pointY:eyeY];
                                if (dist < minDist && (int)j != eye1Index) {
                                    minDist = dist;
                                    eye2Index = (int)j;
                                }
                            }
                            NSString *secondEyeJSON = [self getPartJSON:dFace partKey:@"secondEye" part:eyes[eye2Index] widthToUse:dFace.cols heightToUse:dFace.rows];
                            payloadJSON = [payloadJSON stringByAppendingString:secondEyeJSON];
                        }
                    }

                    if (mUseNoseDetection) {
                        std::vector<cv::Rect> noses;
                        nose_cascade.detectMultiScale(dFace, noses, 1.1, 2);

                        if (noses.size() > 0) {
                            CGFloat minDist = 10000.0f;
                            int noseIndex = -1;
                            for(size_t j = 0; j < noses.size(); j++) {
                                CGFloat centerX = (CGFloat)faces[i].width*0.5f;
                                CGFloat centerY = (CGFloat)faces[i].height*0.5f;
                                CGFloat noseX = (CGFloat)noses[j].x + (CGFloat)noses[j].width*0.5f;
                                CGFloat noseY = (CGFloat)noses[j].y + (CGFloat)noses[j].height*0.5f;
                                CGFloat dist = [self calcDistance:centerX centerY:centerY pointX:noseX pointY:noseY];
                                if (dist < minDist) {
                                    minDist = dist;
                                    noseIndex = (int)j;
                                }
                            }
                            NSString *noseJSON = [self getPartJSON:dFace partKey:@"nose" part:noses[noseIndex] widthToUse:dFace.cols heightToUse:dFace.rows];
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
                        nose_cascade.detectMultiScale(dFaceForMouthDetecting, mouths, 1.1, 2);
                        if (mouths.size() > 0) {
                            CGFloat minDist = 10000.0f;
                            int mouthIndex = -1;
                            for(size_t j = 0; j < mouths.size(); j++) {
                                CGFloat centerX = (CGFloat)faces[i].width*0.5f;
                                CGFloat centerY = (CGFloat)faces[i].height;
                                CGFloat mouthX = (CGFloat)mouths[j].x + (CGFloat)mouths[j].width*0.5f;
                                CGFloat mouthY = (CGFloat)mouths[j].y + (CGFloat)mouths[j].height*0.5f + (CGFloat)faces[i].height*0.6f;
                                CGFloat dist = [self calcDistance:centerX centerY:centerY pointX:mouthX pointY:mouthY];
                                if (dist < minDist) {
                                    minDist = dist;
                                    mouthIndex = (int)j;
                                }
                            }
                            cv::Rect dRect;
                            dRect.x = mouths[mouthIndex].x;
                            dRect.y = mouths[mouthIndex].y + (int)((CGFloat)dFace.rows * 0.6f);
                            dRect.width = mouths[mouthIndex].width;
                            dRect.height = mouths[mouthIndex].height*0.8f;

                            NSString *mouthJSON = [self getPartJSON:dFace partKey:@"mouth" part:dRect widthToUse:dFace.cols heightToUse:dFace.rows];
                            payloadJSON = [payloadJSON stringByAppendingString:mouthJSON];
                        }
                    }

                    if (landmarksFound) {
                        if (fits.size() > 0) {
                            payloadJSON = [payloadJSON stringByAppendingString:@",\"landmarks\":["];
                            for (int j=0; j < 68; j++) { // 68 landmark points
                                cv::Point thePt = fits[i][j];
                                [self rotatePoint:gray thePoint:thePt];
                                if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
                                    payloadJSON = [payloadJSON stringByAppendingString:[NSString stringWithFormat:@"{\"x\":%f,\"y\":%f}",(double)thePt.x/(double)gray.rows,(double)thePt.y/(double)gray.cols]];
                                }
                                else {
                                    payloadJSON = [payloadJSON stringByAppendingString:[NSString stringWithFormat:@"{\"x\":%f,\"y\":%f}",(double)thePt.x/(double)gray.cols,(double)thePt.y/(double)gray.rows]];
                                }
                                if (j != 67) {
                                    payloadJSON = [payloadJSON stringByAppendingString:@","];
                                }
                                //circle(gray, fits[i][j], 3, Scalar(200,0,0), 2);
                            }
                            payloadJSON = [payloadJSON stringByAppendingString:@"]"];
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

        if (self && self.onFacesDetected) {
            self.onFacesDetected(@{@"payload":payloadJSON});
        }
    }

    if (mCvInvokeGroup != nil) {
        //long currMillis = System.currentTimeMillis();
        //long diff = (currMillis - mCurrentMillis);
        //if (diff >= mOverlayInterval) {
        //    mCurrentMillis = currMillis;
        //[RNOpencv3 invokeMethods:mCvInvokeGroup in:image ingray:gray];
        //}
    }

    // invert image
    //bitwise_not(image_copy, image_copy);

    //Convert BGR to BGRA (three channel to four channel)
    //Mat bgr;
    //cvtColor(image_copy, bgr, COLOR_GRAY2BGR);

    //cvtColor(bgr, image, COLOR_BGR2BGRA);
    //UIImage *videoImage = [FileUtils UIImageFromCVMat:image_copy];
    UIImage *videoImage = MatToUIImage(image_copy);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setImage:videoImage];
    });
}

#pragma Properties

-(void)setCvInvokeGroup:(NSDictionary*)cvinvoke {
    mCvInvokeGroup = cvinvoke;
}

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

- (void)setLandmarksModel:(NSString*)landmarksModel {
    NSString *landmarksPath = [FileUtils loadBundleResource:landmarksModel extension:@"yaml"];

    if (landmarksPath) {
        face::FacemarkLBF::Params params;
        landmarks = face::FacemarkLBF::create(params);
        landmarks->loadModel( std::string([landmarksPath UTF8String]));
        mUseLandmarks = true;
    }
}

- (void)setCascadeClassifier:(NSString*)cascadeClassifier whichOne:(Classifier)whichOne {
    NSString *cascadePath = [FileUtils loadBundleResource:cascadeClassifier extension:@"xml"];

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
