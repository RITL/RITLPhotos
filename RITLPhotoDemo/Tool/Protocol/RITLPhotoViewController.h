//
//  RITLPhotoViewController.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RITLPhotoViewController <NSObject>


-(instancetype)initWithViewModel:(nullable id)viewModel;

@optional


+ (instancetype)photosViewModelInstance:(nullable id)viewModel;

@end

NS_ASSUME_NONNULL_END
