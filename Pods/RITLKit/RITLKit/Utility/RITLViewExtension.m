//
//  RITLViewExtension.m
//  RITLKitDemo
//
//  Created by YueWen on 2018/1/6.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "RITLViewExtension.h"
#import <objc/runtime.h>

@interface RITLViewHandler()

/// 所在的view
@property (nonatomic, weak) UIView *containView;

@end

@implementation RITLViewHandler

- (RITLViewHandler * _Nonnull (^)(UIView * _Nonnull))add
{
    return ^id(UIView * _Nonnull view){
        
        [self.containView addSubview:view];
        
        return self;
    };
}

- (RITLViewHandler * _Nonnull (^)(UIView * _Nonnull))remove
{
    return ^id(UIView * _Nonnull view){
      
        if ([view isDescendantOfView:self.containView]) {
            
            [view removeFromSuperview];
        }
        return self;
    };
}

@end


@protocol RITLViewHandler <NSObject>
/// 所在的view
@property (nonatomic, weak) UIView *containView;

@end

@interface RITLViewHandler (UIView)<RITLViewHandler>
@end


@implementation UIView (RITLViewAddHandler)

- (RITLViewHandler *)ritl_view
{
    RITLViewHandler* handler = objc_getAssociatedObject(self, _cmd);
    
    if (handler) {
        
        return handler;
    }
    
    handler = RITLViewHandler.new;
    handler.containView = self;
    
    objc_setAssociatedObject(self, _cmd, handler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return handler;
}




@end
