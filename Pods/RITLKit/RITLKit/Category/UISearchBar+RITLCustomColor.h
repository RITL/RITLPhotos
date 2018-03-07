//
//  UISearchBar+RITLCustomColor.h
//  CityBao
//
//  Created by YueWen on 16/4/29.
//  Copyright © 2016年 wangpj. All rights reserved.
//  自定义UISearchBar相关属性

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UISearchBar (RITLCustomColor)


/**
 设置背景颜色

 @param color searchBar背景颜色
 */
- (void)ritl_setBackgroupColor:(UIColor *)color;

/**
 设置光标的颜色

 @param color 光标颜色
 */
- (void)ritl_setTextFieldCursorColor:(UIColor *)color;

/**
 设置文本域背景的颜色

 @param color  文本域的背景颜色
 */
- (void)ritl_setTextFieldBackGroudColor:(UIColor *)color;

/**
 设置文本域的圆角

 @param cornerRadius 圆角
 */
- (void)ritl_setTextFieldCornerRadius:(CGFloat)cornerRadius;

/**
 修改占位符的字体颜色

 @param color 占位符的字体颜色
 */
- (void)ritl_setTextFieldPlaceHolderColor:(UIColor *)color;

/**
 设置占位符的字体大小

 @param font 占位符的字体大小
 */
- (void)ritl_setPlaceHolderFont:(UIFont *)font;

/**
 设置搜索中的字体

 //需要在searchBar: textDidChange:回调中使用
 
 @param font 设置的字体
 */
- (void)ritl_setSearchFont:(UIFont *)font;

/**
 用于解决iOS11下 高度小于36 圆角剪切的问题

 @param size 新的大小，默认值操作height
 */
//- (void)ritl_setSearchFieldBackgroundChangedSize:(CGSize)size NS_AVAILABLE_IOS(11.0);

@end

NS_ASSUME_NONNULL_END


