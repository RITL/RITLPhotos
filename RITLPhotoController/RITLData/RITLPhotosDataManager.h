//
//  RITLPhotosDataManager.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/5/16.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PHAsset;

NS_ASSUME_NONNULL_BEGIN

/// 数据处理者
@interface RITLPhotosDataManager : NSObject

/// 资源的标志位
@property (nonatomic, copy, readonly) NSArray <NSString *> *assetIdentiers;
@property (nonatomic, copy, readonly) NSArray <PHAsset *> *assets;
/// 可以用于KVO进行观察个数：NSKeyValueObservingOptionNew
@property (nonatomic, assign, readonly) NSInteger count;

/// 可自动销毁的单例对象
+ (instancetype)sharedInstance;

/// action
- (void)addPHAsset:(PHAsset *)asset;
- (void)removePHAsset:(PHAsset *)asset;
- (void)removePHAssetAtIndex:(NSUInteger)index;
- (void)exchangePHAssetAtIndex:(NSUInteger)idx1 withPHAssetAtIndex:(NSUInteger)idx2;
- (void)removeAllPHAssets;


/**
 * 进行自动添加或者删除的操作
 * 如果不存在该资源，追加，并返回当前所在的个数(索引+1)
 * 如果存在该资源，删除，并返回-1
 */
- (nullable NSNumber *)addOrRemoveAsset:(PHAsset *)asset;

@end

NS_ASSUME_NONNULL_END
