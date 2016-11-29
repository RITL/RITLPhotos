//
//  RITLViewController.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/11/29.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RITLViewController <NSObject>

@optional

/**
 便利初始化方法
 
 @param viewModel 当前控制器的viewModel
 @return 初始完毕的ViewController对象
 */
-(instancetype)initWithViewModel:(id)viewModel;

/**
 便利构造器
 
 @param viewModel 当前控制器的viewModel
 @return 初始完毕的ViewController对象
 */
+(instancetype)controllerWithViewModel:(id)viewModel;

@end
