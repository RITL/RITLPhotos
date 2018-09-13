//
//  NSArray+RITLPhotos.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/9/7.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "NSArray+RITLPhotos.h"
#import <RITLKit/RITLKit.h>

@implementation NSArray (RITLPhotos)

- (NSArray<PHAssetCollection *> *)sortRegularAblumsWithUserLibraryFirst
{
    //进行排序
    NSMutableArray <PHAssetCollection *> *sortCollections = [NSMutableArray arrayWithArray:self];
    
    //选出对象
    PHAssetCollection *userLibrary = [self ritl_filter:^BOOL(PHAssetCollection * _Nonnull item) {
        
        return (item.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary);
        
    }].ritl_safeFirstObject;
    
    if (userLibrary) {
        
        //进行变换
        [sortCollections removeObject:userLibrary];
        [sortCollections insertObject:userLibrary atIndex:0];
    }
    
    return sortCollections;
}


@end
