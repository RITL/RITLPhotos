//
//  YPPhotoBrowerPreDataSource.h
//  YPPhotoDemo
//
//  Created by YueWen on 16/9/20.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YPPhotoBrowerController;

NS_ASSUME_NONNULL_BEGIN

NS_CLASS_AVAILABLE_IOS(10_0) @interface YPPhotoBrowerPreDataSource : NSObject <UICollectionViewDataSourcePrefetching>

/// @brief 链接的viewController
@property (nonatomic, readonly, weak) YPPhotoBrowerController * viewController;

/// 便利初始化方法
- (instancetype)initWithLinkViewController:(YPPhotoBrowerController *)viewController;

/// 便利构造器
+ (instancetype)borwerPreDataSourceWithLinkViewController:(YPPhotoBrowerController *)viewController;

@end

NS_ASSUME_NONNULL_END
