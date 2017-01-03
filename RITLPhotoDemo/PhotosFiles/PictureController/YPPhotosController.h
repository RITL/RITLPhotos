//
//  YPPhotosController.h
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/14.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class YPPhotosController;

@protocol YPPhotosControllerDelegate <NSObject>

@optional

/** 点击右侧取消执行的回调 */
- (void)photosControllerShouldBack:(YPPhotosController *)viewController;

/** 点击完成进行的回调 */
- (void)photosController:(YPPhotosController *)viewController photosSelected:(NSArray <PHAsset *> *)assets Status:(NSArray <NSNumber *> *)status;

@end


NS_AVAILABLE_IOS(8_0) @interface YPPhotosController : UIViewController

@property (nullable, nonatomic, weak)id <YPPhotosControllerDelegate> delegate;



@end




@interface YPPhotosTimeHandleObject : NSObject

/// @brief 将timeInterval转成字符串,格式为00:26
+ (NSString *)timeStringWithTimeDuration:(NSTimeInterval)timeInterval;

@end


NS_ASSUME_NONNULL_END
