//
//  RITLViewExtension.h
//  RITLKitDemo
//
//  Created by YueWen on 2018/1/6.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 一个链式的添加子视图
@interface RITLViewHandler : NSObject

/// 添加子视图
- (RITLViewHandler *(^)(UIView *))add;

/// 移除子视图
- (RITLViewHandler *(^)(UIView *))remove;

@end

/**
 Example:
 UIView *view = UIView.new;
 UIView *subView1 = UIView.new;
 UIView *subView2 = UIView.new;
 
 Use:
 view.ritl_view.add(subView1).add(subView2);
 
 equalTo:
 [view addSubview:subView1];
 [view addSubview:subView1];
 
 */
@interface UIView (RITLViewAddHandler)

/// 追加视图
@property (nonatomic, strong, readonly) RITLViewHandler *ritl_view;

@end

NS_ASSUME_NONNULL_END
