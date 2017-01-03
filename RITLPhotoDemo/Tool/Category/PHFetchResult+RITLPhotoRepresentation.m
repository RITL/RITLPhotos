//
//  PHFetchResult+RITLPhotoRepresentation.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/30.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "PHFetchResult+RITLPhotoRepresentation.h"

@implementation PHFetchResult (RITLPhotoRepresentation)

@end


@implementation PHFetchResult (RITLAsset)


-(void)preparationWithType:(PHAssetMediaType)mediaType
       matchingObjectBlock:(void(^)(PHAsset *))matchingObjectBlock
      enumerateObjectBlock:(void (^)(PHAsset * _Nonnull))enumerateObjectBlock
                  Complete:(void (^)(NSArray<PHAsset *> * _Nullable))completeBlock
{
    __weak typeof(self) weakSelf = self;
    
    __block NSMutableArray <__kindof PHAsset *> * assets = [NSMutableArray arrayWithCapacity:0];
    
    if (weakSelf.count == 0) {
        
        if (completeBlock)
        {
            completeBlock([NSArray arrayWithArray:assets]);assets = nil;return;
        }
    }
    
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (enumerateObjectBlock)
        {
            enumerateObjectBlock(obj);
        }
        
        
        if (((PHAsset *)obj).mediaType == mediaType)
        {
            if (matchingObjectBlock)
            {
                matchingObjectBlock(obj);
            }
            
            [assets addObject:obj];
        }
        
        if (idx == weakSelf.count - 1)
        {
            if (completeBlock)
            {
                completeBlock([NSArray arrayWithArray:assets]);
            }
        }
    }];
    
}

-(void)preparationWithType:(PHAssetMediaType)mediaType
                  Complete:(void (^)(NSArray<PHAsset *> * _Nonnull))completeBlock
{
    [self preparationWithType:mediaType matchingObjectBlock:nil enumerateObjectBlock:nil Complete:completeBlock];
}

@end


@implementation PHFetchResult (RITLArray)

-(void)transToArrayComplete:(void (^)(NSArray<id> * _Nonnull, PHFetchResult * _Nonnull))arrayObject
{
    {
        __weak typeof(self) weakSelf = self;
        
        NSMutableArray *  array = [NSMutableArray arrayWithCapacity:0];
        
        if (self.count == 0)
        {
            arrayObject([array mutableCopy],weakSelf);
            return;
        }
        
        
        [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [array addObject:obj];
            
            if (idx == self.count - 1)
            {
                arrayObject(array,weakSelf);
            }
            
//            printf("%s idx = %ld\n",NSStringFromClass([obj class]).UTF8String,idx);
            
        }];
    }
}

@end
