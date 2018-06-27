//
//  PHAssetCollection+RITLPhotos.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHAssetCollection (RITLPhotos)


/// 获取PHAssetCollection的详细信息
- (void)ritl_headerImageWithSize:(CGSize)size
                            mode:(PHImageRequestOptionsDeliveryMode)mode
                        complete:(void (^)(NSString * title,NSUInteger count,UIImage * __nullable image)) completeBlock;


/**
 获取PHAssetCollection的详细信息

 @param size 获得封面图片的大小
 @param completeBlock 取组的标题、照片资源的预估个数以及封面照片,默认为最新的一张
 */
- (void)ritl_headerImageWithSize:(CGSize)size
                        complete:(void (^)(NSString * title,NSUInteger count,UIImage * __nullable image)) completeBlock;


@end

NS_ASSUME_NONNULL_END
