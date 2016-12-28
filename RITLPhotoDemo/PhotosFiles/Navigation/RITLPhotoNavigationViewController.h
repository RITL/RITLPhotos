//
//  RITLPhotoNavigationViewController.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/11/29.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RITLPhotoNavigationViewModel;

/// 进入控制器的主导航控制器
NS_CLASS_AVAILABLE_IOS(8_0)  @interface RITLPhotoNavigationViewController : UINavigationController

/// 控制器的viewModel
@property (nonatomic, strong) RITLPhotoNavigationViewModel * viewModel;


@end

NS_ASSUME_NONNULL_END
