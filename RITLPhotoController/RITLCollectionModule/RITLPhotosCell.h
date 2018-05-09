//
//  YPPhotosCell.h
//  RITLPhotoDemo
//
//  Created by YueWen on 16/7/14.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHAsset;
@class RITLPhotosCell;

NS_ASSUME_NONNULL_BEGIN

@protocol RITLPhotosCellActionTarget <NSObject>

@optional

/// 上方的响应按钮被点击
- (void)photosCellDidTouchUpInSlide:(RITLPhotosCell *)cell asset:(PHAsset *)asset indexPath:(NSIndexPath *)indexPath;

@end


@interface RITLPhotosCell : UICollectionViewCell

/// 避免重复赋值
@property (nonatomic, copy) NSString *representedAssetIdentifier;
/// 响应源
@property (nonatomic, weak, nullable)id <RITLPhotosCellActionTarget> actionTarget;
/// 显示照片的视图
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
/// 展示视频出现的信息搭载视图，默认为隐藏
@property (strong, nonatomic) IBOutlet UIView *messageView;
/// 显示索引的标签
@property (strong, nonatomic) IBOutlet UILabel *indexLabel;
/// 展示视频时的录像小图标
@property (strong, nonatomic) IBOutlet UIImageView *messageImageView;
/// 展示视频时长的小标签
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
/// 支持iOS9.1之后的livePhoto
@property (nonatomic, strong) UIImageView *liveBadgeImageView;


/// 负责显示选中的按钮
@property (strong, nonatomic) UIButton *chooseButton;
/// 不能点击进行的遮罩层
@property (nonatomic, strong, readonly)UIView *shadeView;


@property (nonatomic, weak, nullable) PHAsset *asset;
@property (nonatomic, strong, nullable) NSIndexPath *indexPath;

@end


NS_ASSUME_NONNULL_END
