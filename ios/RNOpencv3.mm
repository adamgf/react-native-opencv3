

// @author Adam G. Freeman - adamgf@gmail.com
#import "FileUtils.h"
#import "MatManager.h"
#import "CvInvoke.h"
#import "CvCamera.h"
#import "RNOpencv3.h"

@implementation RNOpencv3

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"onPayload"];
}

RCT_EXPORT_METHOD(imageToMat:(NSString*)inPath resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    [FileUtils imageToMat:inPath resolver:resolve rejecter:reject];
}

RCT_EXPORT_METHOD(desaturate: (int)srcMatIndex dstMatIndex:(int)dstMatIndex scale:(int)scale
                              colorLowLimit:(NSArray *)colorLowLimit colorHighLimit:(NSArray *)colorHighLimit
                              //ha:(int)ha sa:(int)sa va:(int)va
                              //hb:(int)hb sb:(int)sb vb:(int)vb
                  resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    //
    // retrieve the mats from memory, we'll need
    // to work on both the computed and source mat.
    Mat srcMat  = [MatManager.sharedMgr matAtIndex:srcMatIndex];
    Mat dstMat = [MatManager.sharedMgr matAtIndex:dstMatIndex];
    Mat desaturatedHSV, desaturatedImage, srcOrig, hsvImage, mask, result;
    
    srcOrig = srcMat.clone();
    
    float saturationScale = (float) scale / 100;
    cvtColor(srcMat, hsvImage, COLOR_BGR2HSV);
    
    //
    // switch to HSV values and split the arrays in 3
    cvtColor(dstMat, hsvImage, COLOR_BGR2HSV);
    
    std::vector<Mat> channels(3);
    split(hsvImage, channels);
    cv::Mat &S = channels[1];
    
    //
    // apply the desaturation on the S channel
    // and recompute the image to BGR.
    S = S * saturationScale;
    min(S, 255, S);
    max(S,   0, S);
    
    merge(channels, hsvImage);
    hsvImage.convertTo(hsvImage, CV_8UC3);
    cvtColor(hsvImage, desaturatedImage, COLOR_HSV2BGR);
    
    // getting the lowest range of the color
    // using a threshold set in the threshold value
    cv::Scalar minHSV = cv::Scalar([colorLowLimit[0] intValue],
                                   [colorLowLimit[1] intValue],
                                   [colorLowLimit[2] intValue]);
    //    cv::Scalar minHSV = cv::Scalar(ha, sa, va);
    
    // getting the highest range of the color
    // using a threshold set in the threshold value
    //    cv::Scalar maxHSV = cv::Scalar(hb, sb,vb);
    cv::Scalar maxHSV = cv::Scalar([colorHighLimit[0] intValue],
                                   [colorHighLimit[1] intValue],
                                   [colorHighLimit[2] intValue]);
    
    cv::Mat maskHSV, inverseMaskHSV, resultHSV;
    cvtColor(srcOrig, hsvImage, COLOR_BGR2HSV);
    
    cv::inRange(hsvImage, minHSV, maxHSV, maskHSV);
    
    cv::bitwise_not(maskHSV, inverseMaskHSV);
    cv::bitwise_and(hsvImage, hsvImage, resultHSV,  maskHSV);
    
    cvtColor(desaturatedImage, desaturatedHSV, COLOR_BGR2HSV);
    cv::bitwise_and(resultHSV, desaturatedHSV, resultHSV, inverseMaskHSV);
    
    cv::add(resultHSV, desaturatedHSV, resultHSV, inverseMaskHSV);
    cvtColor(resultHSV, resultHSV, COLOR_HSV2BGR);
    
    [MatManager.sharedMgr setMat:dstMatIndex matToSet:resultHSV];
    resolve(@"ack");
}

RCT_EXPORT_METHOD(matToImage:(NSDictionary*)src outPath:(NSString*)outPath resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    if (outPath == nil || outPath == (NSString*)NSNull.null || [outPath isEqualToString:@""]) {
        return reject(@"EINVAL", [NSString stringWithFormat:@"EINVAL: invalid parameter, param '%@'", outPath], nil);
    }
    
    NSNumber *srcMatNum = [src valueForKey:@"matIndex"];
    int matIndex = (int)[srcMatNum integerValue];
    
    MatWrapper *inputMatWrapper = [((MatManager*)MatManager.sharedMgr).mats objectAtIndex:matIndex];
    //Mat inputMat = [MatManager.sharedMgr matAtIndex:matIndex];
    [FileUtils matToImage:inputMatWrapper outPath:outPath resolver:resolve rejecter:reject];
}

RCT_EXPORT_METHOD(cvtColor:(NSDictionary*)src dstMat:(NSDictionary*)dst convColorCode:(int)convColorCode) {

    NSNumber *srcMatNum = [src valueForKey:@"matIndex"];
    NSNumber *dstMatNum = [dst valueForKey:@"matIndex"];

    int srcMatIndex = (int)[srcMatNum integerValue];
    int dstMatIndex = (int)[dstMatNum integerValue];

    Mat srcMat = [MatManager.sharedMgr matAtIndex:srcMatIndex];
    Mat dstMat = [MatManager.sharedMgr matAtIndex:dstMatIndex];

    cvtColor(srcMat, dstMat, convColorCode);

    [MatManager.sharedMgr setMat:dstMatIndex matToSet:dstMat];
}


RCT_EXPORT_METHOD(invokeMethods:(NSDictionary*)cvInvokeMap) {
    CvInvoke *invoker = [[CvInvoke alloc] init];
    NSArray *responseArr = [invoker parseInvokeMap:cvInvokeMap];
    NSString *lastCall = invoker.callback;
    int dstMatIndex = invoker.dstMatIndex;
    [self sendCallbackData:responseArr callback:lastCall dstMatIndex:dstMatIndex];
}

// IMPT NOTE: retArr can either be one single array or an array of arrays ...
-(void)sendCallbackData:(NSArray*)retArr callback:(NSString*)callback dstMatIndex:(int)dstMatIndex {
    if (callback != nil && callback != (NSString*)NSNull.null && ![callback isEqualToString:@""] 
			&& dstMatIndex >= 0 && dstMatIndex < 1000) {
        if (self && retArr && retArr.count > 0) {
            [self sendEventWithName:@"onPayload" body:@{ @"payload" : retArr }];
        }
    }
    else {
        // not necessarily error condition unless dstMatIndex >= 1000
        if (dstMatIndex >= 1000) {
            NSLog(@"Exception thrown attempting to invoke method.  Check your method name and parameters and make sure they are correct.");
        }
    }
}

RCT_EXPORT_METHOD(invokeMethodWithCallback:(NSString*)in func:(NSString*)func params:(NSDictionary*)params out:(NSString*)out callback:(NSString*)callback) {
    CvInvoke *invoker = [[CvInvoke alloc] init];
    int dstMatIndex = [invoker invokeCvMethod:in func:func params:params out:out];
    NSArray *retArr = [MatManager.sharedMgr getMatData:dstMatIndex rownum:0 colnum:0];
    [self sendCallbackData:retArr callback:callback dstMatIndex:dstMatIndex];
}

RCT_EXPORT_METHOD(invokeMethod:(NSString*)func params:(NSDictionary*)params) {
    CvInvoke *invoker = [[CvInvoke alloc] init];
    [invoker invokeCvMethod:nil func:func params:params out:nil];
}

RCT_EXPORT_METHOD(invokeInOutMethod:(NSString*)in func:(NSString*)func params:(NSDictionary*)params out:(NSString*)out) {
    CvInvoke *invoker = [[CvInvoke alloc] init];
    [invoker invokeCvMethod:in func:func params:params out:out];
}

-(void)resolveMatPromise:(int)matIndex rows:(int)rows cols:(int)cols cvtype:(int)cvtype resolver:(RCTPromiseResolveBlock)resolve {
    
    NSDictionary *returnDict;
    if (cvtype == -1) {
        returnDict = @{ @"matIndex" : [NSNumber numberWithInt:matIndex], @"rows" : [NSNumber numberWithInt:rows], @"cols" : [NSNumber numberWithInt:cols] };
    }
    else {
        returnDict = @{ @"matIndex" : [NSNumber numberWithInt:matIndex], @"rows" : [NSNumber numberWithInt:rows], @"cols" : [NSNumber numberWithInt:cols] , @"CvType" : [NSNumber numberWithInt:cvtype] };
    }
    resolve(returnDict);
}

RCT_EXPORT_METHOD(MatWithScalar:(int)rows cols:(int)cols cvtype:(int)cvtype scalarVal:(NSDictionary*)scalarVal resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    int matIndex = [MatManager.sharedMgr createMat:rows cols:cols cvtype:cvtype scalarVal:scalarVal];
    [self resolveMatPromise:matIndex rows:rows cols:cols cvtype:cvtype resolver:resolve];
}

RCT_EXPORT_METHOD(MatWithParams:(int)rows cols:(int)cols cvtype:(int)cvtype resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    int matIndex = [MatManager.sharedMgr createMat:rows cols:cols cvtype:cvtype scalarVal:nil];
    [self resolveMatPromise:matIndex rows:rows cols:cols cvtype:cvtype resolver:resolve];
}

RCT_EXPORT_METHOD(Mat:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    int matIndex = [MatManager.sharedMgr createEmptyMat];
    [self resolveMatPromise:matIndex rows:0 cols:0 cvtype:-1 resolver:resolve];
}

RCT_EXPORT_METHOD(getMatData:(NSDictionary*)mat rownum:(int)rownum colnum:(int)colnum resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSNumber *numForKey = (NSNumber*)[mat objectForKey:@"matIndex"];
    int matIndex = [numForKey intValue];
    NSArray *retArr = [MatManager.sharedMgr getMatData:matIndex rownum:rownum colnum:colnum];
    resolve(retArr);
}

RCT_EXPORT_METHOD(setTo:(NSDictionary*)mat cvscalar:(NSDictionary*)cvscalar) {
    NSNumber *numForKey = (NSNumber*)[mat objectForKey:@"matIndex"];
    int matIndex = [numForKey intValue];
    [MatManager.sharedMgr setToScalar:matIndex cvscalar:cvscalar];
}

RCT_EXPORT_METHOD(put:(NSDictionary*)mat rownum:(int)rownum colnum:(int)colnum data:(NSArray*)data) {
    NSNumber *numForKey = (NSNumber*)[mat objectForKey:@"matIndex"];
    int matIndex = [numForKey intValue];
    [MatManager.sharedMgr putData:matIndex rownum:rownum colnum:colnum data:data];
}

RCT_EXPORT_METHOD(transpose:(NSDictionary*)mat) {
    NSNumber *numForKey = (NSNumber*)[mat objectForKey:@"matIndex"];
    int matIndex = [numForKey intValue];
    [MatManager.sharedMgr transposeMat:matIndex];
}

RCT_EXPORT_METHOD(MatOfInt:(int)lomatval himatval:(int)himatval resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    int matIndex = [MatManager.sharedMgr createMatOfInt:lomatval himatval:himatval];
    resolve(@{ @"matIndex" : [NSNumber numberWithInt:matIndex]});
}

RCT_EXPORT_METHOD(MatOfFloat:(float)lomatval himatval:(float)himatval resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    int matIndex = [MatManager.sharedMgr createMatOfFloat:lomatval himatval:himatval];
    resolve(@{ @"matIndex" : [NSNumber numberWithInt:matIndex]});
}

RCT_EXPORT_METHOD(deleteMat:(NSDictionary*)mat) {
    NSNumber *matIndexNum = [mat valueForKey:@"matIndex"];
    int matIndex = [matIndexNum intValue];
    [MatManager.sharedMgr deleteMatAtIndex:matIndex];
}

RCT_EXPORT_METHOD(deleteMats) {
    [MatManager.sharedMgr deleteMats];
}

@end
