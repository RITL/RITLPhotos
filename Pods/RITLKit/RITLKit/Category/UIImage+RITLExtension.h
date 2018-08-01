//
//  UIImage+RITLGIFHandler.h
//  XiaoNongDingClient
//
//  Created by YueWen on 2017/7/17.
//  Copyright © 2017年 ryden. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIImage (RITLScale)

/// 分辨率进行缩放
- (NSData *)ritl_imageScaleWithSize:(CGSize)size;

@end




@interface UIImage (RITLRenderOrigin)

/// UIImageRenderingModeAlwaysOriginal
@property (nonatomic, strong, readonly)UIImage *ritl_renderOriginImage;

@end


@interface UIImage (RITLSize)

/// 以KB为单位的大小
@property (nonatomic, assign, readonly)CGFloat ritl_sizeWithKB;
/// 大小是否大于`size`(KB)
- (BOOL)ritl_sizeIsGetterThan:(CGFloat)size;
/// 获得压缩为最大大小为size的data
- (NSData *)ritl_imageDataWithMaxSize:(CGFloat)size;
/// 获得压缩为最大大小为size的图片
- (UIImage *)ritl_imageWithMaxSize:(CGFloat)size;

@end


NS_ASSUME_NONNULL_END
