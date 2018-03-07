//
//  RITLPhotosNavigationViewController.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/3/7.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "RITLPhotosViewController.h"
#import "RITLPhotosGroupTableViewController.h"

@interface RITLPhotosViewController ()

@end

@implementation RITLPhotosViewController


+ (RITLPhotosViewController *)photosViewController
{
    return [[self alloc]initWithRootViewController:RITLPhotosGroupTableViewController.new];
}


- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    return [super initWithRootViewController:RITLPhotosGroupTableViewController.new];
}



@end
