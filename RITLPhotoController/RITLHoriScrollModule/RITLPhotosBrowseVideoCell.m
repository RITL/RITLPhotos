//
//  RITLPhotosBrowseVideoCell.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/4/29.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "RITLPhotosBrowseVideoCell.h"
#import <RITLKit.h>
#import <Masonry.h>

@implementation RITLPhotosBrowseVideoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self buildViews];
    }
    
    return self;
}


- (void)buildViews
{
    self.contentView.backgroundColor = UIColor.blackColor;
    
    self.playImageView = ({
        
        UIImageView *imageView = [UIImageView new];
        imageView.backgroundColor = UIColor.whiteColor;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = @"ritl_video_play".ritl_image;
        
        imageView;
    });
    
    [self.contentView addSubview:self.playImageView];
    
    [self.playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.width.mas_equalTo(80);
        make.center.offset(0);
    }];
    
}

@end
