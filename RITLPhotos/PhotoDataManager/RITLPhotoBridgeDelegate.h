//
//  RITLPhotoBridgeDelegate.h
//  XiaoNongDingClient
//
//  Created by YueWen on 2017/9/26.
//  Copyright © 2017年 ryden. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@class PHAsset;

@protocol RITLPhotoBridgeDelegate <NSObject>

@optional

/**
 初始化时设置imageSize时，回调获得响应大小图片的方法
 如果没有设置图片大小，返回的数据与ritl_bridgeGetImage:相同

 @param images 缩略图数组
 */
- (void)ritl_bridgeGetThumImage:(NSArray <UIImage *> *)images;


/**
 获得原尺寸比例大小的图片

 @param images 原比例大小的图片
 */
- (void)ritl_bridgeGetImage:(NSArray <UIImage *>*)images;


/**
 获得所选图片的data数组

 @param datas 获得原图或者ritl_bridgeGetImage:数据的数据对象
 */
- (void)ritl_bridgeGetImageData:(NSArray <NSData *>*)datas;



/**
 获得所选图片原资源对象(PHAsset)

 @param assets 所选图片原资源对象(PHAsset)
 */
- (void)ritl_bridgeGetAsset:(NSArray <PHAsset *>*)assets;

@end

NS_ASSUME_NONNULL_END
