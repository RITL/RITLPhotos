//
//  RITLPhotoBrowerController.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RITLCollectionViewModel.h"
#import "RITLPhotoViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RITLPhotoBrowerController : UIViewController <RITLPhotoViewController>

/// 当前控制器的viewModel
@property (nonatomic, strong) id <RITLCollectionViewModel> viewModel;

@end


@interface RITLPhotoBrowerController (UpdateNumberOfLabel)

/**
 更新选中的图片数
 
 @param number 选中的图片数
 */
- (void)updateNumbersForSelectAssets:(NSUInteger)number;

@end


@interface RITLPhotoBrowerController (UpdateSizeLabel)


/**
 更新高清显示的状态

 @param isHightQuarity 是否为高清状态
 */
- (void)updateSizeLabelForIsHightQuarity:(BOOL)isHightQuarity;

@end

NS_ASSUME_NONNULL_END
