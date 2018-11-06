

// @author Adam G. Freeman - adamgf@gmail.com
#import "RNOpencv3.h"

@implementation RNOpencv3

- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;

    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)

    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags

    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);

    return cvMat;
}

-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;

    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    }
    else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }

    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);

    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );


    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);

    return finalImage;
}

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

        cv::Mat colorMatter = [self cvMatFromUIImage:sourceImage];

        //get gray image
        cv::Mat greyMatter;
        cv::cvtColor(colorMatter, greyMatter, cv::COLOR_BGR2GRAY);

        UIImage *greyImage = [self UIImageFromCVMat:greyMatter];
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

@end
