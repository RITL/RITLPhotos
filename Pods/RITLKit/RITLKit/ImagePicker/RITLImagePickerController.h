//
//  RITL_ImagePickerController.h
//  yuyetong
//
//  Created by YueWen on 2017/3/27.
//  Copyright © 2017年 ztld. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 图片单选控制器，全局采用单例模式
@interface RITLImagePickerController : UIImagePickerController


@property (nonatomic, assign)UIStatusBarStyle statusStyle;

/// 区别的标志位
@property (nonatomic, copy, nullable) NSString * identifier;

/// 单例方法
+(instancetype)sharedInstance;

/**
 单例方法并设置全局代理

 @param sourceType 源类型
 @param delegate 设置的代理
 @return 单例对象
 */
+(instancetype)sharedInstance:(UIImagePickerControllerSourceType)sourceType
                     delegate:(id<UIImagePickerControllerDelegate,UINavigationControllerDelegate>)delegate;



/**
 单例方法并设置全局代理

 @param sourceType 源类型
 @param identifier 调用的标志位
 @param delegate 设置的代理
 @return 单例对象
 */
+(instancetype)sharedInstance:(UIImagePickerControllerSourceType)sourceType
                   identifier:(NSString *)identifier
                     delegate:(id<UIImagePickerControllerDelegate,UINavigationControllerDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
