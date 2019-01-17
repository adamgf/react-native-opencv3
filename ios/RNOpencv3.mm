

// @author Adam G. Freeman - adamgf@gmail.com
#import "RNOpencv3.h"
#import "FileUtils.h"

@implementation RNOpencv3

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

/**
 * PUBLIC REACT API
 *
 *  cvtColorGray   simple method to onvert source file to grayscale png or jpeg image using OpenCV
 */
RCT_EXPORT_METHOD(cvtColorGray:(NSString*)inPath outPath:(NSString*)outPath
    resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    // TODO: not sure if this takes long enough to need ot be stuffed into a queue?? -- Adam
    //       probably depends on file size ...
    @try {
        // Check input and output parameters validity
        if (inPath == nil || [inPath isEqualToString:@""]) {
            return reject(@"EINVAL", [NSString stringWithFormat:@"EINVAL: invalid parameter, param '%@'", inPath], nil);
        }
        if (outPath == nil || [outPath isEqualToString:@""]) {
            return reject(@"EINVAL", [NSString stringWithFormat:@"EINVAL: invalid parameter, param '%@'", outPath], nil);
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

        cv::Mat colorMatter = [FileUtils cvMatFromUIImage:sourceImage];

        //get gray image
        cv::Mat greyMatter;
        cv::cvtColor(colorMatter, greyMatter, cv::COLOR_BGR2GRAY);

        UIImage *greyImage = [FileUtils UIImageFromCVMat:greyMatter];
        if (greyImage == nil) {
            return reject(@"ENOENT", [NSString stringWithFormat:@"ENOENT: no such file, open '%@'", greyImage], nil);
        }

        NSString *fileType = [[outPath lowercaseString] pathExtension];
        if ([fileType isEqualToString:@"png"]) {
            [UIImagePNGRepresentation(greyImage) writeToFile:outPath atomically:YES];
        }
        else if ([fileType isEqualToString:@"jpg"] || [fileType isEqualToString:@"jpeg"]) {
            [UIImageJPEGRepresentation(greyImage, 92) writeToFile:outPath atomically:YES];
        }
        else {
            return reject(@"EINVAL", [NSString stringWithFormat:@"EINVAL: unsupported file type, write '%@'", outPath], nil);
        }

        NSString *widStr = [NSString stringWithFormat:@"%d", (int)greyImage.size.width];
        NSString *heiStr = [NSString stringWithFormat:@"%d", (int)greyImage.size.height];

        NSDictionary *returnDict = @{ @"width" : widStr, @"height" : heiStr,
            @"uri" : outPath };

        resolve(returnDict);
    }
    @catch (NSException *ex) {
        reject(@"EGENERIC", [NSString stringWithFormat:@"EGENERIC: exception thrown '%@'", [ex debugDescription]], nil);
    }
}

RCT_EXPORT_METHOD(imageToMat:(NSString*)inPath resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    
    // Check input and output parameters validity
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
    
    cv::Mat outputMat;
    UIImageToMat(sourceImage, outputMat);
    int matIndex = MatManager.sharedMgr.addMat(outputMat);
    
    NSString *matIndexStr = [NSString stringWithFormat:@"%d", MatManager.sharedMgr.addMat(outputMat)];
    NSString *widStr = [NSString stringWithFormat:@"%d", (int)sourceImage.size.width];
    NSString *heiStr = [NSString stringWithFormat:@"%d", (int)sourceImage.size.height];
    
    NSDictionary *returnDict = @{ @"width" : (int)sourceImage.size.width, @"height" : (int)sourceImage.size.height, @"matIndex" : matIndexStr };
    resolve(returnDict)
}

RCT_EXPORT_METHOD(matToImage:(id)jsonObject resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    
    cv::Mat inputMat = MatManager.sharedMgr.matAtIndex(matIndex);

}

@end
