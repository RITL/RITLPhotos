//
//  UIButton+RITLBlockButton.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (RITLBlockButton)


/**
 用来替代目标动作回调的方法

 @param controlEvents 响应事件
 @param eventHandleBlock 处理事件的block
 */
- (void)controlEvents:(UIControlEvents)controlEvents handle:(void(^)(UIButton *)) eventHandleBlock;


@end

NS_ASSUME_NONNULL_END
