//
//  NSObject+RITLExtension.m
//  EattaClient
//
//  Created by YueWen on 2017/7/11.
//  Copyright © 2017年 ryden. All rights reserved.
//

#import "NSObject+RITLExtension.h"

@implementation NSObject (RITLExtension)


+ (instancetype)ritl_object:(void (^)(__kindof id _Nonnull))initialHandler
{
    id object = [self new];
    
    initialHandler(object);
    
    return object;
}

@end
