//
//  YPPhotoPreviewController.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/8/5.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "RITLPhotosPreviewController.h"
#import <Photos/Photos.h>
#import <RITLKit/RITLKit.h>
#import <Masonry/Masonry.h>

@interface RITLPhotosPreviewController ()

@property (nonatomic, strong)PHCachingImageManager *imageManager;
@property (nonatomic, strong)UIImageView *imageView;

@end

@implementation RITLPhotosPreviewController

- (instancetype)init
{
    if (self = [super init]) {
        
        self.imageManager = PHCachingImageManager.new;
    }
    
    return self;
}

-(instancetype)initWithShowAsset:(PHAsset *)showAsset
{
    if (self = [self init]){
        
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
    
    //获得图片的宽度与高度的比例
    CGFloat scale = self.showAsset.pixelHeight * 1.0 / self.showAsset.pixelWidth;
    CGSize assetSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width * scale);
    
    //设置当前的大小
    self.preferredContentSize = assetSize;
    
    //进行约束布局
    self.imageView = [UIImageView new];
    [self.view addSubview:self.imageView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    
    self.imageView.backgroundColor = [UIColor whiteColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.layer.cornerRadius = 8;
    self.imageView.clipsToBounds = true;
    
    [self.imageManager requestImageForAsset:self.showAsset targetSize:@[@(self.showAsset.pixelWidth),@(self.showAsset.pixelHeight)].ritl_size contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
       
        self.imageView.image = result;
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.imageView.image = nil;
    NSLog(@"%@ is dealloc!",NSStringFromClass(self.class));
}


@end
