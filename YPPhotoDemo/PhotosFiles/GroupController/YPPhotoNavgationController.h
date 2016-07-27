//
//  YPPhotoNavgationController.h
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/14.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPPhotoDefines.h"

NS_ASSUME_NONNULL_BEGIN


NS_CLASS_AVAILABLE_IOS(8_0) @interface YPPhotoNavgationController : UINavigationController

/// @brief 最多选择的图片数，默认最大为9张
@property (nonatomic, assign)NSUInteger maxNumberOfSelectImages;

/// @brief 选择图片完毕之后进行的回调
@property (nullable, nonatomic, copy) YPPhotoDidSelectedBlockAsset photosDidSelectBlock;


@end


NS_ASSUME_NONNULL_END
