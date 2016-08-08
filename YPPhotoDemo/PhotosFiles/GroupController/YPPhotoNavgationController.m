//
//  YPPhotoNavgationController.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/14.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "YPPhotoNavgationController.h"
#import "YPPhotoGroupController.h"
#import "YPPhotoStore.h"

@interface YPPhotoNavgationController ()


@end

@implementation YPPhotoNavgationController


- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.maxNumberOfSelectImages ==0) self.maxNumberOfSelectImages = 9;
    
    self.viewControllers = @[[[YPPhotoGroupController alloc]init]];
    
    //设置rootViewController
    YPPhotoGroupController * rootViewController = self.viewControllers.firstObject;
    
    [rootViewController setValue:[NSNumber numberWithUnsignedInteger:_maxNumberOfSelectImages]  forKey:@"maxNumberOfSelectImages"];
    
    __weak typeof(self) weakSelf = self;
    
    rootViewController.photosDidSelectBlock = ^(NSArray <PHAsset *> * assets,NSArray <NSNumber *> * status){
        
        if (weakSelf.photosDidSelectBlock != nil)
        {
            weakSelf.photosDidSelectBlock(assets,status);
        }
        
        if (weakSelf.photoImageSelectBlock != nil)
        {
            //开始请求图片对象
            [YPPhotoStoreHandleClass imagesWithAssets:assets status:status Size:weakSelf.imageSize complete:^(NSArray<UIImage *> * _Nonnull images) {
            
                weakSelf.photoImageSelectBlock(images);
            
                //dismiss掉
                [weakSelf dismissViewControllerAnimated:true completion:^{}];
                
            }];
        }
        
        if (weakSelf.photoImageSelectBlock == nil)
        {
           [weakSelf dismissViewControllerAnimated:true completion:^{}];
        }
    };
}

-(void)dealloc
{
#ifdef YDEBUG
    NSLog(@"YPPhotoNavgationController Dealloc");
#endif
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
