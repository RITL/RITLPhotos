//
//  PHImageRequestOptions+RITLPhotos.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHImageRequestOptions (RITLPhotos)

/**
 便利构造器
 @param deliverMode 模式
 @return PHImageRequestOptions对象
 */
+ (instancetype)requestOptionsWithDeliveryMode:(PHImageRequestOptionsDeliveryMode)deliverMode;

@end

NS_ASSUME_NONNULL_END
