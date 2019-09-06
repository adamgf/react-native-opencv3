//
//  RNOpencv3Mat.h
//  RNOpencv3
//
//  Created by Adam G Freeman on 01/15/19.
//  Copyright © 2019 Adam G Freeman. All rights reserved.
//

#ifndef MatManager_h
#define MatManager_h

#import "External.h"
#import <AVFoundation/AVFoundation.h>

@interface MatWrapper : NSObject
@property (nonatomic, assign) Mat myMat;
@end

@interface MatManager : NSObject

@property (nonatomic, strong) NSMutableArray *mats;

+(id)sharedMgr;

-(int)createEmptyMat;

-(int)createMat:(int)rows cols:(int)cols cvtype:(int)cvtype scalarVal:(NSDictionary*)cvscalar;

-(int)createMatOfInt:(int)lomatval himatval:(int)himatval;

-(int)createMatOfFloat:(float)lomatval himatval:(float)himatval;

-(int)addMat:(Mat)matToAdd;

-(Mat)matAtIndex:(int)matIndex;

-(void)setMat:(int)matIndex matToSet:(Mat)matToSet;

-(NSArray*)getMatData:(int)matIndex rownum:(int)rownum colnum:(int)colnum;

-(void)setToScalar:(int)matIndex cvscalar:(NSDictionary*)cvscalar;

-(void)putData:(int)matIndex rownum:(int)rownum colnum:(int)colnum data:(NSArray*)data;

-(void)transposeMat:(int)matIndex;

-(void)deleteMatAtIndex:(int)matIndex;

-(void)deleteMats;

@end

#endif
