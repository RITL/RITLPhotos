//
//  YPPhotoPreviewController.h
//  YPPhotoDemo
//
//  Created by YueWen on 16/8/5.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// @brief 响应3D Touch出现的控制器
@interface RITLPhotoPreviewController : UIViewController

/// 资源大小
@property (nonatomic, readonly, assign) CGSize assetSize;

/// 当前显示的Image
@property (nonatomic, readonly, strong) PHAsset * showAsset;

/// 便利初始化方法
-(instancetype)initWithShowAsset:(PHAsset *)showAsset;

/// 便利构造器
+(instancetype)previewWithShowAsset:(PHAsset *)showAsset;

@end

NS_ASSUME_NONNULL_END
