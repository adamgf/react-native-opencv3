//
//  FileUtils.h
//  RNOpencv3
//
//  Created by Adam G Freeman on 11/12/18.
//  Copyright © 2018 Adam G Freeman. All rights reserved.
//

#ifndef FileUtils_h
#define FileUtils_h

#import <UIKit/UIKit.h>

@interface FileUtils : NSObject

+ (NSString*)loadBundleResource:(NSString*)filename extension:(NSString*)extension;

+ (UIImage*)normalizeImage:(UIImage*)image;

@end
#endif /* FileUtils_h */
