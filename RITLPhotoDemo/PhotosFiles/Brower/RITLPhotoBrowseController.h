//
//  RITLPhotoBrowerController.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RITLPhotoCollectionViewModel.h"
#import "RITLPhotoViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RITLPhotoBrowseController : UIViewController <RITLPhotoViewController>

/// 当前控制器的viewModel
@property (nonatomic, strong) id <RITLPhotoCollectionViewModel> viewModel;

@end


@interface RITLPhotoBrowseController (UpdateNumberOfLabel)

/**
 更新选中的图片数
 
 @param number 选中的图片数
 */
- (void)updateNumbersForSelectAssets:(NSUInteger)number;

@end


@interface RITLPhotoBrowseController (UpdateSizeLabel)


/**
 更新高清显示的状态

 @param isHightQuarity 是否为高清状态
 */
- (void)updateSizeLabelForIsHightQuarity:(BOOL)isHightQuarity;

@end


@interface RITLPhotoBrowseController (RITLPhotosViewController)

@end

NS_ASSUME_NONNULL_END
