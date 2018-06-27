//
//  NSObject+RITLMutable.m
//  NongWanCloud
//
//  Created by YueWen on 2018/1/3.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "NSObject+RITLMutable.h"

@implementation NSObject (RITLMutable)

- (instancetype)ritl_mutable:(RITLMutableHandler)handler
{
    return handler(self);
}

@end


@implementation UIView (RITLMutable)

- (instancetype)ritl_mutable:(RITLViewMutableHandler)handler
{
    return handler(self);
}

@end


@implementation UIViewController (RITLMutable)

- (instancetype)ritl_mutable:(RITLControllerMutableHandler)handler
{
    return handler(self);

}

@end
