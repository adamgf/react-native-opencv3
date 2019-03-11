//
//  CvFunctionWrapper.m
//  RNOpencv3
//
//  Created by Adam G Freeman on 2/20/19.
//  Copyright © 2019 Facebook. All rights reserved.
//
#import "CvFunctionWrapper.h"

Mat* cvtColorWrap(const NSArray* zData) {
    Mat m1;NSData *m1data = zData[0];[m1data getBytes:&m1 length:m1data.length];
    Mat m2;NSData *m2data = zData[1];[m2data getBytes:&m2 length:m2data.length];
    int i3;NSData *i3data = zData[2];[i3data getBytes:&i3 length:i3data.length];
    int i4;NSData *i4data = zData[3];[i4data getBytes:&i4 length:i4data.length];
    cvtColor(m1, m2, i3, i4);
    
    return nil;
}
