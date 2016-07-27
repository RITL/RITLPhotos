//
//  YPPhotoStore.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/13.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "YPPhotoStore.h"
#import "YPPhotoStoreConfiguraion.h"
#import "PHObject+SupportCategory.h"

typedef void(^PHAssetCollectionBlock)(NSArray<PHAssetCollection *> * groups);

@interface YPPhotoStore ()

@property (nonatomic, strong) PHPhotoLibrary * photoLibaray;

@end


@implementation YPPhotoStore

-(instancetype)init
{
    if (self = [super init])
    {
        self.photoLibaray = [PHPhotoLibrary sharedPhotoLibrary];
        [self.photoLibaray registerChangeObserver:self];
        
        _config = [[YPPhotoStoreConfiguraion alloc]init];
    }
    
    return self;
}

-(instancetype)initWithConfiguration:(YPPhotoStoreConfiguraion *)configuration
{
    if (self = [self init])
    {
        _config = configuration;
    }
    
    return self;
}

+(instancetype)storeWithConfiguration:(YPPhotoStoreConfiguraion *)configuration
{
    return [[self alloc] initWithConfiguration:configuration];
}


-(void)dealloc
{
    [self.photoLibaray unregisterChangeObserver:self];
}


#pragma mark - 相册组
-(void)fetchBasePhotosGroup:(void(^)( PHFetchResult * _Nullable  result))completeBlock
{
//    switch ([PHPhotoLibrary authorizationStatus])
//    {
//        case PHAuthorizationStatusNotDetermined:
//        {
//            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
//               
//                if (status == PHAuthorizationStatusAuthorized)
//                {
                    completeBlock([PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil]);
//                }
//                
//            }];
//        }
//            break;
//        
//        case PHAuthorizationStatusAuthorized:completeBlock([PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil]);break;
//            
//        case PHAuthorizationStatusRestricted:
//        case PHAuthorizationStatusDenied:
//            completeBlock(nil);
//            break;
//    }
}


- (void)fetchPhotosGroup:(void (^)(NSArray<PHAssetCollection *> * _Nonnull))groups
{
    [self fetchBasePhotosGroup:^(PHFetchResult * _Nullable result) {
       
        if (result == nil) return;
        
        [result transToArrayComplete:^(NSArray<PHAssetCollection *> * _Nonnull group) {
            
            groups(group);
            
        }];
        
    }];

}


-(void)fetchDefaultPhotosGroup:(void (^)(NSArray<PHAssetCollection *> * _Nonnull))groups
{
    
    __weak typeof(self) weakSelf = self;
    
    [self fetchBasePhotosGroup:^(PHFetchResult * _Nullable result) {
       
        if (result == nil) return;
        
        [weakSelf preparationWithFetchResult:result complete:^(NSArray<PHAssetCollection *> * _Nonnull defalutGroup) {
           
            groups(defalutGroup);
            
        }];
        
    }];
}


-(void)fetchDefaultAllPhotosGroup:(void (^)(NSArray<PHAssetCollection *> * _Nonnull))groups
{
    __block NSMutableArray <PHAssetCollection *> * defaultAllGroups = [NSMutableArray arrayWithCapacity:0];
    
    [self fetchDefaultPhotosGroup:^(NSArray<PHAssetCollection *> * _Nonnull defaultGroups) {
       
        [defaultAllGroups addObjectsFromArray:defaultGroups];
        
        //遍历自定义的组
        [[PHCollection fetchTopLevelUserCollectionsWithOptions:[[PHFetchOptions alloc]init]] transToArrayComplete:^(NSArray<PHAssetCollection *> * _Nonnull topLevelArray) {
            
            [defaultAllGroups addObjectsFromArray:topLevelArray];
            
            //callBack with block
            groups([NSArray arrayWithArray:defaultAllGroups]);
            
            defaultAllGroups = nil;
        }];
        
    }];
    
}


#pragma mark - 处理照片
-(void)preparationWithFetchResult:(PHFetchResult<PHAssetCollection *> *)fetchResult complete:(void (^)(NSArray<PHAssetCollection *> * _Nonnull))groups
{
    NSMutableArray <PHAssetCollection *> * preparationCollections = [NSMutableArray arrayWithCapacity:0];
    
    
    [fetchResult enumerateObjectsUsingBlock:^(PHAssetCollection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([_config.groupNamesConfig containsObject:obj.localizedTitle])
        {
            [preparationCollections addObject:obj];
        }
        
        if (idx == fetchResult.count - 1)
        {
            groups([NSArray arrayWithArray:preparationCollections]);
        }
        
    }];
    
}


#pragma mark - 相片
-(PHFetchResult *)fetchPhotos:(PHAssetCollection *)group
{
    return [PHAsset fetchAssetsInAssetCollection:group options:[[PHFetchOptions alloc]init]];
}




#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    NSLog(@"相册发生了变化");
//    //主线程进行回调UI
//    dispatch_async(dispatch_get_main_queue(), ^{
//       
//        
//        
//        
//        
//    });
//    
//    
//    
//    NSUInteger i = 0;
//    i++;
}

@end




