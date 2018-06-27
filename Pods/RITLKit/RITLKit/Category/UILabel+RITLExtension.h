//
//  UILabel+RITLExtension.h
//  RITLKitDemo
//
//  Created by YueWen on 2017/12/22.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 标签的扩展
@interface UILabel (RITLExtension)

/// 当前文本计算的渲染域
@property (nonatomic, assign, readonly)CGSize ritl_contentSize;
/// 当前文本计算的高度
@property (nonatomic, assign, readonly)CGFloat ritl_contentHeight;
/// 当前文本计算的宽度
@property (nonatomic, assign, readonly)CGFloat ritl_contentWidth;

@end

NS_ASSUME_NONNULL_END
