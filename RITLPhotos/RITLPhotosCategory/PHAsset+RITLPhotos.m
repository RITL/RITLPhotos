//
//  PHAsset+RITLPhotos.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "PHAsset+RITLPhotos.h"
#import "PHImageRequestOptions+RITLPhotos.h"
#import <objc/runtime.h>
#import <RITLKit/RITLKit.h>


@implementation PHAsset (RITLPhotos)

#pragma mark - *************** 普通高清 ***************
- (NSMutableDictionary *)normalCache
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNormalCache:(NSMutableDictionary *)set
{
    objc_setAssociatedObject(self, @selector(normalCache), set, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(void)ritl_imageWithSize:(CGSize)size complete:(nonnull void (^)(UIImage * _Nullable, PHAsset * _Nonnull,NSDictionary *info))completeBlock
{
    if (!self.normalCache) {
        self.normalCache = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize newSize = CGSizeMake(size.width * scale, size.height * scale);
    
    [[PHCachingImageManager defaultManager]requestImageForAsset:self targetSize:newSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        completeBlock(result,self,info);
    }];
    
    [self ritl_prefetchImageWithSize:newSize mode:PHImageRequestOptionsDeliveryModeHighQualityFormat options:nil];
}


#pragma mark - *************** 高清 ***************
- (NSMutableDictionary *)highQualitySizeCache
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHighQualitySizeCache:(NSMutableDictionary *)set
{
    objc_setAssociatedObject(self, @selector(highQualitySizeCache), set, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(void)ritl_hignQualityDataSizeComplete:(void (^)(NSString * _Nonnull))completeBlock
{
    if (!self.highQualitySizeCache)
    {
        self.highQualitySizeCache = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    
    NSString *imageSizeString = [self.highQualitySizeCache valueForKey:[NSString stringWithFormat:@"high_%@",self.localIdentifier]];
    
    //获得数据
    if (imageSizeString) {
        
        completeBlock(imageSizeString);
    }

    //初始化option选项
    PHImageRequestOptions * option = [PHImageRequestOptions requestOptionsWithDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
    
    [[PHCachingImageManager defaultManager]requestImageDataForAsset:self options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        
        NSString * imageDataSize = ritl_sizeWithLength(imageData.length);
        
        //数组进行缓存
        [self.highQualitySizeCache setValue:imageDataSize forKey:[NSString stringWithFormat:@"high_%@",self.localIdentifier]];
        
        //将大小传出，默认为btye
        completeBlock(imageDataSize);
        
    }];
}

#pragma mark - *************** fast ***************

- (NSMutableDictionary *)fastformatCache
{
    return objc_getAssociatedObject(self, _cmd);
}


- (void)setFastformatCache:(NSMutableDictionary *)set
{
    objc_setAssociatedObject(self, @selector(fastformatCache), set, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



- (void)ritl_fastFormatImageWithSize:(CGSize)size complete:(void (^)(UIImage * _Nullable, PHAsset * _Nonnull, NSDictionary * _Nonnull))completeBlock
{
    if (!self.fastformatCache) {
        self.fastformatCache = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize newSize = CGSizeMake(size.width * scale, size.height * scale);
    
    PHImageRequestOptions *options = ({
        
        PHImageRequestOptions *options = PHImageRequestOptions.new;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
        options.synchronous = true;
        
        options;
        
    });
    
    [[PHCachingImageManager defaultManager] requestImageForAsset:self targetSize:newSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        completeBlock(result,self,info);
    }];
    
    [self ritl_prefetchImageWithSize:newSize mode:PHImageRequestOptionsDeliveryModeFastFormat options:options];
}



#pragma mark - *************** Catche ***************

- (BOOL)ritl_prefetchImageWithSize:(CGSize)size mode:(PHImageRequestOptionsDeliveryMode)mode options:(nullable PHImageRequestOptions *)options
{
    NSMutableDictionary *cacheDict = nil;
    
    switch (mode){
            
        case PHImageRequestOptionsDeliveryModeFastFormat:{//快速
            cacheDict = self.fastformatCache;
        }
        break;
            
        case PHImageRequestOptionsDeliveryModeOpportunistic:{
            cacheDict = self.normalCache;
        }break;
            
        case PHImageRequestOptionsDeliveryModeHighQualityFormat:break;
    }
    
    //如果存在值
    id cache = [cacheDict valueForKey:NSStringFromCGSize(size)];
    
    if (cache) { /*NSLog(@"已经缓存了");*/ return true; }//表示已经进行了缓存
    
    //进行缓存
    [((PHCachingImageManager *)[PHCachingImageManager defaultManager]) startCachingImagesForAssets:@[self] targetSize:size contentMode:PHImageContentModeAspectFill options:options];
    
    /*NSLog(@"正在缓存");*/
    //追加
    [cacheDict setValue:@"1" forKey:NSStringFromCGSize(size)];
    
    return false;//表示没有过缓存
}

@end


@implementation PHAsset (RITLBrowse)

- (NSString *)ritl_type
{
    if (self.mediaType == PHAssetMediaTypeVideo) { return @"video"; }
    
    else if(self.mediaType == PHAssetMediaTypeImage){
        
        if (@available(iOS 9.1,*)) {
            
            return self.mediaSubtypes == PHAssetMediaSubtypePhotoLive ? @"livephoto" : @"photo";
        }
        
        return @"photo";
    }
    return @"";
}

@end
