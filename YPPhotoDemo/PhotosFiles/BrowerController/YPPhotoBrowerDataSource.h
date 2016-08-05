//
//  YPPhotoBrowerDataSource.h
//  YPPhotoDemo
//
//  Created by YueWen on 16/8/4.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YPPhotoBrowerController;

NS_ASSUME_NONNULL_BEGIN

NS_CLASS_AVAILABLE_IOS(8_0) @interface YPPhotoBrowerDataSource : NSObject <UICollectionViewDataSource>

/// @brief 最大的选择数量
@property (nonatomic, strong) NSNumber * maxNumberOfSelectImages;

/// @brief 是否是高清的标志位
@property (nonatomic, assign) BOOL isHighQuality;

/// @brief 当前选择的资源
@property (nonatomic, strong)PHAsset * currentAsset;

/// @brief 存储之前已经选择的资源
@property (nonatomic, readonly, strong)NSMutableArray <PHAsset *> * didSelectAssets;
@property (nonatomic, readonly, strong)NSMutableArray <NSNumber *> * didSelectAssetStatus;

/// @brief 存放可以游览的资源数组
@property (nonatomic, readonly, copy)NSArray <PHAsset *> * browerAssets;

/// @brief 链接的viewController
@property (nonatomic, readonly, weak) YPPhotoBrowerController * viewController;


/**
 *  便利初始化方法
 *
 *  @param currentAsset         当前的资源对象
 *  @param browerAssets         需要浏览的资源数组
 *  @param selectAssets         已经选择的资源数组
 *  @param didSelectAssetStatus 已经选择的资源状态数组
 *  @param viewController       连接的YPPhotoBrowerController对象
 */
- (instancetype)initWithCurrentAsset:(PHAsset *)currentAsset
                        BrowerAssets:(NSArray <PHAsset *> *)browerAssets
                        selectAssets:(NSMutableArray <PHAsset *> * )selectAssets
                              status:(NSMutableArray <NSNumber *> *)didSelectAssetStatus
                browerViewController:(YPPhotoBrowerController *)viewController;


/**
 *  便利构造器
 *
 *  @param currentAsset         当前的资源对象
 *  @param browerAssets         需要浏览的资源数组
 *  @param selectAssets         已经选择的资源数组
 *  @param didSelectAssetStatus 已经选择的资源状态数组
 *  @param viewController       连接的YPPhotoBrowerController对象
 */
+ (instancetype)browerDataSourceWithCurrentAsset:(PHAsset *)currentAsset
                                    BrowerAssets:(NSArray <PHAsset *> *)browerAssets
                                    selectAssets:(NSMutableArray <PHAsset *> * )selectAssets
                                          status:(NSMutableArray <NSNumber *> *)didSelectAssetStatus
                            browerViewController:(YPPhotoBrowerController *)viewController;

@end

NS_ASSUME_NONNULL_END
