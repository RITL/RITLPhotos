//
//  RITLScrollViewModel.h
//  CityBao
//
//  Created by YueWen on 2016/11/24.
//  Copyright © 2017年 wangpj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RITLPublicViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RITLScrollViewModel <NSObject,RITLPublicViewModel>

@optional


/**
 scrollView滚动时进行回调

 @param contentOffSet 当前滚动视图的偏移量
 */
- (void)scrollViewDidScroll:(CGPoint)contentOffSet;


/**
 滚动视图停止滑动进行上下修正，触发changeFunctionHeaderViewBlock
 
 @param conentOffSet 当前滚动视图的偏移量
 */
- (void)scrollViewWillEndDragging:(CGPoint)conentOffSet;




/**
 响应滚动视图减速完毕

 @param conetntOffSet 当前滚动视图的偏移量
 */
-(void)scrollViewDidEndDecelerating:(CGPoint)conetntOffSet;

@end

NS_ASSUME_NONNULL_END
