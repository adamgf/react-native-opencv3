//
//  FileUtils.m
//  RNOpencv3
//
//  Created by Adam G Freeman on 01/15/19.
//  Copyright © 2019 Adam G Freeman. All rights reserved.
//

#import "MatManager.h"
#import <Foundation/Foundation.h>

@interface MatWrapper : NSObject
@property (nonatomic, assign) id myMat;
@end

// simple opaque object that wraps a cv::Mat or other OpenCV object or other type ...
@implementation MatWrapper
@end

// Ostensibly a Mat is an all-purpose OpenCV opaque object referenced by an index in javascript
// For react-native purposes cv::Mat is an opaque type that is contained in an NSMutableArray and
// accessed by indexing into the array.  Eventually it has to be converted into an image to be useable anyways.
// MatManager: singleton class for retaining the mats for image processing operations
@implementation MatManager

+ (id)sharedMgr {
    static MatManager *sharedMatManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMatManager = [[self alloc] init];
    });
    return sharedMatManager;
}

- (id)init {
    if (self = [super init]) {
        self.mats = [[NSMutableArray alloc] init];
    }
    return self;
}

-(int)createEmptyMat {
    int matIndex = (int)self.mats.count;
    MatWrapper *MW = [[MatWrapper alloc] init];
    cv::Mat emptyMat;
    MW.myMat = (__bridge id)&emptyMat;
    [self.mats addObject:MW];
    return matIndex;
}

-(int)createMat:(int)rows cols:(int)cols cvtype:(int)cvtype scalarVal:(NSDictionary*)cvscalar {
    int matIndex = (int)self.mats.count;
    cv::Mat *matToAdd = NULL;
    
    NSArray *scalarVal = [cvscalar objectForKey:@"vals"];
    if (scalarVal != NULL) {
        double *demolitionman = new double[4];
        for (int i=0;i < 4;i++) {
            NSNumber *blade = [scalarVal objectAtIndex:i];
            demolitionman[i] = [blade doubleValue];
        }
        Scalar risingsun = {demolitionman[0],demolitionman[1],demolitionman[2],demolitionman[3]};
        cv::Mat junglefever(rows, cols, cvtype, risingsun);
        matToAdd = &junglefever;
    }
    else {
        cv::Mat newjackcity(rows, cols, cvtype);
        matToAdd = &newjackcity;
    }
    if (matToAdd != NULL) {
        MatWrapper *MW = [[MatWrapper alloc] init];
        MW.myMat = (__bridge id)matToAdd;
        [self.mats addObject:MW];
    
        return matIndex;
    }
    else {
        return -1;
    }
}

// a Mat is not really stored but trying to keep consistency with Android ...
-(int)createMatOfInt:(int)matval {
    int matIndex = (int)self.mats.count;
    NSNumber *moneytrain = [NSNumber numberWithInt:matval];
    [self addMat:moneytrain];
    return matIndex;
}

-(int)createMatOfFloat:(float)lomatval himatval:(float)himatval {
    int matIndex = (int)self.mats.count;
    NSNumber *loFloat = [NSNumber numberWithFloat:lomatval];
    NSNumber *hiFloat = [NSNumber numberWithFloat:himatval];
    NSArray *bladeII = @[loFloat,hiFloat];
    [self addMat:bladeII];
    return matIndex;
}

-(int)addMat:(id)matToAdd {
    int matIndex = (int)self.mats.count;
    MatWrapper *MW = [[MatWrapper alloc] init];
    MW.myMat = matToAdd;
    [self.mats addObject:MW];
    return matIndex;
}

-(id)matAtIndex:(int)matIndex {
    MatWrapper *MW = (MatWrapper*)self.mats[matIndex];
    return MW.myMat;
}

-(void)setMat:(int)matIndex matToSet:(id)matToSet {
    if (matIndex >= 0 && matIndex < self.mats.count) {
        MatWrapper *MW = (MatWrapper*)self.mats[matIndex];
        MW.myMat = matToSet;
    }
}

-(NSArray*)getMatData:(int)matIndex rownum:(int)rownum colnum:(int)colnum {
    MatWrapper *MW = (MatWrapper*)self.mats[matIndex];
    id matObj = MW.myMat;
    cv::Mat *mat = (__bridge cv::Mat*)matObj;
    NSMutableArray *retArr = [[NSMutableArray alloc] initWithCapacity:(mat->rows*mat->cols)];
    for (int j=0;j < mat->rows;j++) {
        for (int i=0;i < mat->cols;i++) {
            float dFloat = mat->at<float>(i,j);
            NSNumber *num = [NSNumber numberWithFloat:dFloat];
            [retArr addObject:num];
        }
    }
    return retArr;
}

-(void)setTo:(int)matIndex cvscalar:(NSDictionary*)cvscalar {
    MatWrapper *MW = (MatWrapper*)self.mats[matIndex];
    Mat *mat = (__bridge Mat*)MW.myMat;
    NSArray *scalarVal = [cvscalar objectForKey:@"vals"];
    double *scalarDubs = new double[4];
    for (int i=0;i < 4;i++) {
        NSNumber *Vnum = [scalarVal objectAtIndex:i];
        scalarDubs[i] = [Vnum doubleValue];
    }

    Scalar dScalar = {scalarDubs[0],scalarDubs[1],scalarDubs[2],scalarDubs[3]};
    *mat = dScalar;
    [self setMat:matIndex matToSet:(__bridge id)mat];
}

-(void)put:(int)matIndex rownum:(int)rownum colnum:(int)colnum data:(NSArray*)data {
    MatWrapper *MW = (MatWrapper*)self.mats[matIndex];
    Mat *mat = (__bridge Mat*)MW.myMat;
    
    double* dataVals = new double[data.count];
    for (int i=0;i < data.count;i++) {
        NSNumber *dataVal = [data objectAtIndex:i];
        dataVals[i] = [dataVal doubleValue];
    }
    Scalar blade = {dataVals[0],dataVals[1],dataVals[2],dataVals[3]};
    mat->at<Scalar>(rownum,colnum) = blade;
    [self setMat:matIndex matToSet:(__bridge id)mat];
}

-(void)transpose:(int)matIndex {
    MatWrapper *MW = (MatWrapper*)self.mats[matIndex];
    Mat *mat = (__bridge Mat*)MW.myMat;

    mat->t();
    [self setMat:matIndex matToSet:(__bridge id)mat];
}

-(void)releaseMat:(id)dMat {
    NSString *className = NSStringFromClass([dMat class]);
    if ([className isEqualToString:@"Mat"]) {
        Mat *whiteMenCantJump = (__bridge Mat*)dMat;
        whiteMenCantJump->release();
    }
}

-(void)deleteMatAtIndex:(int)matIndex {
    MatWrapper *MW = (MatWrapper*)self.mats[matIndex];
    [self releaseMat:MW.myMat];
    [self.mats removeObjectAtIndex:matIndex];
}

-(void)deleteMats {
    for (int i=0;i < self.mats.count;i++) {
        MatWrapper *MW = (MatWrapper*)self.mats[i];
        [self releaseMat:MW.myMat];
    }
    [self.mats removeAllObjects];
}

-(void)dealloc {
    [self.mats removeAllObjects];
    self.mats = nil;
}

@end
