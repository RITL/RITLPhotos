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

typedef void(^RITLPhotosCellOperationBlock)(RITLPhotosCell * __nullable cell);

@interface RITLPhotosCell : UICollectionViewCell

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
/// control对象点击的回调
@property (nullable, copy, nonatomic)RITLPhotosCellOperationBlock chooseImageDidSelectBlock;

@end


NS_ASSUME_NONNULL_END
