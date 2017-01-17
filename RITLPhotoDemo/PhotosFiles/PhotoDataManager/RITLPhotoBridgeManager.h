//
//  RITLPhotoBridgeManager.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 进行桥接进行回调的Manager
@interface RITLPhotoBridgeManager : NSObject

/// 获取图片之后的回调
@property (nonatomic, copy, nullable)void(^RITLBridgeGetImageBlock)(NSArray <UIImage *> *);

/// 获取图片的data
@property (nonatomic, copy, nullable)void(^RITLBridgeGetImageDataBlock)(NSArray <NSData *> *);

/// 单例对象
+ (instancetype)sharedInstance;

/// 开始获取图片，触发RITLBridgeGetImageBlock
- (void)startRenderImage:(NSArray <PHAsset *> *)assets;

@end

NS_ASSUME_NONNULL_END
