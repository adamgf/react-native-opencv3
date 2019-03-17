

// @author Adam G. Freeman - adamgf@gmail.com
#import "FileUtils.h"
#import "MatManager.h"
#import "CvInvoke.h"
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

    // Check input parameters validity
    if (inPath == nil || inPath == (NSString*)NSNull.null || [inPath isEqualToString:@""]) {
        return reject(@"EINVAL", [NSString stringWithFormat:@"EINVAL: invalid parameter, param '%@'", inPath], nil);
    }
    // make sure input exists and is not a directory and output not a dir
    if (![[NSFileManager defaultManager] fileExistsAtPath: inPath]) {
        return reject(@"ENOENT", [NSString stringWithFormat:@"ENOENT: no such file, open '%@'", inPath], nil);
    }
    BOOL isDir = NO;
    if([[NSFileManager defaultManager] fileExistsAtPath:inPath isDirectory:&isDir] && isDir) {
        return reject(@"EISDIR", [NSString stringWithFormat:@"EISDIR: illegal operation on a directory, open '%@'", inPath], nil);
    }

    UIImage *sourceImage = [UIImage imageWithContentsOfFile:inPath];

    if (sourceImage == nil) {
        return reject(@"ENOENT", [NSString stringWithFormat:@"ENOENT: no such file, open '%@'", inPath], nil);
    }

    UIImage *normalizedImage = [FileUtils normalizeImage:sourceImage];

    Mat outputMat;
    UIImageToMat(normalizedImage, outputMat);
    int matIndex = [MatManager.sharedMgr addMat:outputMat];

    NSNumber *wid = [NSNumber numberWithInt:(int)sourceImage.size.width];
    NSNumber *hei = [NSNumber numberWithInt:(int)sourceImage.size.height];
    NSNumber *matI = [NSNumber numberWithInt:matIndex];

    NSDictionary *returnDict = @{ @"cols" : wid, @"rows" : hei, @"matIndex" : matI };
    resolve(returnDict);
}

RCT_EXPORT_METHOD(matToImage:(NSDictionary*)src outPath:(NSString*)outPath resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {

    if (outPath == nil || outPath == (NSString*)NSNull.null || [outPath isEqualToString:@""]) {
        return reject(@"EINVAL", [NSString stringWithFormat:@"EINVAL: invalid parameter, param '%@'", outPath], nil);
    }

    NSNumber *srcMatNum = [src valueForKey:@"matIndex"];
    int matIndex = (int)[srcMatNum integerValue];

    Mat inputMat = [MatManager.sharedMgr matAtIndex:matIndex];

    UIImage *destImage = MatToUIImage(inputMat);
    if (destImage == nil) {
        return reject(@"ENOENT", [NSString stringWithFormat:@"ENOENT: no such file, open '%@'", destImage], nil);
    }

    NSString *fileType = [[outPath lowercaseString] pathExtension];
    if ([fileType isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(destImage) writeToFile:outPath atomically:YES];
    }
    else if ([fileType isEqualToString:@"jpg"] || [fileType isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(destImage, 92) writeToFile:outPath atomically:YES];
    }
    else {
        return reject(@"EINVAL", [NSString stringWithFormat:@"EINVAL: unsupported file type, write '%@'", fileType], nil);
    }

    NSNumber *wid = [NSNumber numberWithInt:(int)destImage.size.width];
    NSNumber *hei = [NSNumber numberWithInt:(int)destImage.size.height];

    NSDictionary *returnDict = @{ @"width" : wid, @"height" : hei,
                                  @"uri" : outPath };

    resolve(returnDict);
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
    NSArray *responseArr = nil;
    NSString *lastCall = nil;
    int dstMatIndex = -1;
    NSArray *groupids = nil;
    if ([cvInvokeMap.allKeys containsObject:@"groupids"]) {
        groupids = (NSArray*)[cvInvokeMap valueForKey:@"groupids"];
        if (groupids != nil && groupids.count > 0) {
            NSArray *invokeGroups = [CvInvoke populateInvokeGroups:cvInvokeMap];
            responseArr = [[NSMutableArray alloc] initWithCapacity:invokeGroups.count];
            for (int i=(int)(invokeGroups.count-1);i >= 0;i--) {
                CvInvoke *invoker = [[CvInvoke alloc] init];
                dstMatIndex = [invoker invokeCvMethods:(NSDictionary*)invokeGroups[i]];
                if (invoker.callback != nil) {
                    lastCall = invoker.callback;
                }
                if (lastCall != nil && lastCall != (NSString*)NSNull.null && dstMatIndex >= 0 && dstMatIndex < 1000) {
                    NSArray *retArr = [MatManager.sharedMgr getMatData:dstMatIndex rownum:0 colnum:0];
                    [(NSMutableArray*)responseArr addObject:retArr];
                }
            }
        }
    }
    else {
        CvInvoke *invoker = [[CvInvoke alloc] init];
        dstMatIndex = [invoker invokeCvMethods:cvInvokeMap];
        if (invoker.callback != nil) {
            lastCall = invoker.callback;
        }
        if (lastCall != nil && lastCall != (NSString*)NSNull.null && dstMatIndex >= 0 && dstMatIndex < 1000) {
            responseArr = [MatManager.sharedMgr getMatData:dstMatIndex rownum:0 colnum:0];
        }
    }
    [self sendCallbackData:responseArr callback:lastCall dstMatIndex:dstMatIndex];
}

// IMPT NOTE: retArr can either be one single array or an array of arrays ...
-(void)sendCallbackData:(NSArray*)retArr callback:(NSString*)callback dstMatIndex:(int)dstMatIndex {
    if (callback != nil && callback != (NSString*)NSNull.null && dstMatIndex >= 0 && dstMatIndex < 1000) {
        // not sure how this should be handled yet for different return objects ...
        //[self sendEventWithName:@"onPayload" body:@{ @"payload" : retArr }];
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
