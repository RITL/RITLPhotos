//
//  RITLPhotoBridgeManager.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/12/29.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "RITLPhotoBridgeManager.h"
#import "RITLPhotoRequestStore.h"
#import "RITLPhotoCacheManager.h"
#import "RITLPhotoNavigationViewModel.h"

@implementation RITLPhotoBridgeManager


+(instancetype)sharedInstance
{
    static RITLPhotoBridgeManager * bridgeManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        bridgeManager = [self new];
        
    });
    
    return bridgeManager;
}



-(void)startRenderImage:(NSArray<PHAsset *> *)assets
{
    //获得想要的size
    CGSize imageSize =  [RITLPhotoCacheManager sharedInstace].imageSize;
    
    BOOL isIgnore = (imageSize.width == -100);//表示是原来的比例
    
    //获得当前的高清图否
    BOOL isHightQuarity = [RITLPhotoCacheManager sharedInstace].isHightQuarity;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ritl_bridgeGetAsset:)]) {
        
        [self.delegate ritl_bridgeGetAsset:assets];
    }
    
    
    if (self.RITLBridgeGetAssetBlock) {
        
        self.RITLBridgeGetAssetBlock(assets);
    }
    
    
    //获得设置的图片大小
    CGSize customImageSize = RITLPhotoCacheManager.sharedInstace.imageSize;
    
    //返回缩略图
    if (!isIgnore) {
        
        [RITLPhotoRequestStore imagesWithAssets:assets status:false Size:customImageSize ignoreSize:false complete:^(NSArray<UIImage *> * _Nonnull thumImages) {
           
            if (self.delegate && [self.delegate respondsToSelector:@selector(ritl_bridgeGetThumImage:)]) {
                
                [self.delegate ritl_bridgeGetThumImage:thumImages];
            }
        }];
    }

    
    
    [RITLPhotoRequestStore imagesWithAssets:assets status:isHightQuarity Size:imageSize ignoreSize:true complete:^(NSArray<UIImage *> * _Nonnull images) {
        
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(ritl_bridgeGetImage:)]) {
            
            [self.delegate ritl_bridgeGetImage:images];

        }
        
        if (isIgnore && self.delegate && [self.delegate respondsToSelector:@selector(ritl_bridgeGetThumImage:)]) {
            
            [self.delegate ritl_bridgeGetThumImage:images];
        }
        
        //进行回调
        if (self.RITLBridgeGetImageBlock)
        {
            self.RITLBridgeGetImageBlock(images);
        }
    }];
    
    
    
    if (self.RITLBridgeGetImageDataBlock || (self.delegate && [self.delegate respondsToSelector:@selector(ritl_bridgeGetImageData:)]))
    {
        //请求数据
        [RITLPhotoRequestStore dataWithAssets:assets status:isHightQuarity complete:^(NSArray<NSData *> * _Nonnull datas) {
           
            if ((self.delegate && [self.delegate respondsToSelector:@selector(ritl_bridgeGetImageData:)])) {
                
                [self.delegate ritl_bridgeGetImageData:datas];
            }
            
            else if(self.RITLBridgeGetImageDataBlock) {
                
                self.RITLBridgeGetImageDataBlock(datas);
            }
        }];
    }
}

@end
