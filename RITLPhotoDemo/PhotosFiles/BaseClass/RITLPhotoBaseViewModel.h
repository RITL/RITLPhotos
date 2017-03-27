//
//  RITLBaseViewModel.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/28.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RITLPhotoPublicViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef PhotoBlock          RITLShouldDismissBlock;
typedef PhotoCompleteBlock6 RITLShouldAlertToWarningBlock;

/// 基础的viewModel
@interface RITLPhotoBaseViewModel : NSObject <RITLPhotoPublicViewModel>

/// 选择图片达到最大上限，需要提醒的block
@property (nonatomic, copy, nullable)RITLShouldAlertToWarningBlock warningBlock;

/// 模态弹出的回调
@property (nonatomic, copy, nullable)RITLShouldDismissBlock dismissBlock;


/// 选择图片完成
- (void)photoDidSelectedComplete;

@end

NS_ASSUME_NONNULL_END
