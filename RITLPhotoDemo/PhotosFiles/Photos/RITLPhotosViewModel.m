//
//  RITLPhotosViewModel.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/11/29.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLPhotosViewModel.h"
#import "RITLPhotoStore.h"

@implementation RITLPhotosViewModel



-(void)setAssetCollection:(PHAssetCollection *)assetCollection
{
    _assetCollection = assetCollection;
    
    _assetResult = [RITLPhotoStore fetchPhotos:assetCollection];
}






-(NSString *)title
{
    if (!_navigationTitle)
    {
        return @"";
    }
    
    return _navigationTitle;
}

@end
