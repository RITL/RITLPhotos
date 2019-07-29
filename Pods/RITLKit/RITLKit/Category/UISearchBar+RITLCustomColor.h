//
//  UISearchBar+RITLCustomColor.h
//  CityBao
//
//  Created by YueWen on 16/4/29.
//  Copyright © 2016年 wangpj. All rights reserved.
//  自定义UISearchBar相关属性

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (RITLCustomColor)

/// 修改占位符的字体颜色
- (void)ritl_setPlaceholderColor:(UIColor *)color;
/// 设置占位符的字体大小
- (void)ritl_setPlaceholderFont:(UIFont *)font;

@end

@interface UISearchBar (RITLCustomColor)

/// 设置背景颜色
- (void)ritl_setBackgroupColor:(UIColor *)color;
/// 设置光标的颜色
- (void)ritl_setTextFieldCursorColor:(UIColor *)color;
/// 设置文本域背景的颜色
- (void)ritl_setTextFieldBackGroudColor:(UIColor *)color;
/// 设置文本域的圆角
- (void)ritl_setTextFieldCornerRadius:(CGFloat)cornerRadius;
/// 修改占位符的字体颜色
- (void)ritl_setTextFieldPlaceHolderColor:(UIColor *)color;
/// 设置占位符的字体大小
- (void)ritl_setPlaceHolderFont:(UIFont *)font;
/// 设置搜索中的字体
- (void)ritl_setSearchFont:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END


