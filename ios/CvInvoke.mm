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
#import "CvFunctionWrapper.h"
#include <variant>
#include <any>

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

template <typename K>
inline K castit(ocvtypes* ocvtype) {
    return *reinterpret_cast<K*>(ocvtype);
}

struct MatType { };
struct IntType { };

struct Cast {
    auto cast(ocvtypes in, MatType) { return castit<Mat>(&in); }
    auto cast(ocvtypes in, IntType) { return castit<int>(&in); }
};

struct allparams {
    std::tuple<MatType,MatType,IntType,IntType> f0 =  std::make_tuple(MatType(),MatType(),IntType(),IntType());
    std::tuple<MatType,MatType,IntType> f1 = std::make_tuple(MatType(),MatType(),IntType());
};

template<typename... T>
void invokeIt(std::string searchClass, std::string functionName, T&... args) {
    std::vector<std::string> lookup;
    if (searchClass.compare("Imgproc") == 0) {
        lookup = Imgproc;
    }
    
    auto it = std::find(lookup.begin(), lookup.end(), functionName);
    if (it != lookup.end()) {
        auto index = std::distance(lookup.begin(), it);
        
        switch(index) {
            case CVTCOLOR: {
                cvtColor(args...);
                break;
            }
            default:
                break;
        }
    }
}

template<int fnargnum, typename tup>
Mat callOpenCvMethod(std::string searchClass, std::string functionName, const std::vector<ocvtypes>& args, tup& tuptypes) {

    std::vector<std::string> lookup;
    if (searchClass.compare("Imgproc") == 0) {
        lookup = Imgproc;
    }
    
    if (fnargnum == 3) {
        Cast cast;
        auto lamb = [&cast](ocvtypes ocvt, auto c){ return cast.cast(ocvt, c); };
        std::map<std::string, decltype(lamb)> m;
        m.emplace("cast", lamb);
        auto p1 = m.at("cast")(args[0], std::get<0>(tuptypes));
        auto p2 = m.at("cast")(args[1], std::get<1>(tuptypes));
        auto p3 = m.at("cast")(args[2], std::get<2>(tuptypes));
        invokeIt(lookup, functionName, p1, p2, p3);
        return p2;
    }
    else if (fnargnum == 4) {
        Cast cast2;
        auto lamb = [&cast2](ocvtypes ocvt, auto c){ return cast2.cast(ocvt, c); };
        std::map<std::string, decltype(lamb)> m2;
        m2.emplace("cast", lamb);
        auto p1 = m2.at("cast")(args[0], std::get<0>(tuptypes));
        auto p2 = m2.at("cast")(args[1], std::get<1>(tuptypes));
        auto p3 = m2.at("cast")(args[2], std::get<2>(tuptypes));
        auto p4 = m2.at("cast")(args[3], std::get<3>(tuptypes));
        invokeIt(lookup, functionName, p1, p2, p3, p4);
        return p2;
    }
    return Mat();
}

@implementation NumberWrapper
@end

@implementation CvInvoke

-(id)init {
    if (self = [super init]) {
        self.arrMatIndex = -1;
        self.dstMatIndex = -1;
        self.matParams = [[NSMutableDictionary alloc] init];
        self.tupleTypes = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+(int)getNumKeys:(NSDictionary*)hashMap {
    return (int)hashMap.allKeys.count;
}

std::tuple<Mat> matt;
std::tuple<int> intt;

template <typename TT>
std::vector<std::tuple<TT>> vect;

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
                ps.push_back(dstMat);
                
            }
            else if ([param isEqualToString:@"const char*"]) {
                const char *pushStr = [paramStr UTF8String];
                ps.push_back(pushStr);
            }
        }
        else if ([itsType containsString:@"Number"]) {
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
        }
        else if ([param isEqualToString:@"Mat"] || [param isEqualToString:@"InputArray"] || [param isEqualToString:@"InputArrayOfArrays"] || [param isEqualToString:@"OutputArray"] || [param isEqualToString:@"OutputArrayOfArrays"]) {
            if ([itsType containsString:@"Dictionary"]) {
                NSDictionary* matMap = (NSDictionary*)[hashMap valueForKey:paramNum];
                int matIndex = [(NSNumber*)[matMap valueForKey:@"matIndex"] intValue];
                Mat dMat = [MatManager.sharedMgr matAtIndex:matIndex];
                ps.push_back(dMat);
                
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
   std::vector<ocvtypes> ps;
   int methodIndex = -1;
   NSString *searchClass;
   Mat dstMat;
    
   @try {
       
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
                   
                   Mat m1 = *reinterpret_cast<Mat*>(&ps[0]); Mat m2 = *reinterpret_cast<Mat*>(&ps[1]); int i3 = *reinterpret_cast<int*>(&ps[2]); int i4 = *reinterpret_cast<int*>(&ps[3]);
                   cvtColor(m1, m2, i3, i4);
                   dstMat = m2;
                   
                   int kkwwf = 2007;
                   kkwwf++;
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

@end
