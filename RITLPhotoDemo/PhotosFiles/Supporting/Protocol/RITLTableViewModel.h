//
//  RITLTableViewModel.h
//  CityBao
//
//  Created by YueWen on 2016/11/14.
//  Copyright © 2017年 wangpj. All rights reserved.
//

#import "RITLScrollViewModel.h"
#import "RITLTableCellViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RITLTableViewModel <NSObject,RITLScrollViewModel,RITLTableCellViewModel>

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
 当前位置的cell是否允许点击

 @param indexPath 当前位置的indexPath
 @return
 */
- (BOOL)shouldHighlightRowAtIndexPath:(nullable NSIndexPath *)indexPath;

/**
 根据当前的位置执行控制器操作
 
 @param indexPath 当前位置的indexPath
 */
- (void)didSelectRowAtIndexPath:(nullable NSIndexPath *)indexPath;




/**
 当前section的footerView的高度

 @param section 
 */
- (CGFloat)heightForFooterInSection:(NSInteger)section;



#pragma mark - 负责cell

///**
// 需要注册的cell类，优先于nibsOfRegisterCell
//
// @return
// */
//- (NSArray<UITableViewCell *> *)classOfRegisterCell;
//
//
///**
// 需要注册的Nib类
//
// @return
// */
//- (NSArray<UINib *> *)nibsOfRegisterCell;
//
//
///**
// 进行注册的cell的重用标识符
//
// @return 
// */
//- (NSArray<NSString *> *)identifiersOfRegister;

@end

NS_ASSUME_NONNULL_END

