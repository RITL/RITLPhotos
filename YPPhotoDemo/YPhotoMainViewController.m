//
//  ViewController.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/13.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "YPhotoMainViewController.h"
#import "YPPhotosCell.h"
#import "PHObject+SupportCategory.h"
#import "YPPhotoNavgationController.h"

@interface YPhotoMainViewController ()
//<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

//@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) CGSize assetSize;
@property (nonatomic, copy)NSArray <PHAsset *> * assets;

@end

@implementation YPhotoMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//    _collectionView.delegate = self;
//    _collectionView.dataSource = self;
//    _collectionView.backgroundColor = [UIColor cyanColor];
    
    
    CGFloat sizeHeight = (self.view.frame.size.width - 3) / 4;
    _assetSize = CGSizeMake(sizeHeight, sizeHeight);
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)photosItemDidTap:(id)sender
{
    
    YPPhotoNavgationController * photoViewControlelr = [[UIStoryboard storyboardWithName:@"YPPhotoGroup" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    
//    __weak typeof(self)weakSelf = self;
    
    photoViewControlelr.photosDidSelectBlock = ^(NSArray <PHAsset *> * assets,NSArray <NSNumber *> * status){
        
//        weakSelf.assets = assets;
//        [weakSelf.collectionView reloadData];
        
        NSLog(@"%@",assets);
        NSLog(@"%@",status);
        
    };
    
    [self presentViewController:photoViewControlelr animated:true completion:^{}];
}

//
//#pragma mark - <UICollectionDataSource>
//#pragma mark <UICollectionViewDataSource>
//
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    
//    return 1;
//}
//
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    
//    return self.assets.count;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    YPPhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YPPhotosCell class]) forIndexPath:indexPath];
//    
//    /**********避免block中进行retail影响对象释放，造成内存泄露*********/
//    __weak typeof(YPPhotosCell *)copy_cell = cell;
//    /**********end*********/
//    
//    
//    [((PHAsset *)[self.assets objectAtIndex:indexPath.row]) representationImageWithSize:_assetSize complete:^(UIImage * _Nullable image, PHAsset * _Nonnull asset) {
//        
//        copy_cell.imageView.image = image;
//        
//    }];
//    
//    return cell;
//}
//
//#pragma mark - <UICollectionViewDelegateFlowLayout>
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return self.assetSize;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 1.0f;
//}
//
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 1.0f;
//}


@end
