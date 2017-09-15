//
//  RITLPhotoNavigationViewController.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/11/29.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "RITLPhotoNavigationViewController.h"
#import "RITLPhotoNavigationViewModel.h"

#import "RITLPhotoGroupViewController.h"
#import "RITLPhotoGroupViewModel.h"

@interface RITLPhotoNavigationViewController ()


@end

@implementation RITLPhotoNavigationViewController

-(instancetype)initWithViewModel:(id <RITLPhotoPublicViewModel>)viewModel
{
    if (self = [super init])
    {
        _viewModel = viewModel;
    }
    
    return self;
}


+(instancetype)photosViewModelInstance:(id <RITLPhotoPublicViewModel>)viewModel
{
    return [[self alloc] initWithViewModel:viewModel];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewControllers = @[[RITLPhotoGroupViewController new]];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
#ifdef RITLDebug
    NSLog(@"Dealloc %@",NSStringFromClass([self class]));
#endif
}

#pragma mark -

-(id <RITLPhotoPublicViewModel>)viewModel
{
    if (!_viewModel)
    {
        _viewModel = [RITLPhotoNavigationViewModel new];
    }
    
    return _viewModel;
}

@end
