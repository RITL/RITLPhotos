//
//  RITLPhotosItemsCollectionViewController.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/3/7.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

///
@interface RITLPhotosCollectionViewController : UIViewController

/// 图片选择器
@property (class, nonatomic, strong, readonly)RITLPhotosCollectionViewController *photosCollectionController;

/// `PHCollection`的`localIdentifier`
@property (nonatomic, copy) NSString *localIdentifier;

@end

NS_ASSUME_NONNULL_END
