//
//  XNDCustomSearchTextField.h
//  XiaoNongDingClient
//
//  Created by YueWen on 2017/10/13.
//  Copyright © 2017年 ryden. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RITLSearchTextField : UITextField

/// 左侧搜索图标距离左边距 默认为0
@property (nonatomic, assign) CGFloat searchIconLeftMargin;
/// 文本域距离左侧搜索框或者左边距，默认为0
@property (nonatomic, assign) CGFloat textLeftMargin;
/// 占位符距离距离左侧搜索框或者左边距，默认为0
@property (nonatomic, assign) CGFloat placeholderLeftMargin;

@end

NS_ASSUME_NONNULL_END
