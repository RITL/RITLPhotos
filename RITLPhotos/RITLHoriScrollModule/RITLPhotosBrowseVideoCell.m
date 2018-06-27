//
//  RITLPhotosBrowseVideoCell.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/4/29.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "RITLPhotosBrowseVideoCell.h"
#import "UICollectionViewCell+RITLPhotosAsset.h"
#import "NSBundle+RITLPhotos.h"
#import <RITLKit/RITLKit.h>
#import <Masonry/Masonry.h>

//static NSString *const RITLPhotosBrowseVideoCellVideoImageName = @"RITLPhotos.bundle/ritl_video_play";

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
    
    self.imageView = [[UIImageView alloc]init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;

    [self.contentView addSubview:self.imageView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.offset(0);
    }];
    
    self.playImageView = ({
        
        UIImageView *imageView = [UIImageView new];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = /*RITLPhotosBrowseVideoCellVideoImageName.ritl_image*/NSBundle.ritl_video_play;
        
        imageView;
    });
    
    [self.contentView addSubview:self.playImageView];
    
    [self.playImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.width.mas_equalTo(80);
        make.center.offset(0);
    }];
    
    __weak typeof(self) weak = self;
    
    [self.contentView addTapGestureRecognizerNumberOfTap:1 Handler:^(UIView * _Nonnull view) {
        if (!weak.playerLayer) { [weak playerAsset]; return; }//如果是stop，就进行播放
        [weak stop];
    }];

}



- (void)prepareForReuse
{
    if (self.playerLayer.superlayer) {
        
        [self.playerLayer removeFromSuperlayer];
        self.playerLayer = nil;
    }
}

@end
