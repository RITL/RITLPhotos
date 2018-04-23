//
//  NSArray+RITLExtension.h
//  EattaClient
//
//  Created by YueWen on 2017/6/22.
//  Copyright © 2017年 ryden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

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


@interface NSArray (CoreGraphic)

/**
 x,y
 @[@44] => Point(44,44)
 @[@44,@50] => Point(44,50)
 */
@property (nonatomic, assign, readonly)CGPoint ritl_point;

/**
 width,height
 @[@44] => Size(44,44)
 @[@44,@50] => Size(44,50)
 */
@property (nonatomic, assign, readonly)CGSize ritl_size;

/**
 x,y,width,height
 @[@10]             => CGRect(10,10,10,10)
 @[@10,@20]         => CGRect(10,10,20,20)
 @[@10,@20,@30]     => CGRect(10,20,30,30)
 @[@10,@20,@30,@40] => CGRect(10,20,30,40)
 */
@property (nonatomic, assign, readonly)CGRect ritl_rect;

/**
 top,left,bottom,right
 @[@10]             => Insets(10,10,10,10)
 @[@10,@20]         => Insets(10,20,10,20)
 @[@10,@20,@30]     => Insets(10,20,30,20)
 @[@10,@20,@30,@40] => Insets(10,20,30,40)
 */
@property (nonatomic, assign, readonly)UIEdgeInsets ritl_insets;

@end



NS_ASSUME_NONNULL_END
