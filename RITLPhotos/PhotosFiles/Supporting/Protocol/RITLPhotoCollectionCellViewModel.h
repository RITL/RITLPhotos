//
//  RITLCollectionCellViewModel.h
//  CityBao
//
//  Created by YueWen on 2016/11/23.
//  Copyright © 2017年 wangpj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RITLPhotoPublicViewModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 提供简单的内容接口
@protocol RITLPhotoCollectionCellViewModel <NSObject,RITLPhotoPublicViewModel>

@optional

/**
 获得当前indexPath显示的标题
 
 @param indexPath 当前位置indexPath
 @return 当前位置显示的标题
 */
- (NSString *)titleOfItemAtIndexPath:(NSIndexPath *)indexPath;



/**
 获得当前indexPath显示的标题
 
 @param indexPath 当前位置indexPath
 @return 当前位置显示的标题
 */
- (NSAttributedString *)attributeTitleOfItemAtIndexPath:(NSIndexPath *)indexPath;


/**
 获得当前indexPath显示的图像
 
 @param indexPath 当前位置indexPath
 @return 当前位置显示的图片
 */
- (UIImage *)imageOfItemAtIndexPath:(NSIndexPath *)indexPath;


/**
 返回当前位置返回图片的url
 
 @param indexPath 当前位置
 @return 需要加载图片的url
 */
- (NSString *)imageUrlStringForCellAtIndexPath:(NSIndexPath *)indexPath;

@end


NS_ASSUME_NONNULL_END
