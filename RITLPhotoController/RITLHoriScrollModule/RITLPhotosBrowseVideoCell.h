//
//  RITLPhotosBrowseVideoCell.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/4/29.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 用于播放视频的cell
@interface RITLPhotosBrowseVideoCell : UICollectionViewCell

/// 显示图片的imageView
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
/// 显示播放的视图
@property (nonatomic, strong) UIImageView *playImageView;
/// 播放的layer
@property (nonatomic, strong, nullable) AVPlayerLayer *playerLayer;

@end

NS_ASSUME_NONNULL_END
