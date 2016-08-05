//
//  YPPhotoBrowerCDelegate.h
//  YPPhotoDemo
//
//  Created by YueWen on 16/8/4.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class YPPhotoBrowerController;

NS_CLASS_AVAILABLE_IOS(8_0) @interface YPPhotoBrowerCDelegate : NSObject <UICollectionViewDelegateFlowLayout>


/// @brief 链接的viewController
@property (nonatomic, readonly, weak) YPPhotoBrowerController * viewController;


/// 便利初始化方法
- (instancetype)initWithLinkViewController:(YPPhotoBrowerController *)viewController;



/// 便利构造器
+ (instancetype)borwerDelegateWithLinkViewController:(YPPhotoBrowerController *)viewController;



#pragma mark - public function

/// 滚动结束调用
- (void)scrollViewEndDecelerating:(UIScrollView *)scrollView;


@end

NS_ASSUME_NONNULL_END
