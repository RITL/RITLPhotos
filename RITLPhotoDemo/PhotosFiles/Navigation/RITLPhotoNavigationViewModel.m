//
//  RITLPhotoNavigationViewModel.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/11/29.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "RITLPhotoNavigationViewModel.h"
#import "RITLPhotoCacheManager.h"
#import "RITLPhotoBridgeManager.h"

CGSize const RITLPhotoOriginSize = {-100,-100};


@implementation RITLPhotoNavigationViewModel

-(instancetype)init
{
    if (self = [super init])
    {
        self.maxNumberOfSelectedPhoto = 9;
        self.imageSize = RITLPhotoOriginSize;
    }
    
    return self;
}


-(void)setMaxNumberOfSelectedPhoto:(NSUInteger)maxNumberOfSelectedPhoto
{
    _maxNumberOfSelectedPhoto = maxNumberOfSelectedPhoto;
    
    [RITLPhotoCacheManager sharedInstace].maxNumberOfSelectedPhoto = maxNumberOfSelectedPhoto;
}


-(void)setRITLBridgeGetImageBlock:(void (^)(NSArray<UIImage *> * _Nonnull))RITLBridgeGetImageBlock
{
    _RITLBridgeGetImageBlock = RITLBridgeGetImageBlock;
    
    [RITLPhotoBridgeManager sharedInstance].RITLBridgeGetImageBlock = RITLBridgeGetImageBlock;
}


-(void)setRITLBridgeGetImageDataBlock:(void (^)(NSArray<NSData *> * _Nonnull))RITLBridgeGetImageDataBlock
{
    _RITLBridgeGetImageDataBlock = RITLBridgeGetImageDataBlock;
    
    [RITLPhotoBridgeManager sharedInstance].RITLBridgeGetImageDataBlock = RITLBridgeGetImageDataBlock;
}


-(void)setImageSize:(CGSize)imageSize
{
    _imageSize = imageSize;
    
    [RITLPhotoCacheManager sharedInstace].imageSize = imageSize;
}


-(void)dealloc
{
#ifdef RITLDebug
    NSLog(@"Dealloc %@",NSStringFromClass([self class]));
#endif
}

@end
