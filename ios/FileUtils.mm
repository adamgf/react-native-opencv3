//
//  FileUtils.m
//  RNOpencv3
//
//  Created by Adam G Freeman on 11/12/18.
//  Copyright © 2018 Adam G Freeman. All rights reserved.
//

#import "FileUtils.h"
#import "CvCamera.h"
#import <Foundation/Foundation.h>

@implementation FileUtils

+ (NSString*)loadBundleResource:(NSString*)filename extension:(NSString*)extension {

    NSBundle *podBundle = [NSBundle bundleForClass:CvCamera.class];
    NSURL *bundleURL = [podBundle URLForResource:@"ocvdata" withExtension:@"bundle"];
    NSBundle *dBundle = [NSBundle bundleWithURL:bundleURL];
    NSString *landmarksPath = [dBundle pathForResource:filename ofType:extension];

    return landmarksPath;
}

// this function makes sure the image is displayed in the correct orientation according
// to its metadata
+ (UIImage*)normalizeImage:(UIImage *)image {
    
    if (image.imageOrientation == UIImageOrientationUp) {
        return image;
    }
    
    UIGraphicsBeginImageContextWithOptions(image.size, false, 0.0/*image.scale*/);
    [image drawInRect:CGRectMake(0.0f, 0.0f, image.size.width, image.size.height)];
    UIImage *normalizedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImg;
}

@end

