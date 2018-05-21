//
//  RITLPhotosBrowseLiveCell.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/5/9.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "RITLPhotosBrowseLiveCell.h"
#import "UICollectionViewCell+RITLPhotosAsset.h"
#import <RITLKit/RITLKit.h>
#import <PhotosUI/PhotosUI.h>
#import <Masonry/Masonry.h>

@interface RITLPhotosBrowseLiveCell() <PHLivePhotoViewDelegate>

/// 是否是按压唤醒
@property (nonatomic, assign)BOOL isForce;
@property (nonatomic, strong)UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation RITLPhotosBrowseLiveCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self buildViews];
    }
    return self;
}


- (void)prepareForReuse
{
    [self stop];
}


- (void)buildViews
{
    self.isPlaying = false;
    self.imageView = [[UIImageView alloc]init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.contentView addSubview:self.imageView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.offset(0);
    }];
    
    self.liveBadgeImageView = ({
        
        UIImageView *imageView = [UIImageView new];
        imageView.backgroundColor = UIColor.clearColor;
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.image = [PHLivePhotoView livePhotoBadgeImageWithOptions:PHLivePhotoBadgeOptionsOverContent];
        
        imageView;
    });
    
    [self.contentView addSubview:self.liveBadgeImageView];
    
    [self.liveBadgeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.width.mas_equalTo(25);
        make.left.offset(10);
        make.top.offset(RITL_DefaultNaviBarHeight + 18);
    }];
    
    self.liveLabel = ({
        
        UILabel *label = [UILabel new];
        label.text = @"Live";
        label.font = RITLUtilityFont(RITLFontPingFangSC_Regular, 14);
        label.textColor = UIColor.whiteColor;
        
        label;
    });
    
    [self.contentView addSubview:self.liveLabel];
    
    [self.liveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self.liveBadgeImageView);
        make.left.equalTo(self.liveBadgeImageView.mas_right).offset(3);
    }];
    
    self.livePhotoView = ({
        
        PHLivePhotoView *view = [PHLivePhotoView new];
        view.hidden = true;
        view.delegate = self;
        view.userInteractionEnabled = false;
        
        view;
    });
    
    [self.contentView addSubview:self.livePhotoView];
    
    [self.livePhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(self.imageView);
    }];
    
    __weak typeof(self) weak = self;
    
    //追加点击时间
    self.tapGestureRecognizer = [self.contentView addTapGestureRecognizerNumberOfTap:1 Handler:^(UIView * _Nonnull view) {
        if (weak.isPlaying) { [weak stop]; return; }
        
        else if (!weak.isPlaying && weak.livePhotoView.hidden) {//处理0.2秒的延迟
            [weak playerAsset];
        }
    }];

}


#pragma mark - <PHLivePhotoViewDelegate>

- (void)livePhotoView:(PHLivePhotoView *)livePhotoView willBeginPlaybackWithStyle:(PHLivePhotoViewPlaybackStyle)playbackStyle
{
    self.isPlaying = true;
    self.livePhotoView.hidden = false;
}

- (void)livePhotoView:(PHLivePhotoView *)livePhotoView didEndPlaybackWithStyle:(PHLivePhotoViewPlaybackStyle)playbackStyle
{
    self.isPlaying = false;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.livePhotoView.hidden = true;
    });
}



@end
