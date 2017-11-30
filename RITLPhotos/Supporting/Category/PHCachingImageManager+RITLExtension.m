//
//  PHCachingImageManager+RITLExtension.m
//  XiaoNongDingClient
//
//  Created by YueWen on 2017/10/12.
//  Copyright © 2017年 ryden. All rights reserved.
//

#import "PHCachingImageManager+RITLExtension.h"

@implementation PHCachingImageManager (RITLExtension)

+ (instancetype)defaultManager
{
    static PHCachingImageManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [PHCachingImageManager new];
    });
    
    return manager;
}

@end
