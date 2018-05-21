//
//  UICollectionViewCell+RITLPhotosAsset.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/5/9.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

extern NSNotificationName RITLHorBrowseTooBarChangedHiddenStateNotification;

@interface UICollectionViewCell (RITLPhotosAsset)

/// 标志位，避免重复赋值
@property (nonatomic, copy) NSString *representedAssetIdentifier;
/// 当前展示的资源
@property (nonatomic, weak, nullable)PHAsset *currentAsset;

/// 更新数据
- (void)updateAssets:(PHAsset *)asset atIndexPath:(NSIndexPath *)indexPath imageManager:(PHCachingImageManager *)cacheManager;

/// 播放数据，仅适用于live或者video
- (void)playerAsset;
- (void)stop;

/// 用于普通图片，恢复缩放
- (void)reset;

@end

NS_ASSUME_NONNULL_END
