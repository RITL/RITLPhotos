//
//  RITLPhotoRequestStore.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 负责请求图片对象
@interface RITLPhotoRequestStore : NSObject


/**
 获取资源中的图片对象

 @param assets 需要请求的asset数组
 @param status 当前图片是否需要高清图
 @param size   当前图片的截取size
 @param isIgnoreSize 是否无视size属性，按照图片原本大小获取
 @param imagesBlock 返回图片的block
 */
+ (void)imagesWithAssets:(NSArray <PHAsset *> *)assets
                  status:(nullable BOOL *)status
                    Size:(CGSize)size
              ignoreSize:(BOOL)isIgnoreSize
                complete:(void (^)(NSArray <UIImage *> *))imagesBlock;




/// 根据资源以及状态获取资源转化后的data
//+ (void)dataWithAssets:(NSArray <PHAsset *> *)assets status:(NSArray <NSNumber *> *)status complete:(void (^)(NSArray <NSData *> *))dataBlock __deprecated_msg("Use RITLPhotoRequestStore instead. see RITLPhotoRequestStore.h");



@end

NS_ASSUME_NONNULL_END
