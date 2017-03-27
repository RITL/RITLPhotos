//
//  RITLTableCellViewModel.h
//  CityBao
//
//  Created by YueWen on 2016/11/23.
//  Copyright © 2017年 wangpj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RITLPhotoPublicViewModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 提供简单的内容接口
@protocol RITLPhotoTableCellViewModel <NSObject,RITLPhotoPublicViewModel>

@optional


/**
 获得当前indexPath显示的标题
 
 @param indexPath 当前位置indexPath
 @return 当前位置显示的标题
 */
- (NSString *)titleForCellAtIndexPath:(NSIndexPath *)indexPath;



/**
 获得当前indexPath显示标题的颜色

 @param indexPath 当前位置indexPath
 @return 当前位置显示标题的颜色
 */
- (UIColor *)colorForTitleCellAtIndexPath:(NSIndexPath *)indexPath;


/**
 获得当前indexPath显示的图像
 
 @param indexPath 当前位置indexPath
 @return 当前位置显示的图片
 */
- (UIImage *)imageForCellAtIndexPath:(NSIndexPath *)indexPath;




/**
 获得当前indexPath位置cell背景色

 @param indexPath 当前位置indexPath
 @return 当前位置的背景色
 */
- (UIColor *)colorForCellBackgroundAtIndexPath:(nullable NSIndexPath *)indexPath;



@end

NS_ASSUME_NONNULL_END
