//
//  RITLScrollViewModel.h
//  CityBao
//
//  Created by YueWen on 2016/11/24.
//  Copyright © 2016年 wangpj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RITLScrollViewModel <NSObject>

@optional


/**
 scrollView滚动时进行回调

 @param contentOffSet 当前滚动视图的偏移量
 */
- (void)scrollViewDidScroll:(CGPoint)contentOffSet;

@end

NS_ASSUME_NONNULL_END
