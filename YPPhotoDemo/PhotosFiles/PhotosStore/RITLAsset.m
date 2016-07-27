//
//  RITLAsset.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/22.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLAsset.h"

@implementation RITLAsset

-(instancetype)initWithAsset:(PHAsset *)asset OptionMode:(RITLOptionMode)optionMode
{
    if (self = [super init])
    {
        self.asset = asset;
        self.optionMode = optionMode;
    }
    return self;
}



+(instancetype)RITLAssetWithAsset:(PHAsset *)asset OptionMode:(RITLOptionMode)optionMode
{
    return [[self alloc]initWithAsset:asset OptionMode:optionMode];
}


@end
