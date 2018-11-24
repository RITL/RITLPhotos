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

/// 是否为高质量，可以使用KVO:NSKeyValueObservingOptionNew
@property (nonatomic, assign, getter=isHightQuality)BOOL hightQuality;

/// 选中资源的标志位
@property (nonatomic, copy, readonly) NSArray <NSString *> *assetIdentiers;
@property (nonatomic, copy, readonly) NSArray <PHAsset *> *assets;
/// 选中的资源个数，可以用于KVO:NSKeyValueObservingOptionNew
@property (nonatomic, assign, readonly) NSInteger count;

/// 默认选中的标志位,用来二次进入默认选中的标志位
@property (nonatomic, copy)NSArray <NSString *> *defaultIdentifers;

/// 可自动销毁的单例对象
+ (instancetype)sharedInstance;

/// action
- (void)addPHAsset:(PHAsset *)asset;
- (void)removePHAsset:(PHAsset *)asset;
- (void)removePHAssetAtIndex:(NSUInteger)index;
- (void)removeAllPHAssets;
- (void)exchangePHAssetAtIndex:(NSUInteger)idx1 withPHAssetAtIndex:(NSUInteger)idx2;


/**
 * 进行自动添加或者删除的操作
 * 如果不存在该资源，追加，并返回当前所在的个数(索引+1)
 * 如果存在该资源，删除，并返回-1
 */
- (nullable NSNumber *)addOrRemoveAsset:(PHAsset *)asset;

/// 是否已经选择了asset
- (BOOL)containAsset:(PHAsset *)asset;

@end

NS_ASSUME_NONNULL_END
