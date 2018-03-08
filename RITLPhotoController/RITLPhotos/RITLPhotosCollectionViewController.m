//
//  RITLPhotosItemsCollectionViewController.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/3/7.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "RITLPhotosCollectionViewController.h"
#import "RITLPhotoPreviewController.h"

#import "RITLPhotosCell.h"

#import "PHAsset+RITLPhotos.h"
#import "NSString+RITLPhotos.h"

#import <RITLKit.h>
#import <Masonry.h>
#import <Photos/Photos.h>

@interface RITLPhotosCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIViewControllerPreviewingDelegate>

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)PHAssetCollection *assetCollection;
@property (nonatomic, strong)PHFetchResult <PHAsset *> *assets;

@end

@implementation RITLPhotosCollectionViewController

static NSString *const reuseIdentifier = @"photo";

+ (RITLPhotosCollectionViewController *)photosCollectionController
{
    return RITLPhotosCollectionViewController.new;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // NavigationItem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancle" style:UIBarButtonItemStyleDone target:self action:@selector(dismissPhotoControllers)];
    
    
    // Register cell classes
    [self.collectionView registerClass:[RITLPhotosCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    [self.view addSubview:self.collectionView];
    
    // Layout
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.bottom.offset(0);
    }];
    
//    self.collectionView.dataSource = self;
//    self.collectionView.delegate = self;
    
    //加载数据
    if (!self.localIdentifier) { return; }
    
    //加载
    self.assetCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[self.localIdentifier] options:nil].firstObject;
    
    self.assets = [PHAsset fetchAssetsInAssetCollection:self.assetCollection options:nil];
    
    //reload
    [self.collectionView reloadData];
    
    if (self.assets.count < 1) { return; }
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        //进行滚动
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.assets.count - 1 inSection:0]atScrollPosition:UICollectionViewScrollPositionBottom animated:false];
        
    });
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Dismiss

- (void)dismissPhotoControllers
{
    if(self.navigationController.presentingViewController){//如果是模态弹出
        
        [self.navigationController dismissViewControllerAnimated:true completion:nil];
        
    }else if(self.navigationController){
        
        [self.navigationController popViewControllerAnimated:true];
    }
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets ? self.assets.count : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RITLPhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    //Asset
    PHAsset *asset = [self.assets objectAtIndex:indexPath.item];
    
    //Size
    CGSize size = [self collectionView:collectionView layout:collectionView.collectionViewLayout sizeForItemAtIndexPath:indexPath];
    
    // Configure the cell
    [asset ritl_imageWithSize:size complete:^(UIImage * _Nullable image, PHAsset * _Nonnull asset, NSDictionary * _Nonnull info) {
        
        cell.imageView.image = image;
        
        //设置时长
        cell.messageView.hidden = (asset.mediaType == PHAssetMediaTypeImage);
        
        if (cell.messageView.hidden) { return; }
        
        cell.messageLabel.text = [NSString timeStringWithTimeDuration:asset.duration];
    }];
    
    //注册3D Touch
    if (@available(iOS 9.0,*)) {
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable){
            
            [self registerForPreviewingWithDelegate:self sourceView:cell];
        }
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat sizeHeight = (collectionView.ritl_width - 3.0f * 3) / 4;
    
    return CGSizeMake(sizeHeight, sizeHeight);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 3.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 3.f;
}

#pragma mark - <UIViewControllerPreviewingDelegate>
//#warning 会出现内存泄露，临时不使用
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    //获取当前cell的indexPath
    NSIndexPath * indexPath = [self.collectionView indexPathForCell:(RITLPhotosCell *)previewingContext.sourceView];
    
    NSUInteger item = indexPath.item;
    
    //获得当前的资源
    PHAsset *asset = self.assets[item];
    
    if (asset.mediaType != PHAssetMediaTypeImage)
    {
        return nil;
    }
    
    RITLPhotoPreviewController * viewController = [RITLPhotoPreviewController previewWithShowAsset:asset];
    
    return viewController;
}


- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    //获取当前cell的indexPath
//    NSIndexPath * indexPath = [self.collectionView indexPathForCell:(RITLPhotosCell *)previewingContext.sourceView];
    
    
//    [self.viewModel didSelectItemAtIndexPath:indexPath];
}

#pragma mark -

-(UICollectionView *)collectionView
{
    if(_collectionView == nil)
    {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
        
        //protocol
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        //
        _collectionView.allowsMultipleSelection = true;
        
//#ifdef __IPHONE_10_0
//        if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0f)
//        {
//            _collectionView.prefetchDataSource = self;
//        }
        
//#endif
        
        //property
        _collectionView.backgroundColor = [UIColor whiteColor];
        
//        //register View
//        [_collectionView registerClass:[RITLPhotosCell class] forCellWithReuseIdentifier:cellIdentifier];
//        [_collectionView registerClass:[RITLPhotoBottomReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reusableViewIdentifier];
    }
    
    return _collectionView;
}

@end
