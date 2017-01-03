//
//  UIViewController+RITLPhotoAlertController.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "UIViewController+RITLPhotoAlertController.h"

@implementation UIViewController (RITLPhotoAlertController)

-(void)presentAlertController:(NSUInteger)maxNumberOfSelectedPhotos
{
    NSString * title = [NSString stringWithFormat:@"你最多只能选择%@张照片",@(maxNumberOfSelectedPhotos)];
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
    
    [self presentViewController:alertController animated:true completion:nil];
}

@end
