//
//  RITLPhotoNavigationViewModel.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/11/29.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "RITLPhotoBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 图片的原始大小
extern CGSize const RITLPhotoOriginSize;

/// 主导航控制器的viewModel
NS_CLASS_AVAILABLE_IOS(8_0) @interface RITLPhotoNavigationViewModel : RITLPhotoBaseViewModel

/// 最大允许选择的图片数目，默认为9
@property (nonatomic, assign) NSUInteger maxNumberOfSelectedPhoto;

/// 图片的大小，默认为RITLPhotoOriginSize
@property (nonatomic, assign) CGSize imageSize;

/// 获取图片之后的回调
@property (nonatomic, copy, nullable)void(^RITLBridgeGetImageBlock)(NSArray <UIImage *> *);

/// 获取图片的data
@property (nonatomic, copy, nullable)void(^RITLBridgeGetImageDataBlock)(NSArray <NSData *> *);

@end

NS_ASSUME_NONNULL_END
