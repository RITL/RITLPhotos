//
//  YPPhotosCell.h
//  RITLPhotoDemo
//
//  Created by YueWen on 16/7/14.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RITLPhotosCell;

NS_ASSUME_NONNULL_BEGIN

@protocol RITLPhotosCellActionTarget <NSObject>

@optional

/// 上方的响应按钮被点击
- (void)photosCellDidTouchUpInSlide:(RITLPhotosCell *)cell;

@end


@interface RITLPhotosCell : UICollectionViewCell

@property (nonatomic, copy) NSString *representedAssetIdentifier;

/// 响应源
@property (nonatomic, weak, nullable)id <RITLPhotosCellActionTarget> actionTarget;

/// display backgroundImage
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

/// default hidden is true
@property (strong, nonatomic) IBOutlet UIView *messageView;

/// imageView in messageView to show the kind of asset
@property (strong, nonatomic) IBOutlet UIImageView *messageImageView;

/// label in messageVie to show the information
@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

/// 负责显示选中的按钮
@property (strong, nonatomic) UIButton * chooseButton;

/// 不能点击进行的遮罩层
@property (nonatomic, strong, readonly)UIView *shadeView;


@end


NS_ASSUME_NONNULL_END
