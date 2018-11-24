//
//  PHAssetCollection+RITLPhotos.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "PHAssetCollection+RITLPhotos.h"
#import "PHImageRequestOptions+RITLPhotos.h"
#import <objc/runtime.h>

@implementation PHAssetCollection (RITLPhotos)


- (void)ritl_headerImageWithSize:(CGSize)size mode:(PHImageRequestOptionsDeliveryMode)mode complete:(void (^)(NSString * _Nonnull, NSUInteger, UIImage * _Nullable))completeBlock
{
    //获取照片资源
    PHFetchResult * assetResult = [PHAsset fetchAssetsInAssetCollection:self options:nil];
    
    NSUInteger count = assetResult.count;
    
    if (assetResult.count == 0)
    {
        completeBlock(self.localizedTitle,0,[UIImage new]);return;
    }
    
    UIImage * representationImage = objc_getAssociatedObject(self, &@selector(ritl_headerImageWithSize:complete:));
    
    
    if (representationImage != nil)
    {
        completeBlock(self.localizedTitle,count,representationImage);return;
    }
    
    //获取屏幕的点
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize newSize = CGSizeMake(size.width * scale, size.height * scale);
    
    PHImageRequestOptions *options = [PHImageRequestOptions requestOptionsWithDeliveryMode:mode];
    options.networkAccessAllowed = true;
    
    //开始截取照片
    [[PHCachingImageManager defaultManager] requestImageForAsset:assetResult.lastObject targetSize:newSize contentMode:PHImageContentModeAspectFill options:[PHImageRequestOptions requestOptionsWithDeliveryMode:mode] resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        objc_setAssociatedObject(self, &@selector(ritl_headerImageWithSize:complete:), result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        //block to trans image
        completeBlock(self.localizedTitle,count,result);
        
    }];
}



-(void)ritl_headerImageWithSize:(CGSize)size complete:(nonnull void (^)(NSString * _Nonnull, NSUInteger, UIImage * _Nullable))completeBlock
{
//    __weak typeof(self) copy_self = self;
    
    [self ritl_headerImageWithSize:size mode:PHImageRequestOptionsDeliveryModeOpportunistic complete:completeBlock];
}


-(void)dealloc
{
    objc_setAssociatedObject(self, &@selector(ritl_headerImageWithSize:complete:), nil, OBJC_ASSOCIATION_ASSIGN);
    objc_removeAssociatedObjects(self);
}

@end
