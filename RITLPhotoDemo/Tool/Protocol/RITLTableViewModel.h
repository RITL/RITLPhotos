//
//  RITLTableViewModel.h
//  CityBao
//
//  Created by YueWen on 2016/11/14.
//  Copyright © 2016年 wangpj. All rights reserved.
//

#import "RITLScrollViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RITLTableViewModel <NSObject,RITLScrollViewModel>

@optional

/**
 tableView的group数量
 
 @return tableView的group数量
 */
- (NSUInteger)numberOfGroup;

/**
 tableView每组的row数
 
 @param section 当前的位置
 @return 每组的row数量
 */
- (NSUInteger)numberOfRowInSection:(NSUInteger)section;


#pragma mark - tableView delegate


/**
 tableView每组的headerView的高度
 
 @param section 当前的section
 @return 当前组的section
 */
- (CGFloat)sectionHeaderHeight:(NSUInteger)section;

/**
 tableView的Cell高度
 
 @param indexPath 当前位置的indexPath
 @return 当前位置cell的高度
 */
- (CGFloat)heightForRowAtIndexPath:(nullable NSIndexPath *)indexPath;

/**
 根据当前的位置执行控制器操作
 
 @param indexPath 当前位置的indexPath
 */
- (void)didSelectRowAtIndexPath:(nullable NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END

