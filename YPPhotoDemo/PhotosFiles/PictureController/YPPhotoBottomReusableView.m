//
//  YPPhotoBottomReusableView.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/14.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "YPPhotoBottomReusableView.h"

@implementation YPPhotoBottomReusableView

-(void)prepareForReuse
{
    _numberOfAsset = 375;
    _customText = @"";
    _assetCountLabel.text = @"共有375张照片";
}


-(void)setCustomText:(NSString *)customText
{
    _customText = customText;
    _assetCountLabel.text = customText;
}

-(void)setNumberOfAsset:(NSUInteger)numberOfAsset
{
    _numberOfAsset = numberOfAsset;
    _assetCountLabel.text = [NSString stringWithFormat:@"共有%@张照片",@(numberOfAsset)];
}


@end
