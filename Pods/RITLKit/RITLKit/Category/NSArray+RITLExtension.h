//
//  NSArray+RITLExtension.h
//  EattaClient
//
//  Created by YueWen on 2017/6/22.
//  Copyright © 2017年 ryden. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/// 泛型数组使用
@interface NSArray<__covariant ObjectType> (RITLExtension)

/// 数组转换的map函数
- (NSArray *)ritl_detailMap:(id(^)(ObjectType,NSInteger))mapHandler;
- (NSArray *)ritl_map:(id(^)(ObjectType))mapHander;



/// 数组过滤器的filter函数
- (NSArray *)ritl_detailFilter:(BOOL(^)(ObjectType,NSInteger))filterHandler;
- (NSArray *)ritl_filter:(BOOL(^)(ObjectType))filterHandler;


/// 数组变换的reduce函数
- (NSArray *)ritl_detailReduce:(NSArray *)initial
                reduceHandler:(NSArray *(^)(NSArray *,id,NSInteger))reduceHandler;
- (NSArray *)ritl_reduce:(NSArray *)initial
          reduceHandler:(NSArray *(^)(NSArray *,id))reduceHandler;



/// 逆序数组
- (NSArray <ObjectType> *)ritl_revert;


@property (nonatomic, strong, nullable, readonly)ObjectType ritl_safeFirstObject;

/// 获得object的方法
- (nullable ObjectType)ritl_safeObjectAtIndex:(NSInteger)index;


/// 获得逆序的方法
- (nullable ObjectType)ritl_revertObjectAtIndex:(NSInteger)index;

@end



NS_ASSUME_NONNULL_END
