//
//  UITableView+Extension.m
//  NongWanCloud
//
//  Created by YueWen on 2018/1/4.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "UITableView+RITLExtension.h"

@implementation UIScrollView (RITLExtension)

- (void)ritl_setContentInsetAdjustmentBehaviorToNeverBeforeiOS11Handler:(dispatch_block_t)handler
{
    if (UIDevice.currentDevice.systemVersion.floatValue >= 11.0)
    {
        if (@available(iOS 11.0, *))
        {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    else
    {
        handler();
    }
}

@end

@implementation UITableView (RITLExtension)

- (void)ritl_setContentInsetAdjustmentBehaviorToNeverBeforeiOS11Handler:(dispatch_block_t)handler
{
    if (UIDevice.currentDevice.systemVersion.floatValue >= 11.0)
    {
        if (@available(iOS 11.0, *))
        {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    else
    {
        handler();
    }
}

@end
