//
//  RITLPhotosViewController.h
//  RITLPhotoDemo
//
//  Created by YueWen on 16/7/14.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPPhotoDefines.h"
#import "RITLCollectionViewModel.h"

NS_ASSUME_NONNULL_BEGIN


/// 选择图片的一级界面控制器
NS_AVAILABLE_IOS(8_0) @interface RITLPhotosViewController : UIViewController

/// 当前控制器的viewModel
@property (nonatomic, strong) id <RITLCollectionViewModel> viewModel;


/// 设置当前的viewModel
+ (instancetype)photosViewModelInstance:(id<RITLCollectionViewModel>)viewModel;



@end



//
//@interface RITLPhotosTimeHandleObject : NSObject
//
///// @brief 将timeInterval转成字符串,格式为00:26
//+ (NSString *)timeStringWithTimeDuration:(NSTimeInterval)timeInterval;
//
//@end


NS_ASSUME_NONNULL_END
