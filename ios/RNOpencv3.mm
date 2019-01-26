

// @author Adam G. Freeman - adamgf@gmail.com
#import "RNOpencv3.h"
#import "FileUtils.h"
#import "MatManager.h"

@implementation RNOpencv3

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(imageToMat:(NSString*)inPath resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {

    // Check input parameters validity
    if (inPath == nil || [inPath isEqualToString:@""]) {
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

    cv::Mat outputMat;
    UIImageToMat(normalizedImage, outputMat);
    int matIndex = [(MatManager*)MatManager.sharedMgr addMat:outputMat];

    NSNumber *wid = [NSNumber numberWithInt:(int)sourceImage.size.width];
    NSNumber *hei = [NSNumber numberWithInt:(int)sourceImage.size.height];
    NSNumber *matI = [NSNumber numberWithInt:matIndex];

    NSDictionary *returnDict = @{ @"cols" : wid, @"rows" : hei, @"matIndex" : matI };
    resolve(returnDict);
}

RCT_EXPORT_METHOD(matToImage:(NSDictionary*)src outPath:(NSString*)outPath resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {

    if (outPath == nil || [outPath isEqualToString:@""]) {
        return reject(@"EINVAL", [NSString stringWithFormat:@"EINVAL: invalid parameter, param '%@'", outPath], nil);
    }

    NSNumber *srcMatNum = [src valueForKey:@"matIndex"];
    int matIndex = (int)[srcMatNum integerValue];

    cv::Mat inputMat = [(MatManager*)MatManager.sharedMgr matAtIndex:matIndex];

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

    cv::Mat srcMat = [(MatManager*)MatManager.sharedMgr matAtIndex:srcMatIndex];
    cv::Mat dstMat = [(MatManager*)MatManager.sharedMgr matAtIndex:dstMatIndex];

    cvtColor(srcMat, dstMat, convColorCode);

    [(MatManager*)MatManager.sharedMgr setMat:dstMat atIndex:dstMatIndex];
}

RCT_EXPORT_METHOD(Mat:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    int matIndex = [(MatManager*)MatManager.sharedMgr createEmptyMat];
    NSString *matIndexStr = [NSString stringWithFormat:@"%d", matIndex];
    NSDictionary *returnDict = @{ @"matIndex" : matIndexStr, @"cols" : @0, @"rows" : @0 };
    resolve(returnDict);
}

RCT_EXPORT_METHOD(deleteMat:(NSDictionary*)mat) {
    NSNumber *matIndexNum = [mat valueForKey:@"matIndex"];
    int matIndex = (int)[matIndexNum integerValue];
    [(MatManager*)MatManager.sharedMgr deleteMatAtIndex:matIndex];
}

RCT_EXPORT_METHOD(deleteMats) {
    [(MatManager*)MatManager.sharedMgr deleteMats];
}

@end
