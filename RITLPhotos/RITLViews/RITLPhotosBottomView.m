//
//  RITLPhotosBottomView.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/3/9.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "RITLPhotosBottomView.h"
#import "NSBundle+RITLPhotos.h"
#import <RITLKit/RITLKit.h>
#import <Masonry/Masonry.h>

@implementation RITLPhotosBottomView

 -(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self buildViews];
    }
    return self;
}


- (void)buildViews
{
    self.contentView = ({
        
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.clearColor;

        view;
    });
    
    self.previewButton = ({
        
        UIButton *view = [UIButton new];
        view.adjustsImageWhenHighlighted = false;
        view.backgroundColor = [UIColor clearColor];
        view.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [view setTitle:NSLocalizedString(@"预览", @"") forState:UIControlStateNormal];
        [view setTitle:NSLocalizedString(@"预览", @"") forState:UIControlStateDisabled];
        
        [view setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [view setTitleColor:RITLColorFromIntRBG(105, 109, 113) forState:UIControlStateDisabled];
        
        view;
    });
    
    self.fullImageButton = ({
        
        UIButton *view = [UIButton new];

        view.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 40);
        view.titleEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
        
        [view setImage:/*@"RITLPhotos.bundle/ritl_bottomUnselected".ritl_image*/NSBundle.ritl_bottomUnselected forState:UIControlStateNormal];
        [view setImage:/*@"RITLPhotos.bundle/ritl_bottomSelected".ritl_image*/NSBundle.ritl_bottomSelected forState:UIControlStateSelected];
        
        view.titleLabel.font = [UIFont systemFontOfSize:14];
        [view setTitle:NSLocalizedString(@"原图", @"") forState:UIControlStateNormal];
        [view setTitle:NSLocalizedString(@"原图", @"") forState:UIControlStateSelected];
        
        [view setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        
        view;
    });
    
    self.sendButton = ({
        
        UIButton *view = [UIButton new];
        view.adjustsImageWhenHighlighted = false;
        
        view.titleLabel.font = RITLUtilityFont(RITLFontPingFangSC_Regular, 13);
        
        [view setTitle:NSLocalizedString(@"发送", @"") forState:UIControlStateNormal];
        [view setTitle:NSLocalizedString(@"发送", @"") forState:UIControlStateDisabled];
        
        [view setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [view setTitleColor:RITLColorFromIntRBG(92, 134, 90) forState:UIControlStateDisabled];
        
        [view setBackgroundImage:RITLColorFromIntRBG(9, 187, 7).ritl_image forState:UIControlStateNormal];
        [view setBackgroundImage:RITLColorFromIntRBG(23, 83, 23).ritl_image forState:UIControlStateDisabled];
        
        view.layer.cornerRadius = 5;
        view.clipsToBounds = true;
        
        view;
    });
    
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.previewButton];
    [self.contentView addSubview:self.fullImageButton];
    [self.contentView addSubview:self.sendButton];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.left.right.offset(0);
        make.height.mas_equalTo(RITL_NormalTabBarHeight - 5);
        
    }];
    
    [self.previewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.offset(0);
        make.left.offset(10);
        make.width.mas_equalTo(40);
    }];
    
    [self.fullImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.offset(0);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(60);
    }];
    
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.offset(0);
        make.right.inset(10);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(30);
    }];
}

@end
