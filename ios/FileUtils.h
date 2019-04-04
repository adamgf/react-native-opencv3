//
//  FileUtils.h
//  RNOpencv3
//
//  Created by Adam G Freeman on 11/12/18.
//  Copyright © 2018 Adam G Freeman. All rights reserved.
//

#ifndef FileUtils_h
#define FileUtils_h

//#import <React/RCTEventEmitter.h>
#import <React/RCTBridge.h>
#import <UIKit/UIKit.h>

@class MatWrapper;

@interface FileUtils : NSObject

+ (NSString*)loadBundleResource:(NSString*)filename extension:(NSString*)extension;

+ (UIImage*)normalizeImage:(UIImage*)image;

+ (void)matToImage:(MatWrapper*)inputMat outPath:(NSString*)outPath resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;

+ (void)imageToMat:(NSString*)inPath resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject;

@end
#endif /* FileUtils_h */
