//
//  UIViewController+RITLExtension.m
//  EattaClient
//
//  Created by YueWen on 2017/7/24.
//  Copyright © 2017年 ryden. All rights reserved.
//

#import "UIViewController+RITLExtension.h"

@implementation UIViewController (RITLInitializeHandler)


+(instancetype)viewController:(void (^)(__kindof UIViewController * _Nonnull))initializeHandler
{
    id viewController = [[self alloc]init];
    
    initializeHandler(viewController);
    
    return viewController;
}


@end


@implementation UIViewController (RITLLevel)

-(UIViewController *)ritl_topLevelController
{
    if (self.parentViewController == nil) {
        
        return self;
    }
    
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]
        || [self.parentViewController isKindOfClass:[UITabBarController class]]) {
        
        return self;
    }
    
    // 进行递归返回
    return self.parentViewController.ritl_topLevelController;
}


-(void)ritl_topNavigationPushViewController:(__kindof UIViewController *)viewController animated:(BOOL)animated
{
    if (!self.ritl_topLevelController.navigationController) {//不存在导航
        
        return;
    }
    
    [self.ritl_topLevelController.navigationController pushViewController:viewController animated:animated];
}

@end
