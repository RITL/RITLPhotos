//
//  UICollectionViewCell+RITLPhotosAsset.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/5/9.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "UICollectionViewCell+RITLPhotosAsset.h"
#import "RITLPhotosBrowseImageCell.h"
#import "RITLPhotosBrowseLiveCell.h"
#import "RITLPhotosBrowseVideoCell.h"
#import <PhotosUI/PhotosUI.h>
#import <Masonry/Masonry.h>
#import <objc/runtime.h>
#import <RITLKit/RITLKit.h>

NSNotificationName RITLHorBrowseTooBarChangedHiddenStateNotification = @"RITLHorBrowseTooBarChangedHiddenStateNSNotification";

@implementation UICollectionViewCell (RITLPhotosAsset)

- (NSString *)representedAssetIdentifier
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setRepresentedAssetIdentifier:(NSString *)representedAssetIdentifier
{
    objc_setAssociatedObject(self, @selector(representedAssetIdentifier), representedAssetIdentifier, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (PHAsset *)currentAsset
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setCurrentAsset:(PHAsset *)currentAsset
{
    objc_setAssociatedObject(self, @selector(currentAsset), currentAsset, OBJC_ASSOCIATION_ASSIGN);
}

/// 默认不做任何事情
- (void)updateAssets:(PHAsset *)asset
         atIndexPath:(nonnull NSIndexPath *)indexPath
        imageManager:(PHCachingImageManager *)cacheManager
{
    self.representedAssetIdentifier = asset.localIdentifier;
    self.currentAsset = asset;
    
    PHImageRequestOptions *options = PHImageRequestOptions.new;
    options.networkAccessAllowed = true;
    
    [cacheManager requestImageForAsset:asset targetSize:@[@(asset.pixelWidth),@(asset.pixelHeight)].ritl_size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {

        //如果标志位一样
        if ([self.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {//进行赋值操作
            
            [self updateViews:result info:info];
        }
    }];
}

- (void)playerAsset { }
- (void)stop { }
- (void)reset {}
- (void)updateViews:(UIImage *)image info:(NSDictionary *)info { }

@end

@implementation RITLPhotosBrowseImageCell (RITLPhotosAsset)

- (void)updateViews:(UIImage *)image info:(NSDictionary *)info
{
    //适配长图
    self.imageView.image = image;
    
    //对缩放进行适配
    CGFloat height = self.currentAsset.pixelHeight / 2;
    CGFloat width = self.currentAsset.pixelWidth / 2;
    CGFloat max = MAX(width, height);
    CGFloat scale = 2.0;
    if (height > width) {
        scale = max / MAX(1,self.imageView.bounds.size.height);
    }else {
        scale = max / MAX(1,self.imageView.bounds.size.width);
    }
    self.bottomScrollView.maximumZoomScale = MAX(2.0,scale);
}


- (void)reset {
    self.bottomScrollView.maximumZoomScale = 2.0;
    [self.bottomScrollView setZoomScale:1.0];
}

@end


@implementation RITLPhotosBrowseLiveCell (RITLPhotosAsset)

- (void)updateViews:(UIImage *)image info:(NSDictionary *)info
{
    self.imageView.image = image;
    
    //设置
    [self.livePhotoView mas_remakeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(self.imageView);
        make.width.equalTo(self.imageView);
        make.height.mas_equalTo(RITL_SCREEN_WIDTH * self.currentAsset.pixelHeight / self.currentAsset.pixelWidth);
    }];
}

- (void)playerAsset
{
    if (!self.currentAsset || self.currentAsset.mediaSubtypes != PHAssetMediaSubtypePhotoLive) {  return; }

    [self layoutIfNeeded];//重新布局
    
    //请求播放
    PHLivePhotoRequestOptions *options = PHLivePhotoRequestOptions.new;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.networkAccessAllowed = true;

    [PHImageManager.defaultManager requestLivePhotoForAsset:self.currentAsset targetSize:@[@(self.currentAsset.pixelWidth),@(self.currentAsset.pixelHeight)].ritl_size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(PHLivePhoto * _Nullable livePhoto, NSDictionary * _Nullable info) {

        if (!livePhoto) { return; }

        self.livePhotoView.livePhoto = livePhoto;

        if (!self.isPlaying) {
            [self.livePhotoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleHint];
        }
    }];
}

- (void)stop
{
    if (self.isPlaying) {
        [self.livePhotoView stopPlayback];
    }
}


@end

@implementation RITLPhotosBrowseVideoCell (RITLPhotosAsset)

- (void)updateViews:(UIImage *)image info:(NSDictionary *)info
{
    self.imageView.image = image;
}

- (void)playerAsset
{
    if (!self.currentAsset || self.currentAsset.mediaType != PHAssetMediaTypeVideo) {  return; }
    
    if (self.playerLayer && self.playerLayer.player) {//直接播放即可
        
        //进行对比
        [self.playerLayer.player play]; return;
    }
    
    PHVideoRequestOptions *options = PHVideoRequestOptions.new;
    options.networkAccessAllowed = true;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    
    //开始请求
    [PHImageManager.defaultManager requestPlayerItemForVideo:self.currentAsset options:options resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        
        if (!playerItem) { return; }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
           
            AVPlayer *player = [[AVPlayer alloc]initWithPlayerItem:playerItem];
            self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
            
            //Notication
            [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(stop) name:AVPlayerItemDidPlayToEndTimeNotification object:player.currentItem];
            
            //config
            self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
            self.playerLayer.frame = self.imageView.layer.bounds;
            self.playImageView.hidden = true;
            [self.imageView.layer addSublayer:self.playerLayer];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:RITLHorBrowseTooBarChangedHiddenStateNotification object:self userInfo:@{@"hidden":@(true)}];
            [player play];//播放
        });
    }];
}



- (void)stop
{
    if (self.playerLayer && self.playerLayer.player) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:RITLHorBrowseTooBarChangedHiddenStateNotification object:nil userInfo:@{@"hidden":@(false)}];
        [self.playerLayer.player pause];;
        [self.playerLayer removeFromSuperlayer];//移除
        [NSNotificationCenter.defaultCenter removeObserver:self];
        
        self.playImageView.hidden = false;
        self.playerLayer = nil;
    }
}

@end
