//
//  YPPhotoBrowerController.h
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/14.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YPPhotoBrowerController;

@protocol YPPhotoBrowerControllerDelegate <NSObject>

@optional

/** 返回按钮执行的block,用于colletionView更新 */
- (void)photoBrowerControllerShouldBack:(YPPhotoBrowerController *)viewController;

/** 点击完成进行的回调 */
- (void)photoBrowerController:(YPPhotoBrowerController *)viewController photosSelected:(NSArray <PHAsset *> *)photos Status:(NSArray <NSNumber *> *)status;

@end


typedef void(^YPPhotoBrowerBackBlock)(void);

NS_CLASS_AVAILABLE_IOS(8_0) @interface YPPhotoBrowerController : UIViewController

@property (nullable, nonatomic, weak)id <YPPhotoBrowerControllerDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
