//
//  RITLPhotosBrowseLiveCell.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/5/9.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHLivePhotoView;

NS_ASSUME_NONNULL_BEGIN

/// 装载live图片的cell
NS_CLASS_AVAILABLE_IOS(9_1) @interface RITLPhotosBrowseLiveCell : UICollectionViewCell

/// 显示图片的imageView
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
/// 支持iOS9.1之后的livePhoto
@property (nonatomic, strong) UIImageView *liveBadgeImageView;
/// 用于描述
@property (nonatomic, strong) UILabel *liveLabel;
/// 用于播放的视图
@property (nonatomic, strong) PHLivePhotoView *livePhotoView;
/// 是否播放
@property (nonatomic, assign) BOOL isPlaying;

@end

NS_ASSUME_NONNULL_END
