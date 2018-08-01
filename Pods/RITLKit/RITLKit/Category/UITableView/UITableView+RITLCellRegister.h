//
//  UITableView+RITLCellRegister.h
//  EattaClient
//
//  Created by YueWen on 2017/5/9.
//  Copyright © 2017年 ryden. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^RITLReusableCellInitHandler)(__kindof UITableViewCell *cell);


@interface UITableView (RITLCellRegister)

/**
 根据标志位进行注册cell

 @param identifiers 存放标志位的集合
 */
- (void)ritl_registeCellWithIdentidiers:(NSSet *)identifiers;


/**
 批量注册cell
 
 @param cellClasses 注册cell的Class数组
 @param identifiers 注册cell的identifiers数组
 */
- (void)ritl_registerClasses:(NSArray<Class>*)cellClasses
   forCellReuseIdentifiers:(NSArray<NSString *>*)identifiers;


@end


@interface UITableView (RITLDequeueCell)


- (__kindof UITableViewCell *)ritl_dequeueReusableCellWithIdentifier:(NSString *)identifier class:(Class)cellClass;

/// handler为第一次创建cell时候进行的设置
- (__kindof UITableViewCell *)ritl_dequeueReusableCellWithIdentifier:(NSString *)identifier
                                                               class:(Class)cellClass
                                                       buildComplete:(nullable RITLReusableCellInitHandler)handler;

@end


NS_ASSUME_NONNULL_END
