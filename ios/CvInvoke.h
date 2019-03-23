//
//  CvInvoke.h
//  RNOpencv3
//
//  Created by Adam G Freeman on 2/14/19.
//  Copyright © 2019 Adam G. Freeman. All rights reserved.
//
#import <objc/runtime.h>
#import <Foundation/Foundation.h>

#ifndef CvInvoke_h
#define CvInvoke_h

template<class... ArgTypes>
void callOpenCvMethod(ArgTypes... p);

enum NumberType {
    INTTYPE,
    FLOATTYPE,
    DOUBLETYPE
};

@interface NumberWrapper : NSObject
@property (nonatomic, assign) int intval;
@property (nonatomic, assign) float floatval;
@property (nonatomic, assign) double doubleval;
@property (nonatomic, assign) NumberType numbertype;
@end

@interface CvInvoke : NSObject

-(id)initWithRgba:(Mat)rgba gray:(Mat)gray;

+(NSArray*)populateInvokeGroups:(NSDictionary*)cvInvokeGroup;

-(int)invokeCvMethods:(NSDictionary*)cvInvokeMap;

-(int)invokeCvMethod:(NSString*)in func:(NSString*)func params:(NSDictionary*)params out:(NSString*)out;

-(NSArray*)parseInvokeMap:(NSDictionary*)cvInvokeMap;

@property int arrMatIndex;

@property int dstMatIndex;

@property (nonatomic, copy) NSString *callback;

@property (nonatomic, assign) Mat rgba;

@property (nonatomic, assign) Mat gray;

@property (nonatomic, strong) NSMutableDictionary *matParams;

@end

#endif /* CvInvoke_h */
