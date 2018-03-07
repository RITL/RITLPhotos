//
//  RITL_ImagePickerController.m
//  yuyetong
//
//  Created by YueWen on 2017/3/27.
//  Copyright © 2017年 ztld. All rights reserved.
//

#import "RITLImagePickerController.h"

static NSString * RITL_ImagePickerController_defaultIdentifier = @"RITL_ImagePickerController_DefaultIdentifier";

@interface RITLImagePickerController ()

@end

@implementation RITLImagePickerController

+(instancetype)sharedInstance
{
    static RITLImagePickerController * imagePicker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imagePicker = [RITLImagePickerController new];
    });
    
    return imagePicker;
}


+(instancetype)sharedInstance:(UIImagePickerControllerSourceType)sourceType
                     delegate:(id<UIImagePickerControllerDelegate,UINavigationControllerDelegate>)delegate
{
    return [self sharedInstance:sourceType identifier:RITL_ImagePickerController_defaultIdentifier delegate:delegate];
}



+(instancetype)sharedInstance:(UIImagePickerControllerSourceType)sourceType identifier:(NSString *)identifier delegate:(id<UIImagePickerControllerDelegate,UINavigationControllerDelegate>)delegate
{
    RITLImagePickerController * imagePicker = [self sharedInstance];
    
    imagePicker.delegate = delegate;
    
    if ([RITLImagePickerController isSourceTypeAvailable:sourceType]) {
        imagePicker.sourceType = sourceType;
    }
    
    imagePicker.identifier = identifier;
    
    return imagePicker;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.statusStyle;
}


- (void)setStatusStyle:(UIStatusBarStyle)statusStyle
{
    if (statusStyle == _statusStyle) {
        return;
    }
    
    _statusStyle = statusStyle;
    [self preferredStatusBarUpdateAnimation];
}

@end
