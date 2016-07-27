//
//  YPPhotoNavgationController.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/14.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "YPPhotoNavgationController.h"
#import "YPPhotoGroupController.h"

@interface YPPhotoNavgationController ()


@end

@implementation YPPhotoNavgationController


- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.maxNumberOfSelectImages ==0) self.maxNumberOfSelectImages = 9;
    
    //设置rootViewController
    YPPhotoGroupController * rootViewController = self.viewControllers.firstObject;
    
    [rootViewController setValue:[NSNumber numberWithUnsignedInteger:_maxNumberOfSelectImages]  forKey:@"maxNumberOfSelectImages"];
    
    __weak typeof(self) weakSelf = self;
    
    rootViewController.photosDidSelectBlock = ^(NSArray <PHAsset *> * assets,NSArray <NSNumber *> * status){
        
        if (weakSelf.photosDidSelectBlock != nil)
        {
            weakSelf.photosDidSelectBlock(assets,status);
        }
        
        [weakSelf dismissViewControllerAnimated:true completion:^{}];
        
    };
}

-(void)dealloc
{
    NSLog(@"YPPhotoNavgationController Dealloc");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
