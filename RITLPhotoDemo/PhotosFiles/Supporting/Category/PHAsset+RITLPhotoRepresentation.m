//
//  PHAsset+RITLPhotoRepresentation.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "PHAsset+RITLPhotoRepresentation.h"
#import <objc/runtime.h>

#import "PHImageRequestOptions+RITLPhotoRepresentation.h"

@implementation PHAsset (RITLPhotoRepresentation)

- (NSMutableArray *)catcheArray
{
    return objc_getAssociatedObject(self, &@selector(catcheArray));
}

- (void)setCatcheArray:(NSMutableArray *)newArray
{
    objc_setAssociatedObject(self, &@selector(catcheArray), newArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)highQualityArray
{
    return objc_getAssociatedObject(self, &@selector(highQualityArray));
}

- (void)setHighQualityArray:(NSMutableArray *)newArray
{
    objc_setAssociatedObject(self, &@selector(highQualityArray), newArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)hignSizeArray
{
    return objc_getAssociatedObject(self, &@selector(hignSizeArray));
}

- (void)setHignSizeArray:(NSMutableArray *)newArray
{
    objc_setAssociatedObject(self, &@selector(hignSizeArray), newArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



-(void)representationImageWithSize:(CGSize)size complete:(nonnull void (^)(UIImage * _Nullable, PHAsset * _Nonnull))completeBlock
{
    __weak typeof(self)copy_self = self;
    
    if (copy_self.catcheArray == nil)
    {
        copy_self.catcheArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize newSize = CGSizeMake(size.width * scale, size.height * scale);
    
    
    [[PHCachingImageManager defaultManager]requestImageForAsset:copy_self targetSize:newSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        completeBlock(result,copy_self);
        
    }];
    
    if (![copy_self.catcheArray containsObject:[NSValue valueWithCGSize:size]])
    {
        //start catch
        [((PHCachingImageManager *)[PHCachingImageManager defaultManager])startCachingImagesForAssets:@[copy_self] targetSize:newSize contentMode:PHImageContentModeAspectFill options:nil];
        
        [copy_self.catcheArray addObject:[NSValue valueWithCGSize:newSize]];
    }
    
}


-(void)sizeOfHignQualityWithSize:(CGSize)size complete:(void (^)(NSString * _Nonnull))completeBlock
{
    CGSize newSize = size;
    
    if (!self.highQualityArray)
    {
        self.highQualityArray = [NSMutableArray arrayWithCapacity:0];
        self.hignSizeArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    
    if ([self.highQualityArray containsObject:[NSValue valueWithCGSize:newSize]])
    {
        //获得当前的index
        NSUInteger index = [self.highQualityArray indexOfObject:[NSValue valueWithCGSize:newSize]];
        
        //直接返回大小
        NSString * sizeRerturn = self.hignSizeArray[index];
        
        completeBlock(sizeRerturn);return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    //初始化option选项
    PHImageRequestOptions * option = [PHImageRequestOptions imageRequestOptionsWithDeliveryMode:PHImageRequestOptionsDeliveryModeHighQualityFormat];
    
    [[PHCachingImageManager defaultManager]requestImageDataForAsset:self options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        
        NSString * imageSize = sizeWithLength(imageData.length);
        
        //数组进行缓存
        [weakSelf.hignSizeArray addObject:imageSize];
        
        //将大小传出，默认为btye
        completeBlock(imageSize);
        
        
    }];
    
    if (![self.highQualityArray containsObject:[NSValue valueWithCGSize:newSize]])
    {
        //进行大小缓存
        [weakSelf.highQualityArray addObject:[NSValue valueWithCGSize:newSize]];
    }
    
    
}


-(void)dealloc
{
    for (NSValue * value in self.catcheArray)
    {
        //cancle the caching
        [((PHCachingImageManager *)[PHCachingImageManager defaultManager])stopCachingImagesForAssets:@[self] targetSize:value.CGSizeValue contentMode:PHImageContentModeAspectFill options:nil];
    }
    
    objc_removeAssociatedObjects(self);
}


@end
