//
//  ViewController.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/13.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "RITLPhotoMainViewController.h"
#import "RITLPhotosViewController.h"
#import "RITLPhotosCell.h"
#import <Photos/Photos.h>
#import <RITLKit/RITLKit.h>


@interface RITLPhotoMainViewController ()
<UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
RITLPhotosViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, assign) CGSize assetSize;
@property (nonatomic, copy)NSArray <UIImage *> * assets;
@property (nonatomic, copy)NSArray <NSString *> *saveAssetIds;

@end

@implementation RITLPhotoMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat sizeHeight = (self.collectionView.frame.size.width - 3.0) / 4;
    _assetSize = CGSizeMake(sizeHeight, sizeHeight);
    
    [self.view addSubview:self.collectionView];
    
}

- (IBAction)refresh:(id)sender
{
    self.assets = @[];
    [self.collectionView reloadData];
}

- (IBAction)photosItemDidTap:(id)sender
{
    RITLPhotosViewController *photoController = RITLPhotosViewController.photosViewController;
    photoController.configuration.maxCount = 5;//最大的选择数目
    photoController.configuration.containVideo = false;//选择类型，目前只选择图片不选择视频
    photoController.configuration.hiddenGroupWhenNoPhotos = true;//当相册不存在照片的时候隐藏
    photoController.photo_delegate = self;
    photoController.thumbnailSize = self.assetSize;//缩略图的尺寸
    photoController.defaultIdentifers = self.saveAssetIds;//记录已经选择过的资源
    
    [self presentViewController:photoController animated:true completion:^{}];
}


#pragma mark - RITLPhotosViewControllerDelegate
/**** 为了提高相关性能，如果用不到的代理方法，不需要多实现  ****/

/**
 选中图片以及视频等资源的本地identifer
 可用于设置默认选好的资源
 
 @param viewController RITLPhotosViewController
 @param identifiers 选中资源的本地标志位
 */
- (void)photosViewController:(UIViewController *)viewController
            assetIdentifiers:(NSArray <NSString *> *)identifiers
{
    self.saveAssetIds = identifiers;
//    NSLog(@"%@", NSStringFromSelector(_cmd));
}

/**
 Deprecated
 选中图片以及视频等资源的默认缩略图
 根据thumbnailSize设置所得，如果thumbnailSize为.Zero,则不进行回调
 与是否原图无关
 
 @param viewController RITLPhotosViewController
 @param thumbnailImages 选中资源的缩略图
 */
//- (void)photosViewController:(UIViewController *)viewController
//             thumbnailImages:(NSArray <UIImage *> *)thumbnailImages
//{
//    self.assets = thumbnailImages;
//    [self.collectionView reloadData];
//}


/**
 选中图片以及视频等资源的默认缩略图
 根据thumbnailSize设置所得，如果thumbnailSize为.Zero,则不进行回调
 与是否原图无关
 
 @param viewController RITLPhotosViewController
 @param thumbnailImages 选中资源的缩略图
 @param infos 选中资源的缩略图的相关信息
 */
- (void)photosViewController:(UIViewController *)viewController thumbnailImages:(NSArray<UIImage *> *)thumbnailImages infos:(NSArray<NSDictionary *> *)infos
{
    self.assets = thumbnailImages;
    [self.collectionView reloadData];
    
//    NSLog(@"%@",infos);
//    NSLog(@"%@", NSStringFromSelector(_cmd));

}


/**
 Deprecated
 选中图片以及视频等资源的原比例图片
 适用于不使用缩略图，或者展示高清图片
 与是否原图无关
 
 @param viewController RITLPhotosViewController
 @param images 选中资源的原比例图
 */
//- (void)photosViewController:(UIViewController *)viewController
//                      images:(NSArray <UIImage *> *)images
//{
//    //获得原比例的图片
//
//}


/**
 选中图片以及视频等资源的原比例图片
 适用于不使用缩略图，或者展示高清图片
 与是否原图无关
 
 @param viewController RITLPhotosViewController
 @param images 选中资源的原比例图
 @param infos 选中资源的原比例图的相关信息
 */
- (void)photosViewController:(UIViewController *)viewController images:(NSArray<UIImage *> *)images infos:(NSArray<NSDictionary *> *)infos
{
    //获得原比例的图片
//    NSLog(@"%@", NSStringFromSelector(_cmd));

}



/**
 选中图片以及视频等资源的数据
 根据是否选中原图所得
 如果为原图，则返回原图大小的数据
 如果不是原图，则返回原始比例的数据
 注: 不会返回thumbnailImages的数据大小
 
 @param viewController RITLPhotosViewController
 @param datas 选中资源的数据
 */
- (void)photosViewController:(UIViewController *)viewController
                       datas:(NSArray <NSData *> *)datas
{
    NSLog(@"%@ - datas: %lu", NSStringFromSelector(_cmd),(unsigned long)datas.count);

}

/**
 选中图片以及视频等资源的源资源对象
 如果需要使用源资源对象进行相关操作，请实现该方法
 
 @param viewController RITLPhotosViewController
 @param assets 选中的源资源
 */
- (void)photosViewController:(UIViewController *)viewController
                      assets:(NSArray <PHAsset *> *)assets
{
//    NSLog(@"%@", NSStringFromSelector(_cmd));

}



- (void)photosViewControllerWillDismiss:(UIViewController *)viewController {
    NSLog(@"\n\n\n\n %@ is dismiss \n\n\n\n",viewController);
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RITLPhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.chooseButton.hidden = true;
    
    //设置属性
    cell.imageView.image = self.assets[indexPath.item];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.assetSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}


-(UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:[UICollectionViewFlowLayout new]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = RITLColorFromRGB(0xF6FFB7);
        
        [_collectionView registerClass:[RITLPhotosCell class] forCellWithReuseIdentifier:@"Cell"];
    }
    
    return _collectionView;
}


@end
