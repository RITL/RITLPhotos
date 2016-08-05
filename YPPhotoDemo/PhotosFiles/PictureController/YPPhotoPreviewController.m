//
//  YPPhotoPreviewController.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/8/5.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "YPPhotoPreviewController.h"
#import "PHObject+SupportCategory.h"

@interface YPPhotoPreviewController ()

@property (nonatomic, strong)UIImageView * imageView;

@end

@implementation YPPhotoPreviewController

-(instancetype)initWithShowAsset:(PHAsset *)showAsset
{
    if (self = [super init])
    {
        _showAsset = showAsset;
    }
    
    return self;
}


+(instancetype)previewWithShowAsset:(PHAsset *)showAsset
{
    return [[self alloc]initWithShowAsset:showAsset];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    
    _assetSize = CGSizeMake(screenBounds.size.width + 10, screenBounds.size.height);
    
    [self.view addSubview:self.imageView];
    
    __weak typeof(self) weakSelf = self;
    
    //获取图片
    [_showAsset representationImageWithSize:_assetSize complete:^(UIImage * _Nullable image, PHAsset * _Nonnull asset) {
        

        //初始化ImageView
        weakSelf.imageView.image = image;
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"%@ Dealloc",NSStringFromClass([self class]));
}

#pragma mark - Getter

-(UIImageView *)imageView
{
    if (_imageView == nil)
    {
        _imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _imageView.backgroundColor = [UIColor yellowColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.cornerRadius = 8;
    }
    
    return _imageView;
}

@end
