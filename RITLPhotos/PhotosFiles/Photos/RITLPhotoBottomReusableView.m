//
//  YPPhotoBottomReusableView.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/14.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "RITLPhotoBottomReusableView.h"

@implementation RITLPhotoBottomReusableView

-(void)dealloc
{
#ifdef RITLDebug
    NSLog(@"YPPhotoBottomReusableView Dealloc");
#endif
}

-(void)prepareForReuse
{
    _numberOfAsset = 375;
    _customText = @"";
    _assetCountLabel.text = @"共有375张照片";
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self photoBottomReusableViewWillLoad];
    }
    
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self photoBottomReusableViewWillLoad];
}

- (void)photoBottomReusableViewWillLoad
{
    [self addSubAssetCountLabel];
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

- (void)addSubAssetCountLabel
{
    __weak typeof(self) weakSelf = self;
    
    _assetCountLabel = [[UILabel alloc]init];
    
    [self addSubview:_assetCountLabel];
    
    [_assetCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(weakSelf);
        
    }];
    
    _assetCountLabel.font = [UIFont systemFontOfSize:14];
    _assetCountLabel.textAlignment = NSTextAlignmentCenter;
    _assetCountLabel.textColor = UIColorFromRGB(0x6F7179);
}


@end
