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

std::vector<std::string> lookup = {
    "cvtColor"
};

typedef enum fns {
    CVTCOLOR
} fns;

template<class... ArgTypes>
void callOpenCvMethod(ArgTypes... p) {
    
    std::string functionName("cvtColor");
    auto it = std::find(lookup.begin(), lookup.end(), functionName);
    if (it != lookup.end()) {
        auto index = std::distance(lookup.begin(), it);
        
        switch(index) {
                case CVTCOLOR: {
                    cvtColor(p...);
                    break;
                }
            default:
                break;
        }
    }
}

@interface MatWrapper2 : NSObject
@property (nonatomic, assign) Mat myMat;
@end

// simple opaque object that wraps a cv::Mat or other OpenCV object or other type ...
@implementation MatWrapper2
@end

@implementation CvInvoke

-(id)initWithRgba:(Mat)rgba gray:(Mat)gray {
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

-(NSArray*)getObjectArr:(NSDictionary*)hashMap params:(NSArray*)params {
    
    int i = 1;
    NSMutableArray *retObjs = [[NSMutableArray alloc] initWithCapacity:params.count];
    
    for (Class paramClass in params) {
        NSString* paramNum = [NSString stringWithFormat:@"p%d", i];
        NSString* param = NSStringFromClass(paramClass);
        NSString* itsType = NSStringFromClass([hashMap valueForKey:paramNum]);
        if ([itsType isEqualToString:@"NSString"]) {
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
                MatWrapper2 *MW2 = (MatWrapper2*)[self.matParams valueForKey:paramStr];
                dstMat = MW2.myMat;
            }
            if (dstMat.rows > 0) {
                // whatever the type is the Mat will suffice
                MatWrapper2 *MW2 = [[MatWrapper2 alloc] init];
                MW2.myMat = dstMat;
                [retObjs insertObject:MW2 atIndex:(i-1)];
                
            }
            else if ([param isEqualToString:@"NSString"]) {
                [retObjs insertObject:paramStr atIndex:(i-1)];
            }
        }
        else if ([param isEqualToString:@"Mat"] || [param isEqualToString:@"InputArray"] || [param isEqualToString:@"InputArrayOfArrays"] || [param isEqualToString:@"OutputArray"] || [param isEqualToString:@"OutputArrayOfArrays"]) {
            if ([itsType isEqualToString:@"Mat"]) {
                NSDictionary* matMap = (NSDictionary*)[hashMap valueForKey:paramNum];
                int matIndex = [(NSNumber*)[matMap valueForKey:@"matIndex"] intValue];
                Mat dMat = [MatManager.sharedMgr  matAtIndex:matIndex];
                MatWrapper2 *MW2 = [[MatWrapper2 alloc] init];
                MW2.myMat = dMat;
                [retObjs insertObject:MW2 atIndex:(i-1)];
                self.arrMatIndex = i - 1;
                self.dstMatIndex = matIndex;
            }
        }
        else if ([param isEqualToString:@"const std::vector<int>&"]) {
            // not sure what to do here exactly ...
            int j = i + 1;
            j++;
        }
        else if ([param isEqualToString:@"const std::vector<float>&"]) {
            // again not sure what to do here yet ...
            int k = i + 4;
            k+=2;
        }
        else if ([param isEqualToString:@"const std::vector<double>&"]) {
            // again not sure what to do here yet ...
            int k = i + 5;
            k--;
        }
        else if ([param isEqualToString:@"bool"]) {
            // again same fuckin thing ... fuck
        }
        else if ([param isEqualToString:@"int"]) {
            
        }
        else if ([param isEqualToString:@"float"]) {
            
        }
        else if ([param isEqualToString:@"double"]) {
            
        }
        else if ([param isEqualToString:@"cv::Scalar"]) {
            
        }
        else if ([param isEqualToString:@"cv::Point"]) {
            
        }
        else if ([param isEqualToString:@"cv::Size"]) {
            
        }
        i++;
    }
    return retObjs;
}

-(Method)findMethod:(NSString*)func params:(NSDictionary*)params searchClass:(Class)searchClass {
    Method retMethod = NULL;
    int numParams = 0;
    if (params != NULL) {
        numParams = [CvInvoke getNumKeys:params];
    }
    //SEL method = NSSelectorFromString(func);
    //NSMethodSignature* methodParams = [searchClass methodSignatureForClass:method];
    
    unsigned int numMethods = 0;
    Method *methods = class_copyMethodList(searchClass, &numMethods);
    
    for (int i=0;i < numMethods;i++) {
        NSString* methodName = [NSString stringWithUTF8String:sel_getName(method_getName(methods[i]))];
        if ([methodName isEqualToString:func]) {
            if (numParams > 0) {
                if (numParams == method_getNumberOfArguments(methods[i])) {
                    retMethod = methods[i];
                    break;
                }
            }
            else {
                retMethod = methods[i];
                break;
            }
        }
    }
    return retMethod;
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
-(NSArray*)getParameterTypes:(Method)method {
    unsigned int numParams = method_getNumberOfArguments(method);
    NSMutableArray *classesArr = [[NSMutableArray alloc] initWithCapacity:numParams];
    
    for (unsigned int i=0;i < numParams;i++) {
        char *argumentTypeStr = (char*)calloc(2048, 1);
        size_t strlen = 2048;
        method_getArgumentType(method, i, argumentTypeStr, strlen);
        NSString *argumentType = [NSString stringWithUTF8String:argumentTypeStr];
        Class dClass = NSClassFromString(argumentType);
        [classesArr insertObject:dClass atIndex:i];
        free(argumentTypeStr);
    }
    return classesArr;
}

-(int)invokeCvMethod:(NSString*)in func:(NSString*)func params:(NSDictionary*)params out:(NSString*)out {
   
   int result = -1;
   int numParams = 0;
   if (params != NULL) {
       numParams = [CvInvoke getNumKeys:params];
   }
   NSArray *objects = NULL;
   
   @try {
       Method method = NULL;
       
       NSString *bundlePath = [[[NSBundle mainBundle] builtInPlugInsPath]           // 1
                     stringByAppendingPathComponent:@"../opencv2.bundle/opencv2.framework"];
       
       NSURL *bundleURL = [NSURL fileURLWithPath:bundlePath];
       CFBundleRef cfBundle = CFBundleCreate(kCFAllocatorDefault, (CFURLRef)bundleURL);

       CFBundleRef ocv2 = CFBundleGetBundleWithIdentifier(CFSTR("opencv2"));
       CFArrayRef loadedFrameworks = CFBundleGetAllBundles();
       
       NSArray *lframes2 = [NSBundle allBundles];
       
       NSArray *lframes3 = [NSBundle allFrameworks];
       NSString *disPath = [[NSBundle mainBundle] builtInPlugInsPath];
       
       long discount = CFArrayGetCount(loadedFrameworks);
       //or (int i=0;i < discount;i++) {
         //  CFBundleRef disherebundle = (CFBundleRef)CFArrayGetValueAtIndex(loadedFrameworks, i);
           
           
           NSBundle *amazingBundle = [NSBundle bundleForClass:[self class]];

       NSString *ident = [amazingBundle bundleIdentifier];
       CFBundleRef br = CFBundleGetMainBundle();
    
       void* doSomething = CFBundleGetFunctionPointerForName(cfBundle,
                                                             CFSTR("cvtColorTwoPlane"));
           
           if (doSomething != NULL) {
               NSLog(@"Stop here");
           }
       //}
       NSString *fuckingmatid = @"cvtColor";
       
       typedef void (*opencv_t);
       std::string yourfunc("cvtColor");
       
       typedef std::function<void(cv::InputArray,cv::OutputArray,int,int)> fun;
       
       fun f_display = cvtColor;
       
       Scalar usethisscalar(255,255,0,255);
       Mat inmat(500,500,CV_8UC4,usethisscalar);
       Mat outmat;
       
       std::vector<void*> ps;
       
       ps.push_back(&inmat);
       ps.push_back(&outmat);
       int thirdval = 6;
       ps.push_back(&thirdval);
       
       callOpenCvMethod(inmat, outmat, thirdval, 0);
       
       //f_display(inmat,outmat,6,0);
       
       Class matclass = [fuckingmatid class]; //NSClassFromString(@"cv::Mat");
       Class imgprocclass = NSClassFromString(@"cv::Imgproc");
       Class coreclass = NSClassFromString(@"cv::Core");
       
       method = [self findMethod:func params:params searchClass:matclass];

       if (in != NULL && ![in isEqualToString:@""] && ([in isEqualToString:@"rgba"] || [in isEqualToString:@"rgbat"] || [in isEqualToString:@"gray"] || [in isEqualToString:@"grayt"] || [self.matParams.allKeys containsObject:in]))
           {
           
           method = [self findMethod:func params:params searchClass:matclass];
           }
       else {
           method = [self findMethod:func params:params searchClass:imgprocclass];
           if (method == NULL) {
               method = [self findMethod:func params:params searchClass:coreclass];
           }
       }
       
       if (method == NULL) {
           [NSException raise:@"Method not found" format:@"%@ not found make sure method exists and is part of Opencv Imgproc, Core or Mat.", func];
       }
       if (numParams > 0) {
           NSArray *methodParams = [self getParameterTypes:method];
           objects = [self getObjectArr:params params:methodParams];
           
           if (numParams != objects.count) {
               [NSException raise:@"Invalid parameter" format:@"One of the parameters is invalid and %@ cannot be invoked.", func];
           }
       }
       if (method != NULL) {
           Mat matToUse;
           
           if (in != NULL && [in isEqualToString:@"rgba"]) {
               matToUse = self.rgba;
           }
           else if (in != NULL && [in isEqualToString:@"rgbat"]) {
               matToUse = self.rgba.t();
           }
           else if (in != NULL && [in isEqualToString:@"gray"]) {
               matToUse = self.gray;
           }
           else if (in != NULL && [in isEqualToString:@"grayt"]) {
               matToUse = self.rgba.t();
           }
           else if (in != NULL && [self.matParams.allKeys containsObject:in]) {
               MatWrapper2 *MW2 = (MatWrapper2*)[self.matParams valueForKey:in];
               matToUse = MW2.myMat;
           }
           
           SEL theSelector = method_getName(method);
           NSMethodSignature *methodSignature = NULL;
           Class dClass;
           
           if (out != NULL && ![out isEqualToString:@""]) {
               methodSignature = [matclass methodSignatureForSelector:theSelector];
               if (methodSignature != NULL) {
                   dClass = matclass;
               }
           }
           else {
               methodSignature = [imgprocclass methodSignatureForSelector:theSelector];
               if (methodSignature == NULL) {
                   methodSignature = [coreclass methodSignatureForSelector:theSelector];
                   if (methodSignature != NULL) {
                       dClass = coreclass;
                   }
               }
               else {
                   dClass = imgprocclass;
               }
           }
           
           if (matToUse.rows > 0 && [func isEqualToString:@"release"]) {
               // special case deleting the last Mat
               matToUse.release();
               [self.matParams removeObjectForKey:in];
           }
           else if (methodSignature != NULL) {
               NSInvocation *invoker = [NSInvocation invocationWithMethodSignature:methodSignature];
               [invoker setSelector:theSelector];
               [invoker setTarget:dClass];
               
               for (int i=0;i < objects.count;i++) {
                   id parm = [objects objectAtIndex:i];
                   [invoker setArgument:&parm atIndex:i];
               }
               [invoker invoke];
               id matParam;
               [invoker getReturnValue:&matParam];
               
               if (matParam != NULL) {
                   if ([matParam isKindOfClass:matclass]) {
                       [self.matParams setObject:matParam forKey:out];
                   }
               }
           }
       }
       
       if (self.dstMatIndex >= 0) {
           MatWrapper2 *dstMatWrapper = (MatWrapper2*)objects[self.arrMatIndex];
           Mat dstMat = dstMatWrapper.myMat;
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
