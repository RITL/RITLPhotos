//
//  PHAsset+RITLPhotoRepresentation.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHAsset (RITLPhotoRepresentation)


/**
 获取PHAsset的照片资源

 @param size 获取图片的大小
 @param completeBlock
 */
- (void)representationImageWithSize:(CGSize)size
                           complete:(void (^)(UIImage * __nullable,PHAsset *))completeBlock;



/**
 获取PHAsset的高清图片资源

 @param size 获取图片的大小
 @param completeBlock
 */
- (void)sizeOfHignQualityWithSize:(CGSize)size complete:(void(^)(NSString * imageSize))completeBlock;


@end

NS_ASSUME_NONNULL_END
