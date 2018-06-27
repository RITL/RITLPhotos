//
//  PHAsset+RITLPhotos.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHAsset (RITLPhotos)

// 存在内存风险，暂时不建议使用

/**
 获取PHAsset的照片资源

 @param size 获取图片的大小
 @param completeBlock
 */
//- (void)ritl_imageWithSize:(CGSize)size
//                  complete:(void (^)(UIImage * __nullable image,PHAsset * asset,NSDictionary *info))completeBlock;

/**
 
 获取PHAsset的高清图片的数据大小

 @param completeBlock
 */
//- (void)ritl_hignQualityDataSizeComplete:(void(^)(NSString *imageSize))completeBlock;



/**
 获取PHAsset快速资源

 @param size 获取图片的大小
 @param completeBlock 
 */
//- (void)ritl_fastFormatImageWithSize:(CGSize)size
//                            complete:(void(^)(UIImage * __nullable image,PHAsset * asset,NSDictionary *info))completeBlock;

@end


@interface PHAsset (RITLBrowse)

/// 类型
@property (nonatomic, copy, readonly) NSString *ritl_type;

@end

NS_ASSUME_NONNULL_END
