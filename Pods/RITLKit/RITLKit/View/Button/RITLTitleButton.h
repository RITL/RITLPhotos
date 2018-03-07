//
//  ETCustomTitleButton.h
//  XiaoNongDingClient
//
//  Created by YueWen on 2017/5/12.
//  Copyright © 2017年 ryden. All rights reserved.
//

#import "RITLButton.h"

NS_ASSUME_NONNULL_BEGIN

/// 只显示文本的button
@interface RITLTitleButton : RITLButton

/// 正常下的文本字体,默认System:14px
@property (nonatomic, strong) UIFont * normalTextFont;

/// 选中下的文本字体,默认System:16px
@property (nonatomic, strong) UIFont * selectedTextFont;

/// 正常下的文本颜色,默认(102, 102, 102)
@property (nonatomic, strong) UIColor * normalTextColor;

/// 选中下的文本颜色,默认(61, 175, 145)
@property (nonatomic, strong) UIColor * selectedTextColor;

@end

NS_ASSUME_NONNULL_END
