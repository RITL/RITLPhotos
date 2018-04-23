//
//  RITLPhotosNavigationViewController.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/3/7.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "RITLPhotosViewController.h"
#import "RITLPhotosGroupTableViewController.h"
#import "RITLPhotosCollectionViewController.h"

@interface RITLPhotosViewController ()

@end

@implementation RITLPhotosViewController


+ (RITLPhotosViewController *)photosViewController
{
    return self.new;
}


//- (instancetype)init
//{
//    if (self = [super init]) {
//        
//        self.viewControllers = @[RITLPhotosGroupTableViewController.new,
//                                 RITLPhotosCollectionViewController.new];
//    }
//    
//    return self;
//}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.viewControllers = @[RITLPhotosGroupTableViewController.new,
                                 RITLPhotosCollectionViewController.new];
    }
    
    return self;
}

@end
