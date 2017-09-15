//
//  PHFetchResult+RITLPhotoRepresentation.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/30.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHFetchResult (RITLPhotoRepresentation)


@end

@interface PHFetchResult (RITLAsset)


/**
 获取PHFetchResult符合媒体类型的PHAsset对象
 
 @param mediaType 媒体类型
 @param matchingObjectBlock  每次获得符合媒体类型的对象调用一次
 @param enumerateObjectBlock 每次都会调用一次
 @param completeBlock 完成之后返回存放符合媒体类型的PHAsset数组
 */
- (void)preparationWithType:(PHAssetMediaType)mediaType
        matchingObjectBlock:(nullable void(^)(PHAsset *))matchingObjectBlock
       enumerateObjectBlock:(nullable void(^)(PHAsset *))enumerateObjectBlock
                   Complete:(nullable void(^)(NSArray <PHAsset *> * __nullable))completeBlock;



/**
 获取PHFetchResult符合媒体类型的PHAsset对象

 @param mediaType 媒体类型
 @param completeBlock 完成之后返回存放符合媒体类型的PHAsset数组
 */
- (void)preparationWithType:(PHAssetMediaType)mediaType
                   Complete:(void(^)(NSArray <PHAsset *> * __nullable))completeBlock;

@end



@interface PHFetchResult (RITLArray)


/**
 转成ObjectType的泛型数组

 @param arrayObject
 */
- (void)transToArrayComplete:(void(^)(NSArray <id> *, PHFetchResult *)) arrayObject;

@end

NS_ASSUME_NONNULL_END
