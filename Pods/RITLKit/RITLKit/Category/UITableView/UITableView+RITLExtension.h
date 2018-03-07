//
//  UITableView+Extension.h
//  NongWanCloud
//
//  Created by YueWen on 2018/1/4.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (RITLExtension)

/// 设置contentInsetAdjustmentBehavior为.never,如果是iOS11之前，则执行handler
- (void)ritl_setContentInsetAdjustmentBehaviorToNeverBeforeiOS11Handler:(dispatch_block_t)handler;


@end



@interface UITableView (RITLExtension)

/// 设置contentInsetAdjustmentBehavior为.never,如果是iOS11之前，则执行handler
- (void)ritl_setContentInsetAdjustmentBehaviorToNeverBeforeiOS11Handler:(dispatch_block_t)handler;

@end

NS_ASSUME_NONNULL_END
