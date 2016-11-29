//
//  YPPhotosController.h
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/14.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPPhotoDefines.h"



NS_ASSUME_NONNULL_BEGIN

@class RITLPhotosViewModel;

//@class RITLPhotosViewController;
//
//@protocol YPPhotosControllerDelegate <NSObject>
//
//@optional
//
///** 点击右侧取消执行的回调 */
//- (void)photosControllerShouldBack:(RITLPhotosViewController *)viewController;
//
///** 点击完成进行的回调 */
//- (void)photosController:(RITLPhotosViewController *)viewController photosSelected:(NSArray <PHAsset *> *)assets Status:(NSArray <NSNumber *> *)status;
//
//@end


/// 选择图片的一级界面控制器
NS_AVAILABLE_IOS(8_0) @interface RITLPhotosViewController : UIViewController

//@property (nullable, nonatomic, weak)id <YPPhotosControllerDelegate> delegate;

/// 当前控制器的viewModel
@property (nonatomic, strong) RITLPhotosViewModel * viewModel;

@end



//
//@interface RITLPhotosTimeHandleObject : NSObject
//
///// @brief 将timeInterval转成字符串,格式为00:26
//+ (NSString *)timeStringWithTimeDuration:(NSTimeInterval)timeInterval;
//
//@end


NS_ASSUME_NONNULL_END
