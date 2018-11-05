//
//  RITLPhotosMaker.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/5/18.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RITLPhotosViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

typedef dispatch_block_t RITLCompleteReaderHandle;


/// 图片的生成者
@interface RITLPhotosMaker : NSObject

/// 缩略图大小,默认为.Zero
@property (nonatomic, assign)CGSize thumbnailSize;
/// 绑定的viewController
@property (nonatomic, weak, nullable) UIViewController *bindViewController;
/// 真正的代理对象
@property (nonatomic, weak, nullable)id<RITLPhotosViewControllerDelegate>delegate;


/// 局部单例对象
+ (instancetype)sharedInstance;
/// 开始生成图片，并开始触发各种回调
- (void)startMakePhotosComplete:(nullable RITLCompleteReaderHandle)complete;

@end

NS_ASSUME_NONNULL_END
