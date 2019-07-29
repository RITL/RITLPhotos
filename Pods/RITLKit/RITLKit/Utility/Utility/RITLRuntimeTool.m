//
//  RITLRuntimeTool.m
//  EattaClient
//
//  Created by YueWen on 2017/9/14.
//  Copyright © 2017年 ryden. All rights reserved.
//

#import "RITLRuntimeTool.h"
#import <objc/runtime.h>


void RITL_swizzledInstanceSelector(Class classObject,SEL originSel,SEL swizzledSel)
{
    Method originMethod = class_getInstanceMethod(classObject, originSel);
    Method swizzledMethod = class_getInstanceMethod(classObject, swizzledSel);
    
    
    BOOL didAddMethod = class_addMethod(classObject, originSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    
    if (didAddMethod) {//追加成功，进行替换
        
        class_replaceMethod(classObject,
                            originSel,
                            method_getImplementation(swizzledMethod),
                            method_getTypeEncoding(swizzledMethod));
    }else {
        
        method_exchangeImplementations(originMethod, swizzledMethod);
    }
}





void RITL_swizzledClassSelector(Class classObject,SEL originSel,SEL swizzledSel)
{
    Method originMethod = class_getClassMethod(classObject, originSel);
    Method swizzledMethod = class_getClassMethod(classObject, swizzledSel);
    
    
    BOOL didAddMethod = class_addMethod(classObject, originSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    
    if (didAddMethod) {//追加成功，进行替换
        
        class_replaceMethod(classObject,
                            originSel,
                            method_getImplementation(swizzledMethod),
                            method_getTypeEncoding(swizzledMethod));
    }else {
        
        method_exchangeImplementations(originMethod, swizzledMethod);
    }
}


@implementation NSObject (RITLSwizzled)

+ (void)ritl_swizzledInstanceSelector:(SEL)originSel swizzled:(SEL)sel
{
    RITL_swizzledInstanceSelector(self.class, originSel, sel);
}


+ (void)ritl_swizzledClassSelector:(SEL)originSel swizzled:(SEL)sel
{
    RITL_swizzledClassSelector(self.class, originSel, sel);
}

@end


