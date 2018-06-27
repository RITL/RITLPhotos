//
//  RITLPhotosMaker.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/5/18.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "RITLPhotosMaker.h"
#import "RITLPhotosDataManager.h"
#import <Photos/Photos.h>

@interface RITLPhotosMaker ()

//@property (nonatomic, copy, nullable)RITLCompleteReaderHandle complete;
@property (nonatomic, strong) PHImageManager *imageManager;

@end

@implementation RITLPhotosMaker

- (instancetype)init
{
    if (self = [super init]) {
        
        self.thumbnailSize = CGSizeZero;
    }
    
    return self;
}

+ (instancetype)sharedInstance
{
    static __weak RITLPhotosMaker *instance;
    RITLPhotosMaker *strongInstance = instance;
    @synchronized(self){
        if (strongInstance == nil) {
            strongInstance = self.new;
            instance = strongInstance;
        }
    }
    return strongInstance;
}

/// 开始执行各种方法
- (void)startMakePhotosComplete:(RITLCompleteReaderHandle)complete
{
    if (!self.delegate) { return; }//代理对象不存在
    
    //identifers
    [self identifersCallBack];
    //assets
    [self assetsCallBack];
    //thumbnailImages
    [self thumbnailImagesCallBack];
    //images
    [self imagesCallBack];
    //data
    [self dataCallBack];
    
    if (complete) { complete(); }//OK
}


#pragma mark - 代理方法

- (void)identifersCallBack
{
    if ([self.delegate respondsToSelector:@selector(photosViewController:assetIdentifiers:)]) {
        
        [self.delegate photosViewController:self.bindViewController
                           assetIdentifiers:RITLPhotosDataManager.sharedInstance.assetIdentiers];
    }
}

- (void)assetsCallBack
{
    if ([self.delegate respondsToSelector:@selector(photosViewController:assets:)]) {
        
        [self.delegate photosViewController:self.bindViewController assets:RITLPhotosDataManager.sharedInstance.assets];
    }
}

- (void)thumbnailImagesCallBack
{
    if (CGSizeEqualToSize(self.thumbnailSize, CGSizeZero)) { return; }//不使用缩略图
    if (![self.delegate respondsToSelector:@selector(photosViewController:thumbnailImages:)]) { return; }//不存在该代理方法
    
    //选中的资源对象
    NSArray <PHAsset *> *assets = RITLPhotosDataManager.sharedInstance.assets;
    
    //获得所有的图片资源
    __block NSMutableArray <UIImage *> *thumbnailImages = [NSMutableArray arrayWithCapacity:assets.count];
    
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    options.synchronous = true;
    
    //进行图片请求
    for (PHAsset *asset in assets) {
        
        [self.imageManager requestImageForAsset:asset targetSize:self.thumbnailSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
           
            [thumbnailImages addObject:result];
        }];
    }
    
    [self.delegate photosViewController:self.bindViewController thumbnailImages:thumbnailImages];
}


- (void)imagesCallBack
{
    if (![self.delegate respondsToSelector:@selector(photosViewController:images:)]) { return; }//不存在该代理方法
    
    //选中的资源对象
    NSArray <PHAsset *> *assets = RITLPhotosDataManager.sharedInstance.assets;
    
    //获得所有的图片资源
    __block NSMutableArray <UIImage *> *images = [NSMutableArray arrayWithCapacity:assets.count];
    
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    options.synchronous = true;
    
    //进行图片请求
    for (PHAsset *asset in assets) {
        
        [self.imageManager requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            [images addObject:result];
        }];
    }
    
    [self.delegate photosViewController:self.bindViewController images:images];
}


- (void)dataCallBack
{
    if (![self.delegate respondsToSelector:@selector(photosViewController:datas:)]) { return; }//不存在该代理方法
    
    //选中的资源对象
    NSArray <PHAsset *> *assets = RITLPhotosDataManager.sharedInstance.assets;
    
    //是否为原图
    BOOL hightQuality = RITLPhotosDataManager.sharedInstance.isHightQuality;
    
    //获得所有的图片资源
    __block NSMutableArray <NSData *> *datas = [NSMutableArray arrayWithCapacity:assets.count];
    
    PHImageRequestOptions *options = PHImageRequestOptions.new;
    options.deliveryMode = hightQuality ? PHImageRequestOptionsDeliveryModeHighQualityFormat : PHImageRequestOptionsDeliveryModeOpportunistic;
    
    for (PHAsset *asset in assets) {
        
        [self.imageManager requestImageDataForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
           
            [datas addObject:imageData];
        }];
    }
    
    [self.delegate photosViewController:self.bindViewController datas:datas];
}


- (void)dealloc
{
    NSLog(@"[%@] is dealloc",NSStringFromClass(self.class));
}


- (PHImageManager *)imageManager
{
    if (PHPhotoLibrary.authorizationStatus == PHAuthorizationStatusAuthorized && !_imageManager) {
        
        _imageManager = PHImageManager.new;
    }
    
    return _imageManager;
}


@end
