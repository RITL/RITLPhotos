//
//  RITLPhotosNavigationViewController.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/3/7.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RITLPhotosConfiguration.h"
#import "RITLPhotosViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@class RITLPhotosViewController;

/// 主流的控制器
@interface RITLPhotosViewController : UINavigationController
/// 代理对象
@property (nonatomic, weak, nullable) id<RITLPhotosViewControllerDelegate>photo_delegate;
/// 配置参数
@property (nonatomic, strong, readonly) RITLPhotosConfiguration *configuration;
/// 图片控制器
+ (instancetype)photosViewController;


#pragma mark - 设置响应回调参数的属性
/**
 触发的属性
 默认为CGSizeZero,并不触发回调方法
 */
@property (nonatomic, assign)CGSize thumbnailSize;

#pragma mark - 记录当前选择过的图片

/// 默认选中的标志位
@property (nonatomic, copy)NSArray < NSString *> *defaultIdentifers;

@end

NS_ASSUME_NONNULL_END
