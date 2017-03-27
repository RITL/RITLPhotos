//
//  PHAssetCollection+RITLPhotoRepresentation.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "PHAssetCollection+RITLPhotoRepresentation.h"
#import <objc/runtime.h>

@implementation PHAssetCollection (RITLPhotoRepresentation)

-(void)representationImageWithSize:(CGSize)size complete:(nonnull void (^)(NSString * _Nonnull, NSUInteger, UIImage * _Nullable))completeBlock
{
//    __weak typeof(self) copy_self = self;
    
    //获取照片资源
    PHFetchResult * assetResult = [PHAsset fetchAssetsInAssetCollection:self options:nil];
    
    NSUInteger count = assetResult.count;
    
    if (assetResult.count == 0)
    {
        completeBlock(self.localizedTitle,0,[UIImage new]);return;
    }
    
    UIImage * representationImage = objc_getAssociatedObject(self, &@selector(representationImageWithSize:complete:));
    
    
    if (representationImage != nil)
    {
        completeBlock(self.localizedTitle,count,representationImage);return;
    }
    
    //获取屏幕的点
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize newSize = CGSizeMake(size.width * scale, size.height * scale);
    
    //开始截取照片
    [[PHCachingImageManager defaultManager] requestImageForAsset:assetResult.lastObject targetSize:newSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        objc_setAssociatedObject(self, &@selector(representationImageWithSize:complete:), result, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        //block to trans image
        completeBlock(self.localizedTitle,count,result);
        
    }];
}


-(void)dealloc
{
    objc_setAssociatedObject(self, &@selector(representationImageWithSize:complete:), nil, OBJC_ASSOCIATION_ASSIGN);
    objc_removeAssociatedObjects(self);
}

@end
