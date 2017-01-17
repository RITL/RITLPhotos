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
    
    BOOL isIgnore = (imageSize.width == -100);
    
    //获得当前的高清图否
    BOOL isHightQuarity = [RITLPhotoCacheManager sharedInstace].isHightQuarity;
    

    [RITLPhotoRequestStore imagesWithAssets:assets status:isHightQuarity Size:imageSize ignoreSize:isIgnore complete:^(NSArray<UIImage *> * _Nonnull images) {
        
        //进行回调
        if (self.RITLBridgeGetImageBlock)
        {
            self.RITLBridgeGetImageBlock(images);
        }
    }];
    
    
    if (self.RITLBridgeGetImageDataBlock)
    {
        //请求数据
        [RITLPhotoRequestStore dataWithAssets:assets status:isHightQuarity complete:^(NSArray<NSData *> * _Nonnull datas) {
           
            self.RITLBridgeGetImageDataBlock(datas);
            
        }];
    }
    
    

}

@end
