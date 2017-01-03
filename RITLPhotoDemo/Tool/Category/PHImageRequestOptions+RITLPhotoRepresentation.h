//
//  PHImageRequestOptions+RITLPhotoRepresentation.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHImageRequestOptions (RITLPhotoRepresentation)

/**
 便利构造器

 @param deliverMode 当前的类型
 @return
 */
+ (instancetype)imageRequestOptionsWithDeliveryMode:(PHImageRequestOptionsDeliveryMode)deliverMode;

@end

NS_ASSUME_NONNULL_END
