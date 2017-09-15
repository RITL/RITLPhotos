//
//  RITLPhotosViewController.h
//  RITLPhotoDemo
//
//  Created by YueWen on 16/7/14.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RITLPhotoCollectionViewModel.h"
#import "RITLPhotoViewController.h"

NS_ASSUME_NONNULL_BEGIN


/// 选择图片的一级界面控制器
NS_AVAILABLE_IOS(8_0) @interface RITLPhotosViewController : UIViewController <RITLPhotoViewController>

/// 当前控制器的viewModel
@property (nonatomic, strong) id <RITLPhotoCollectionViewModel> viewModel;


@end


@interface RITLPhotosViewController (updateNumberOfLabel)

/**
 更新选中的图片数

 @param number 选中的图片数
 */
- (void)updateNumbersForSelectAssets:(NSUInteger)number;

@end





NS_ASSUME_NONNULL_END
