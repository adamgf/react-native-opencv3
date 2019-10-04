//
//  CvInvoke.mm
//  RNOpencv3
//
//  Created by Adam G Freeman on 2/14/19.
//  Copyright © 2019 Adam G. Freeman. All rights reserved.
//  adamgf@gmail.com
//
#import "CvInvoke.h"
#import "MatManager.h"
#import "OpencvFuncs.h"

@implementation CvInvoke

-(id)init {
    if (self = [super init]) {
        self.arrMatIndex = -1;
        self.dstMatIndex = -1;
        self.matParams = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(id)initWithRgba:(const Mat&)rgba gray:(const Mat&)gray {
    if (self = [super init]) {
        if (rgba.rows > 0) {
            self.rgba = rgba;
        }
        if (gray.rows > 0) {
            self.gray = gray;
        }
        self.arrMatIndex = -1;
        self.dstMatIndex = -1;
        self.matParams = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+(int)getNumKeys:(NSDictionary*)hashMap {
    return (int)hashMap.allKeys.count;
}

-(void)getObjectArr:(NSDictionary*)hashMap params:(NSArray*)params objects:(std::vector<ocvtypes>&)ps {
    
    int i = 1;
    for (NSString* param in params) {
        NSString* paramNum = [NSString stringWithFormat:@"p%d", i];
        NSString* itsType = NSStringFromClass([[hashMap valueForKey:paramNum] class]);
        if ([itsType containsString:@"String"]) {
            // special case for a Mat being represented by a hardcoded string representation ...
            NSString *paramStr = [hashMap valueForKey:paramNum];
            Mat dstMat;
            if ([paramStr isEqualToString:@"rgba"]) {
                dstMat = self.rgba;
            }
            else if ([paramStr isEqualToString:@"rgbat"]) {
                dstMat = self.rgba.t();
            }
            else if ([paramStr isEqualToString:@"gray"]) {
                dstMat = self.gray;
            }
            else if ([paramStr isEqualToString:@"grayt"]) {
                dstMat = self.gray.t();
            }
            else if ([self.matParams.allKeys containsObject:paramStr]) {
                MatWrapper *MW = (MatWrapper*)[self.matParams valueForKey:paramStr];
                dstMat = MW.myMat;
            }
            if (dstMat.rows > 0) {
                // whatever the type is the Mat will suffice
                ocvtypes matType(dstMat);
                ps.push_back(matType);
            }
            else if ([param isEqualToString:@"const char*"]) {
                const char *pushStr = [paramStr UTF8String];
                ocvtypes strType(pushStr);
                ps.push_back(strType);
            }
        }
        else if ([itsType containsString:@"Number"]) {
            NSNumber *dNum = (NSNumber*)[hashMap valueForKey:paramNum];
            if ([param isEqualToString:@"double"]) {
                double ddNum = [dNum doubleValue];
                ocvtypes doubleType(ddNum);
                ps.push_back(doubleType);
            }
            else if ([param isEqualToString:@"int"]) {
                int diNum = [dNum intValue];
                ocvtypes intType(diNum);
                ps.push_back(intType);
            }
            else if ([param isEqualToString:@"float"]) {
                float dfNum = [dNum floatValue];
                ocvtypes floatType(dfNum);
                ps.push_back(floatType);
            }
        }
        else if ([itsType containsString:@"Boolean"]) {
            NSNumber *dBool = (NSNumber*)[hashMap valueForKey:paramNum];
            bool boolVal = [dBool boolValue];
            ocvtypes boolType(boolVal);
            ps.push_back(boolType);
        }
        else if ([itsType containsString:@"Dictionary"]) {
            NSDictionary *dMap = (NSDictionary*)[hashMap valueForKey:paramNum];
            
            if ([param isEqualToString:@"Mat"] || [param isEqualToString:@"MatOfInt"] || [param isEqualToString:@"MatOfFloat"] || [param isEqualToString:@"OutMat"]) {

                int matIndex = [(NSNumber*)[dMap valueForKey:@"matIndex"] intValue];
                Mat dMat = [MatManager.sharedMgr matAtIndex:matIndex];
                //void *matmem = malloc(sizeof(Mat));
                //memcpy(matmem, dMat.ptr(), sizeof(Mat));
                ocvtypes matType(dMat);
                ps.push_back(matType);
                
                if ([param isEqualToString:@"OutMat"]) {
                    self.arrMatIndex = i - 1;
                    self.dstMatIndex = matIndex;
                }
            }
            else if ([param isEqualToString:@"Scalar"]) {
                NSArray *vals = (NSArray*)[dMap valueForKey:@"vals"];
                double v0 = [(NSNumber*)vals[0] doubleValue];
                double v1 = [(NSNumber*)vals[1] doubleValue];
                double v2 = [(NSNumber*)vals[2] doubleValue];
                double v3 = [(NSNumber*)vals[3] doubleValue];
                Scalar dScalar(v0, v1, v2, v3);
                ocvtypes scalarType(dScalar);
                ps.push_back(scalarType);
            }
            else if ([param isEqualToString:@"Point"]) {
                double xval = [(NSNumber*)[dMap valueForKey:@"x"] doubleValue];
                double yval = [(NSNumber*)[dMap valueForKey:@"y"] doubleValue];
                CvPoint dPoint(xval, yval);
                ocvtypes pointType(dPoint);
                ps.push_back(pointType);
            }
            else if ([param isEqualToString:@"Size"]) {
                int wid = [(NSNumber*)[dMap valueForKey:@"width"] intValue];
                int hei = [(NSNumber*)[dMap valueForKey:@"height"] intValue];
                CvSize dSize(wid, hei);
                ocvtypes sizeType(dSize);
                ps.push_back(sizeType);
            }
            else if ([param isEqualToString:@"Rect"]) {
                double top = [(NSNumber*)[dMap valueForKey:@"top"] doubleValue];
                double left = [(NSNumber*)[dMap valueForKey:@"left"] doubleValue];
                double wid = [(NSNumber*)[dMap valueForKey:@"width"] doubleValue];
                double hei = [(NSNumber*)[dMap valueForKey:@"height"] doubleValue];
                CvRect dRect(left, top, wid, hei);
                ocvtypes rectType(dRect);
                ps.push_back(rectType);
            }
        }
        i++;
    }
}

-(int)findMethod:(NSString*)func params:(NSDictionary*)params {
    int funcIndex = -1;
    int numParams = 0;
    if (params != nil && params != (NSDictionary*)NSNull.null) {
        numParams = [CvInvoke getNumKeys:params];
    }
    
    int i = 0;
    std::vector<std::string>::iterator it;  // declare an iterator to a vector of strings
    std::vector<std::string> lookup = Functions;
    std::vector<std::string> ptypes = types;
    
    for (it=lookup.begin();it != lookup.end();it++,i++) {
        NSString *lookupStr = [NSString stringWithUTF8String:lookup[i].c_str()];
        if ([lookupStr isEqualToString:func]) {
            NSString *paramTypesStr = [NSString stringWithUTF8String:ptypes[i].c_str()];
            if ([paramTypesStr isEqualToString:@""] && numParams == 0) {
                funcIndex = i;
                break;
            }
            else {
                NSArray *paramTypes = [paramTypesStr componentsSeparatedByString:@","];
                if (paramTypes.count == numParams) {
                    funcIndex = i;
                    break;
                }
            }
        }
    }
    return funcIndex;
}

// static method ...
// break up the meta invoke group object into an array of invoke groups
+(NSArray*)populateInvokeGroups:(NSDictionary*)cvInvokeGroup {
    
    int numKeys = [CvInvoke getNumKeys:cvInvokeGroup];
    NSMutableArray *invokeGroupList = [[NSMutableArray alloc] initWithCapacity:numKeys];

    NSArray *ins = [cvInvokeGroup valueForKey:@"ins"];
    NSArray *functions = [cvInvokeGroup valueForKey:@"functions"];
    NSArray *paramsArr = [cvInvokeGroup valueForKey:@"paramsArr"];
    NSArray *outs = [cvInvokeGroup valueForKey:@"outs"];
    NSArray *callbacks = [cvInvokeGroup valueForKey:@"callbacks"];
    NSArray *groupids = [cvInvokeGroup valueForKey:@"groupids"];
    
    if (groupids != nil && groupids.count > 0) {
        int i = 0;
        while (i < groupids.count) {
            NSDictionary* invokeGroup = [[NSMutableDictionary alloc] init];
            NSMutableArray *inobs = [[NSMutableArray alloc] init];
            NSMutableArray *funcs = [[NSMutableArray alloc] init];
            NSMutableArray *parms = [[NSMutableArray alloc] init];
            NSMutableArray *otobs = [[NSMutableArray alloc] init];
            NSMutableArray *calls = [[NSMutableArray alloc] init];
            
            NSString *invokeGroupStr = (NSString*)[groupids objectAtIndex:i];
            while (i < groupids.count && [(NSString*)[groupids objectAtIndex:i] isEqualToString:invokeGroupStr]) {
                NSString *in = (NSString*)[ins objectAtIndex:i];
                NSString *function = (NSString*)[functions objectAtIndex:i];
                NSDictionary *params = (NSDictionary*)[paramsArr objectAtIndex:i];
                NSString *out = (NSString*)[outs objectAtIndex:i];
                NSString *callback = (NSString*)[callbacks objectAtIndex:i];
                [inobs addObject:in];
                [funcs addObject:function];
                [parms addObject:params];
                [otobs addObject:out];
                [calls addObject:callback];
                i++;
            }
            [invokeGroup setValue:inobs forKey:@"ins"];
            [invokeGroup setValue:funcs forKey:@"functions"];
            [invokeGroup setValue:parms forKey:@"paramsArr"];
            [invokeGroup setValue:otobs forKey:@"outs"];
            [invokeGroup setValue:calls forKey:@"callbacks"];
            [invokeGroupList addObject:invokeGroup];
        }
    }
    return invokeGroupList;
}

-(int)invokeCvMethods:(NSDictionary*)cvInvokeMap {
    
    int ret = -1;
    NSArray *ins = (NSArray*)[cvInvokeMap valueForKey:@"ins"];
    NSArray *functions = (NSArray*)[cvInvokeMap valueForKey:@"functions"];
    NSArray *paramsArr = (NSArray*)[cvInvokeMap valueForKey:@"paramsArr"];
    NSArray *outs = (NSArray*)[cvInvokeMap valueForKey:@"outs"];
    NSArray *callbacks = (NSArray*)[cvInvokeMap valueForKey:@"callbacks"];
    
    // back to front
    for (int i=(int)(functions.count-1);i >= 0;i--) {
        NSString *inobj = (NSString*)[ins objectAtIndex:i];
        NSString *function = (NSString*)[functions objectAtIndex:i];
        NSDictionary *params = (NSDictionary*)[paramsArr objectAtIndex:i];
        NSString *outobj = (NSString*)[outs objectAtIndex:i];
        
        if (i == 0) {
            self.callback = [callbacks objectAtIndex:0];
            // last method in invoke group might have callback ...
            ret = [self invokeCvMethod:inobj func:function params:params out:outobj];
        }
        else {
            [self invokeCvMethod:inobj func:function params:params out:outobj];
        }
    }
    return ret;
}

// simple helper function ...
-(NSArray*)getParameterTypes:(int)methodIndex {
    std::vector<std::string> ptypes = types;
    NSString *paramTypesStr = [NSString stringWithUTF8String:ptypes[methodIndex].c_str()];
    return [paramTypesStr componentsSeparatedByString:@","];
}

-(int)invokeCvMethod:(NSString*)in func:(NSString*)func params:(NSDictionary*)params out:(NSString*)out {
   
   int result = -1;
   int numParams = 0;
   if (params != nil && params != (NSDictionary*)NSNull.null) {
       numParams = [CvInvoke getNumKeys:params];
   }
   std::vector<ocvtypes> ps;
   int methodIndex = -1;
   Mat dstMat;
    
   @try {
       
       /**
       if (in != nil && in != (NSString*)[NSNull null]) {
           if (![in isEqualToString:@""] && ([in isEqualToString:@"rgba"] || [in isEqualToString:@"rgbat"] || [in isEqualToString:@"gray"] || [in isEqualToString:@"grayt"] || (self.matParams != nil && [self.matParams.allKeys containsObject:in]))) {
               
               methodIndex = [self findMethod:func params:params searchClass:@"Mat"];
               
               if (methodIndex >= 0) {
                    searchClass = @"Mat";
                }
           }
       }
       else { */
       
       methodIndex = [self findMethod:func params:params];
       
       /**
           if (methodIndex >= 0) {
               searchClass = @"Imgproc";
           }
           else {
               methodIndex = [self findMethod:func params:params searchClass:@"Core"];
               if (methodIndex >= 0) {
                   searchClass = @"Core";
               }
           }
       } */
       
       if (methodIndex == -1) {
           [NSException raise:@"Method not found" format:@"%@ not found make sure method exists and is part of Opencv Imgproc, Core or Mat.", func];
       }
       if (numParams > 0) {
           NSArray *methodParams = [self getParameterTypes:methodIndex];
           [self getObjectArr:params params:methodParams objects:ps];
           
           if (numParams != methodParams.count) {
               return -1;
               //[NSException raise:@"Invalid parameter" format:@"One of the parameters is invalid and %@ cannot be invoked.", func];
           }
       }
       if (methodIndex != -1) {
           Mat matToUse;
           
           if (in != nil && in != (NSString*)[NSNull null] && ![in isEqualToString:@""]) {
               if ([in isEqualToString:@"rgba"]) {
                   matToUse = self.rgba;
               }
               else if ([in isEqualToString:@"rgbat"]) {
                   matToUse = self.rgba.t();
               }
               else if ([in isEqualToString:@"gray"]) {
                   matToUse = self.gray;
               }
               else if ([in isEqualToString:@"grayt"]) {
                   matToUse = self.gray.t();
               }
               else if ([self.matParams.allKeys containsObject:in]) {
                   MatWrapper *MW = (MatWrapper*)[self.matParams valueForKey:in];
                   matToUse = MW.myMat;
               }
           }
           
           if (out != nil && out != (NSString*)[NSNull null]) {
               std::string dFunc = std::string([func UTF8String]);
               Mat matParam = callOpencvMethod(methodIndex, ps, matToUse);
               MatWrapper *MW = [[MatWrapper alloc] init];
               MW.myMat = matParam;
               self.matParams[out] = MW;
           }
           else {
               if (matToUse.rows > 0 && [func isEqualToString:@"release"]) {
                   // special case deleting the last Mat
                   matToUse.release();
                   [self.matParams removeObjectForKey:in];
               }
               else {
                   std::string dFunc = std::string([func UTF8String]);
                   
                   dstMat = callOpencvMethod(methodIndex, ps);
               }
           }
       }
       
       if (self.dstMatIndex >= 0) {
           [MatManager.sharedMgr setMat:self.dstMatIndex matToSet:dstMat];
           result = self.dstMatIndex;
           self.dstMatIndex = -1;
           self.arrMatIndex = -1;
       }
   }
   @catch (NSException* EXC) {
       result = 1000;
       NSLog(@"%@ -- %@", EXC.name, EXC.debugDescription);
   }
   @finally {
       return result;
   }
}

-(NSArray*)parseInvokeMap:(NSDictionary*)cvInvokeMap {
    NSArray *responseArr = nil;
    NSArray *groupids = nil;
    if ([cvInvokeMap.allKeys containsObject:@"groupids"]) {
        groupids = (NSArray*)[cvInvokeMap valueForKey:@"groupids"];
        if (groupids != nil && groupids.count > 0) {
            NSArray *invokeGroups = [CvInvoke populateInvokeGroups:cvInvokeMap];
            responseArr = [[NSMutableArray alloc] initWithCapacity:invokeGroups.count];
            for (int i=(int)(invokeGroups.count-1);i >= 0;i--) {
                self.dstMatIndex = [self invokeCvMethods:(NSDictionary*)invokeGroups[i]];
                if (self.callback != nil && self.callback != (NSString*)NSNull.null && self.dstMatIndex >= 0 && self.dstMatIndex < 1000) {
                    NSArray *retArr = [MatManager.sharedMgr getMatData:self.dstMatIndex rownum:0 colnum:0];
                    [(NSMutableArray*)responseArr addObject:retArr];
                }
            }
        }
    }
    else {
        self.dstMatIndex = [self invokeCvMethods:cvInvokeMap];
        if (self.callback != nil && self.callback != (NSString*)NSNull.null && self.dstMatIndex >= 0 && self.dstMatIndex < 1000) {
            responseArr = [MatManager.sharedMgr getMatData:self.dstMatIndex rownum:0 colnum:0];
        }
    }
	return responseArr;
}

@end
