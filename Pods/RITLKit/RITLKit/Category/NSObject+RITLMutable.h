//
//  NSObject+RITLMutable.h
//  NongWanCloud
//
//  Created by YueWen on 2018/1/3.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef id _Nonnull (^RITLMutableHandler)(__kindof id obj);
typedef UIView* _Nonnull (^RITLViewMutableHandler)(__kindof UIView* view);
typedef UIViewController* _Nonnull (^RITLControllerMutableHandler)(__kindof UIViewController* viewController);


/// 变换
@interface NSObject (RITLMutable)

- (instancetype)ritl_mutable:(RITLMutableHandler)handler;

@end


@interface UIView (RITLMutable)

- (instancetype)ritl_mutable:(RITLViewMutableHandler)handler;

@end


@interface UIViewController (RITLMutable)

- (instancetype)ritl_mutable:(RITLControllerMutableHandler)handler;

@end


NS_ASSUME_NONNULL_END
