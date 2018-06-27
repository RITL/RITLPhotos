//
//  UINavigationController+RITLExtension.m
//  TaoKeClient
//
//  Created by YueWen on 2017/10/21.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "UINavigationController+RITLExtension.h"

@implementation UINavigationController (RITLPreferredStatusBarStyle)

- (UIStatusBarStyle)preferredStatusBarStyle
{
    UIViewController *viewController = self.visibleViewController;
    
    return viewController.preferredStatusBarStyle;
}


@end
