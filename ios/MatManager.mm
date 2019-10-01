//
//  FileUtils.m
//  RNOpencv3
//
//  Created by Adam G Freeman on 01/15/19.
//  Copyright © 2019 Adam G Freeman. All rights reserved.
//

#import "MatManager.h"
#import <Foundation/Foundation.h>

// simple opaque object that wraps a cv::Mat or other OpenCV object or other type ...
@implementation MatWrapper
@end

// Ostensibly a Mat is an all-purpose OpenCV opaque object referenced by an index in javascript
// For react-native purposes cv::Mat is an opaque type that is contained in an NSMutableArray and
// accessed by indexing into the array.  Eventually it has to be converted into an image to be useable anyways.
// MatManager: singleton class for retaining the mats for image processing operations
@implementation MatManager

+(id)sharedMgr {
    static MatManager *sharedMatManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMatManager = [[self alloc] init];
    });
    return sharedMatManager;
}

-(id)init {
    if (self = [super init]) {
        self.mats = [[NSMutableArray alloc] init];
    }
    return self;
}

-(int)createEmptyMat {
    Mat emptyMat;
    return ([self addMat:emptyMat]);
}

-(int)createMat:(int)rows cols:(int)cols cvtype:(int)cvtype scalarVal:(NSDictionary*)cvscalar {
    //int matIndex = (int)self.mats.count;
    Mat matToAdd;
    NSArray *scalarVal = [cvscalar objectForKey:@"vals"];
    if (scalarVal != nil) {
        double *demolitionman = new double[4];
        for (int i=0;i < 4;i++) {
            NSNumber *blade = [scalarVal objectAtIndex:i];
            demolitionman[i] = [blade doubleValue];
        }
        Scalar risingsun = {demolitionman[0],demolitionman[1],demolitionman[2],demolitionman[3]};
        Mat junglefever(rows, cols, cvtype, risingsun);
        matToAdd = junglefever;
    }
    else {
        Mat newjackcity(rows, cols, cvtype);
        matToAdd = newjackcity;
    }
    return ([self addMat:matToAdd]);
}

-(int)createMatOfInt:(int)lomatval himatval:(int)himatval {
    if (himatval == -1) {
        himatval = lomatval + 1;
    }
    int matIndex = (int)self.mats.count;
    std::vector<int> vec;
    if (lomatval == himatval) {
        vec.push_back(lomatval);
    }
    else {
        for (int i = lomatval;i < himatval;i++) {
            vec.push_back(i);
        }
    }
    Mat moneytrain(vec);
    [self addMat:moneytrain];
    return matIndex;
}

-(int)createMatOfFloat:(float)lomatval himatval:(float)himatval {
    int matIndex = (int)self.mats.count;
    std::vector<float> vec;
    if (lomatval == himatval) {
        vec.push_back(lomatval);
    }
    else {
        for (int i = lomatval;i < himatval;i++) {
            vec.push_back((float)i);
        }
    }
    Mat bladeII(vec);
    [self addMat:bladeII];
    return matIndex;
}

-(int)addMat:(Mat)matToAdd {
    int matIndex = (int)self.mats.count;
    MatWrapper *MW = [[MatWrapper alloc] init];
    MW.myMat = matToAdd.clone();
    [self.mats addObject:MW];
    return matIndex;
}

-(Mat)matAtIndex:(int)matIndex {
    if (matIndex >= 0 && matIndex < self.mats.count) {
        MatWrapper *MW = (MatWrapper*)self.mats[matIndex];
        return MW.myMat;
    }
    else {
        NSLog(@"Requested mat index %d out of range!", matIndex);
        return Mat();
    }
}

-(void)setMat:(int)matIndex matToSet:(Mat)matToSet {
    if (matIndex >= 0 && matIndex < self.mats.count) {
        MatWrapper *MW = (MatWrapper*)self.mats[matIndex];
        MW.myMat = matToSet;
    }
}

-(NSArray*)getMatData:(int)matIndex rownum:(int)rownum colnum:(int)colnum {
    MatWrapper *MW = (MatWrapper*)self.mats[matIndex];
    Mat mat = MW.myMat;

    int matType = mat.type();
    uchar depth = matType & CV_MAT_DEPTH_MASK;
    uchar chans = 1 + (matType >> CV_CN_SHIFT);
    
    NSMutableArray *retArr = [[NSMutableArray alloc] initWithCapacity:(mat.rows*mat.cols*chans)];
    
    for (int j=0;j < mat.rows;j++) {
        for (int i=0;i < mat.cols*chans;i+=chans) {
            for (int ch=0;ch < chans;ch++) {
                
                switch ( depth ) {
                    default:
                    case CV_8U: { uchar dUChar = mat.at<uchar>(j, i + ch);NSNumber *ucnum = [NSNumber numberWithUnsignedChar:dUChar];[retArr addObject:ucnum]; break; }
                    case CV_8S: { schar dSChar = mat.at<schar>(j, i + ch);NSNumber *scnum = [NSNumber numberWithChar:dSChar];[retArr addObject:scnum]; break; }
                    case CV_16U: { ushort dUShort = mat.at<ushort>(j, i + ch);NSNumber *usnum = [NSNumber numberWithUnsignedShort:dUShort];[retArr addObject:usnum]; break; }
                    case CV_16S: { short dShort = mat.at<short>(j, i + ch);NSNumber *snum = [NSNumber numberWithShort:dShort];[retArr addObject:snum]; break; }
                    case CV_32S: { int dInt = mat.at<int>(j, i + ch);NSNumber *inum = [NSNumber numberWithInt:dInt];[retArr addObject:inum]; break; }
                    case CV_32F: { float dFloat = mat.at<float>(j, i + ch);NSNumber *fnum = [NSNumber numberWithFloat:dFloat];[retArr addObject:fnum]; break; }
                    case CV_64F: { double dDouble = mat.at<double>(j, i + ch);NSNumber *dnum = [NSNumber numberWithDouble:dDouble];[retArr addObject:dnum]; break; }
                }
            }
        }
    }
    return retArr;
}

-(void)setToScalar:(int)matIndex cvscalar:(NSDictionary*)cvscalar {
    MatWrapper *MW = (MatWrapper*)self.mats[matIndex];
    Mat mat = MW.myMat;
    NSArray *scalarVal = [cvscalar objectForKey:@"vals"];
    double *scalarDubs = new double[4];
    for (int i=0;i < 4;i++) {
        NSNumber *Vnum = [scalarVal objectAtIndex:i];
        scalarDubs[i] = [Vnum doubleValue];
    }

    Scalar dScalar = {scalarDubs[0],scalarDubs[1],scalarDubs[2],scalarDubs[3]};
    mat = dScalar;
    [self setMat:matIndex matToSet:mat];
}

-(void)putData:(int)matIndex rownum:(int)rownum colnum:(int)colnum data:(NSArray*)data {
    MatWrapper *MW = (MatWrapper*)self.mats[matIndex];
    Mat mat = MW.myMat;
    
    int matType = mat.type();
    uchar depth = matType & CV_MAT_DEPTH_MASK;
    //uchar chans = 1 + (matType >> CV_CN_SHIFT);
    
    for (int i=0;i < data.count;i++) {
        NSNumber *dataVal = [data objectAtIndex:i];
        switch ( depth ) {
            default:
            case CV_8U: { mat.at<uchar>(rownum, i) = [dataVal unsignedCharValue]; break; }
            case CV_8S: { mat.at<schar>(rownum, i) = [dataVal charValue]; break; }
            case CV_16U: { mat.at<ushort>(rownum, i) = [dataVal unsignedShortValue]; break; }
            case CV_16S: { mat.at<short>(rownum, i) = [dataVal shortValue]; break; }
            case CV_32S: { mat.at<int>(rownum, i) = [dataVal intValue]; break; }
            case CV_32F: { mat.at<float>(rownum, i) = [dataVal floatValue]; break; }
            case CV_64F: { mat.at<double>(rownum, i) = [dataVal doubleValue]; break; }
        }
    }
    
    [self setMat:matIndex matToSet:mat];
}

-(void)transposeMat:(int)matIndex {
    MatWrapper *MW = (MatWrapper*)self.mats[matIndex];
    Mat mat = MW.myMat;

    mat.t();
    [self setMat:matIndex matToSet:mat];
}

-(void)deleteMatAtIndex:(int)matIndex {
    MatWrapper *MW = (MatWrapper*)self.mats[matIndex];
    MW.myMat.release();
    MW.myMat.~Mat();
    [self.mats removeObjectAtIndex:matIndex];
}

-(void)deleteMats {
    for (int i=0;i < self.mats.count;i++) {
        MatWrapper *MW = (MatWrapper*)self.mats[i];
        MW.myMat.release();
        MW.myMat.~Mat();
    }
    [self.mats removeAllObjects];
}

-(void)dealloc {
    [self deleteMats];
    self.mats = nil;
}

@end
