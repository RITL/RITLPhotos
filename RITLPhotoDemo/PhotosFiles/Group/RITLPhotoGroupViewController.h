//
//  YPPhotoGroupController.h
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/13.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RITLViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class RITLPhotoGroupViewModel;

/// 显示组的控制器
NS_AVAILABLE_IOS(8_0) @interface RITLPhotoGroupViewController : UITableViewController<RITLViewController>

/// viewModel
@property (nonatomic, strong) RITLPhotoGroupViewModel * viewModel;


@end

NS_ASSUME_NONNULL_END
