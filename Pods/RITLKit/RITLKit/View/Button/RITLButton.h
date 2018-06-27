//
//  ETButton.h
//  XiaoNongDingClient
//
//  Created by YueWen on 2017/4/26.
//  Copyright © 2017年 ryden. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/**
 自定义button,类型为上图下文字
 建议使用功能更加齐全的---- RITLButtonItem
 */
@interface RITLButton : UIButton


/// 文字标签
@property (nonatomic, strong) UILabel * titleLabel;

/// 文字标签上的图片
@property (nonatomic, strong) UIImageView * imageView;

/// 圆角设置,默认为false
@property (nonatomic, assign, getter=imageViewIsCornerRadius) BOOL imageViewCornerRadius;

/// 显示在imageView的默认图片，默认为测试
@property (nonatomic, strong) UIImage * defaultImage;

/// 选中的图层视图,默认hidden
@property (nonatomic, strong) UIImageView * selectedImageView;



/// imageView的内距，默认为(0,0,0,0)
@property (nonatomic, assign) UIEdgeInsets imageViewEdgeInsets;

/// titleLabel的内距，默认为(5,0,0,0)
@property (nonatomic, assign) UIEdgeInsets titleLabelEdgeInsets;

/// 是否自动调整imageView, 默认为true, 自动调整imageView为 宽:高 = 1:1
@property (nonatomic, assign, getter=isAutoAdjustImageView) BOOL autoAdjustImageView;


#pragma mark - status



/**
 表示选中的状态
 */
- (void)didSelectedHandler;


/**
 表示未选中的状态
 */
- (void)didDisSelectedHandler;


/**
 恢复所有的默认值
 */
- (void)prepareForReuse;


@end

NS_ASSUME_NONNULL_END
