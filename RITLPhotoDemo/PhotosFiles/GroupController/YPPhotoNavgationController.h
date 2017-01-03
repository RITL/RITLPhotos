//
//  YPPhotoNavgationController.h
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/14.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

NS_CLASS_DEPRECATED_IOS(2_0, 10_0,"Use RITLPhotoNavigationViewController instead.") @interface YPPhotoNavgationController : UINavigationController

/// @brief 最多选择的图片数，默认最大为9张
@property (nonatomic, assign)NSUInteger maxNumberOfSelectImages;


/// @brief 选择图片完毕之后获得资源对象以及选项进行的回调(可以自行对资源对象进行图片对象的裁剪)
@property (nullable, nonatomic, copy) YPPhotoDidSelectedBlockAsset photosDidSelectBlock;


/// @brief 与photoImageSelectBlock搭配使用，负责控制裁剪图片的大小
@property (nonatomic, assign) CGSize imageSize;
/// @brief 选择图片完毕后直接获得图片对象的回调
@property (nullable, nonatomic, copy) YPPhotoDidSelectedBlock photoImageSelectBlock;


@end


NS_ASSUME_NONNULL_END
