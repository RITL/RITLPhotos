//
//  YPPhotoPreviewController.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/8/5.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "RITLPhotoPreviewController.h"
#import "Masonry.h"

#import "PHAsset+RITLPhotoRepresentation.h"

@interface RITLPhotoPreviewController ()

@property (nonatomic, strong)UIImageView * imageView;

@end

@implementation RITLPhotoPreviewController

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
    
//    CGRect screenBounds = [UIScreen mainScreen].bounds;
    
    //获得图片的宽度与高度的比例
    CGFloat scale = _showAsset.pixelHeight * 1.0 / _showAsset.pixelWidth;
    
    _assetSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.width * scale);
    
    //设置当前的大小
    self.preferredContentSize = _assetSize;
    
    //add subview
    [self __addImageView];
    
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
#ifdef RITLDebug
    NSLog(@"%@ Dealloc",NSStringFromClass([self class]));
#endif
}

#pragma mark - Getter

//-(UIImageView *)imageView
//{
//    if (_imageView == nil)
//    {
//        _imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
//        _imageView.backgroundColor = [UIColor yellowColor];
//        _imageView.contentMode = UIViewContentModeScaleToFill;
//        _imageView.layer.cornerRadius = 8;
//    }
//    
//    return _imageView;
//}


- (void)__addImageView
{
    //进行约束布局
    _imageView = [UIImageView new];
    [self.view addSubview:_imageView];
    
    __weak typeof(self) weakSelf = self;
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf.view);
        
    }];
    
    _imageView.backgroundColor = [UIColor yellowColor];
    _imageView.contentMode = UIViewContentModeScaleToFill;
    _imageView.layer.cornerRadius = 8;
}

@end
