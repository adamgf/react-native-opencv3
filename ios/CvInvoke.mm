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
#include <variant>

typedef std::variant<int,double,float,const char*,Mat,Scalar,cv::Point> ocvtypes;

std::vector<std::string> Imgproc = {
    "cvtColor"
};

std::vector<std::string> iptypes = {
    "Mat,Mat,int,int"
};

typedef enum fns {
    CVTCOLOR
} fns;

template<typename... T>
void invokeIt(std::vector<std::string>lookup, std::string functionName, T *...args) {
    auto it = std::find(lookup.begin(), lookup.end(), functionName);
    if (it != lookup.end()) {
        auto index = std::distance(lookup.begin(), it);
        
        switch(index) {
            case CVTCOLOR: {
                cvtColor(*args...);
                break;
            }
            default:
                break;
        }
    }
}

void callOpenCvMethod(std::string searchClass, std::string functionName, std::vector<ocvtypes>* ps) {
    
    //std::vector<std::string> lookup;
    //if (searchClass.compare(std::string("Imgproc")) == 0) {
    //    lookup = Imgproc;
    //}
    
    unsigned long numParams = 4; //paramTypes.size();
    
    if (numParams == 4) {
        ocvtypes firstMat = ps->at(0);
        auto p1 = *reinterpret_cast<Mat*>(&firstMat);
        ocvtypes secondMat = ps->at(1);
        auto p2 = *reinterpret_cast<Mat*>(&secondMat);
        ocvtypes firstInt = ps->at(2);
        auto p3 = *reinterpret_cast<int*>(&firstInt);
        ocvtypes secondInt = ps->at(3);
        auto p4 = *reinterpret_cast<int*>(&secondInt);
        //cvtColor(p1, p2, p3, p4);
        invokeIt(Imgproc, functionName, &p1, &p2, &p3, &p4);
        int kk = 2002;
        kk++;
    }
}

/**
void paramsToFunctionCall(std::string fname, std::vector<void*> args, std::string sclass) {
    
    unsigned long argCount = args.size();
    
    if (argCount == 0) {
        callOpenCvMethod(fname, NULL, sclass);
    }
    else if (argCount == 1) {
        
    }
} */

// simple opaque object that wraps a cv::Mat or other OpenCV object or other type ...
//@implementation MatWrapper2
//@end

@implementation CvInvoke

-(id)init {
    if (self = [super init]) {
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
    //NSMutableArray *retObjs = [[NSMutableArray alloc] initWithCapacity:params.count];
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
                ps.push_back(dstMat);
                //MatWrapper *MW = [[MatWrapper alloc] init];
                //MW.myMat = dstMat;
                //[retObjs insertObject:MW atIndex:(i-1)];
                
            }
            else if ([param isEqualToString:@"const char*"]) {
                const char *pushStr = [paramStr UTF8String];
                ps.push_back(pushStr);
                //[retObjs insertObject:paramStr atIndex:(i-1)];
            }
        }
        else if ([itsType containsString:@"Number"]) {
            // not sure what to do here exactly ...
            NSNumber *dNum = (NSNumber*)[hashMap valueForKey:paramNum];
            if ([param isEqualToString:@"double"]) {
                double ddNum = [dNum doubleValue];
                ps.push_back(ddNum);
            }
            else if ([param isEqualToString:@"int"]) {
                int diNum = [dNum intValue];
                ps.push_back(diNum);
            }
            else if ([param isEqualToString:@"float"]) {
                float dfNum = [dNum floatValue];
                ps.push_back(dfNum);
            }
            //[retObjs insertObject:dNum atIndex:(i-1)];
        }
        else if ([param isEqualToString:@"Mat"] || [param isEqualToString:@"InputArray"] || [param isEqualToString:@"InputArrayOfArrays"] || [param isEqualToString:@"OutputArray"] || [param isEqualToString:@"OutputArrayOfArrays"]) {
            if ([itsType containsString:@"Dictionary"]) {
                NSDictionary* matMap = (NSDictionary*)[hashMap valueForKey:paramNum];
                int matIndex = [(NSNumber*)[matMap valueForKey:@"matIndex"] intValue];
                Mat dMat = [MatManager.sharedMgr matAtIndex:matIndex];
                ps.push_back(dMat);
                //MatWrapper *MW = [[MatWrapper alloc] init];
                //MW.myMat = dMat;
                //[retObjs insertObject:MW atIndex:(i-1)];
                self.arrMatIndex = i - 1;
                self.dstMatIndex = matIndex;
            }
        }
        else if ([param isEqualToString:@"Scalar"]) {
            
        }
        else if ([param isEqualToString:@"Point"]) {
            
        }
        else if ([param isEqualToString:@"Size"]) {
            
        }
        i++;
    }
    //return ps;
}

-(int)findMethod:(NSString*)func params:(NSDictionary*)params searchClass:(NSString*)searchClass {
    int funcIndex = -1;
    int numParams = 0;
    if (params != NULL) {
        numParams = [CvInvoke getNumKeys:params];
    }
    
    int i = 0;
    std::vector<std::string>::iterator it;  // declare an iterator to a vector of strings
    std::vector<std::string> lookup;
    std::vector<std::string> ptypes;
    if ([searchClass isEqualToString:@"Imgproc"]) {
        lookup = Imgproc;
        ptypes = iptypes;
    }
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
    
    if (groupids != NULL && groupids.count > 0) {
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
            [invokeGroup setValue:calls forKey:@"calls"];
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
-(NSArray*)getParameterTypes:(int)methodIndex searchClass:(NSString*)searchClass {
    std::vector<std::string> ptypes;
    if ([searchClass isEqualToString:@"Imgproc"]) {
        ptypes = iptypes;
    }
    NSString *paramTypesStr = [NSString stringWithUTF8String:ptypes[methodIndex].c_str()];
    return [paramTypesStr componentsSeparatedByString:@","];
}

-(int)invokeCvMethod:(NSString*)in func:(NSString*)func params:(NSDictionary*)params out:(NSString*)out {
   
   int result = -1;
   int numParams = 0;
   if (params != NULL) {
       numParams = [CvInvoke getNumKeys:params];
   }
   //NSArray *objects = NULL;
   std::vector<ocvtypes> ps;
   int methodIndex = -1;
   NSString *searchClass;
   
   @try {
       /**
       typedef std::function<void(cv::InputArray,cv::OutputArray,int,int)> fun;
       
       fun f_display = cvtColor;
       
       Scalar usethisscalar(255,255,0,255);
       //ocvtypes inmat = Mat(500,500,CV_8UC4,usethisscalar);
       NSDictionary *fmat = [params valueForKey:@"p1"];
       int fmatindex = [[fmat valueForKey:@"matIndex"] intValue];
       ocvtypes inmat = [MatManager.sharedMgr matAtIndex:fmatindex];
       NSDictionary *fmat2 = [params valueForKey:@"p2"];
       int fmatindex2 = [[fmat2 valueForKey:@"matIndex"] intValue];
       ocvtypes outmat = [MatManager.sharedMgr matAtIndex:fmatindex2];
       //ocvtypes outmat = Mat();
       //ocvtypes inmat2 = arr1;
       //ocvtypes outmat2 = outmat;
       
       std::vector<ocvtypes*> ps;
       ocvtypes thirdval = 6;
       ocvtypes fourthval = 0;
       //ocvtypes fiveval = thirdval;
       //ocvtypes sixval = fourthval;
       
       ps.push_back(&inmat);
       ps.push_back(&outmat);
       ps.push_back(&thirdval);
       ps.push_back(&fourthval);
        
       
       NSArray *methodParams = [self getParameterTypes:0 searchClass:@"Imgproc"];
       std::vector<ocvtypes> ps;
       [self getObjectArr:params params:methodParams objects:ps];
       
       callOpenCvMethod(std::string("Imgproc"), std::string("cvtColor"), &ps);
       
       //f_display(&ps[0],&ps[1],,0); */
       
       if (in != nil) {
           if (![in isEqualToString:@""] && ([in isEqualToString:@"rgba"] || [in isEqualToString:@"rgbat"] || [in isEqualToString:@"gray"] || [in isEqualToString:@"grayt"] || (self.matParams != nil && [self.matParams.allKeys containsObject:in]))) {
               
               methodIndex = [self findMethod:func params:params searchClass:@"Mat"];
               
               if (methodIndex >= 0) {
                    searchClass = @"Mat";
                }
           }
       }
       else {
           methodIndex = [self findMethod:func params:params searchClass:@"Imgproc"];
           if (methodIndex >= 0) {
               searchClass = @"Imgproc";
           }
           else {
               methodIndex = [self findMethod:func params:params searchClass:@"Core"];
               if (methodIndex >= 0) {
                   searchClass = @"Core";
               }
           }
       }
       
       if (methodIndex == -1) {
           [NSException raise:@"Method not found" format:@"%@ not found make sure method exists and is part of Opencv Imgproc, Core or Mat.", func];
       }
       if (numParams > 0) {
           NSArray *methodParams = [self getParameterTypes:methodIndex searchClass:searchClass];
           [self getObjectArr:params params:methodParams objects:ps];
           
           if (numParams != methodParams.count) {
               [NSException raise:@"Invalid parameter" format:@"One of the parameters is invalid and %@ cannot be invoked.", func];
           }
       }
       if (methodIndex != -1) {
           Mat matToUse;
           
           if (in != nil) {
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
                   matToUse = self.rgba.t();
               }
               else if ([self.matParams.allKeys containsObject:in]) {
                   MatWrapper *MW = (MatWrapper*)[self.matParams valueForKey:in];
                   matToUse = MW.myMat;
               }
           }
           
           if (out != nil) {
               // TODO ...
               //id matParam;
               //if (matParam != NULL) {
               //    [self.matParams setObject:matParam forKey:out];
               //}
           }
           else {
               if (matToUse.rows > 0 && [func isEqualToString:@"release"]) {
                   // special case deleting the last Mat
                   matToUse.release();
                   [self.matParams removeObjectForKey:in];
               }
               else {
                   std::string dFunc = std::string([func UTF8String]);
                   std::string dSearchClass = std::string([searchClass UTF8String]);
                   callOpenCvMethod(dSearchClass, dFunc, &ps);
               }
           }
       }
       
       if (self.dstMatIndex >= 0) {
           //MatWrapper *dstMatWrapper = (MatWrapper*)objects[self.arrMatIndex];
           ocvtypes dMat = ps.at(self.arrMatIndex);
           Mat dstMat = *reinterpret_cast<Mat*>(&dMat);
           //Mat dstMat = dstMatWrapper.myMat;
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

@end
