//
//  RITLPhotosNavigationViewController.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/3/7.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "RITLPhotosViewController.h"
#import "RITLPhotosMaker.h"
#import "RITLPhotosDataManager.h"
#import "RITLPhotosGroupTableViewController.h"
#import "RITLPhotosCollectionViewController.h"

@interface RITLPhotosViewController ()

@property (nonatomic, strong, readwrite) RITLPhotosConfiguration *configuration;
@property (nonatomic, strong) RITLPhotosMaker *maker;
@property (nonatomic, strong) RITLPhotosDataManager *dataManager;

@end

@implementation RITLPhotosViewController

+ (instancetype)photosViewController
{
    return self.new;
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        self.maker = RITLPhotosMaker.sharedInstance;
        self.dataManager = RITLPhotosDataManager.sharedInstance;
        self.configuration = RITLPhotosConfiguration.defaultConfiguration;
        self.viewControllers = @[RITLPhotosGroupTableViewController.new,
                                 RITLPhotosCollectionViewController.new];
    }
    
    return self;
}

- (void)setThumbnailSize:(CGSize)thumbnailSize
{
    self.maker.thumbnailSize = thumbnailSize;
}


- (void)setPhoto_delegate:(id<RITLPhotosViewControllerDelegate>)photo_delegate
{
    self.maker.delegate = photo_delegate;
    self.maker.bindViewController = self;
}


- (void)setDefaultIdentifers:(NSArray<NSString *> *)defaultIdentifers
{
    self.dataManager.defaultIdentifers = defaultIdentifers;
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
