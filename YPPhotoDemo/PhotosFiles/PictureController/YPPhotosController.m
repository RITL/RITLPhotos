//
//  YPPhotosController.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/14.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "YPPhotosController.h"
#import "YPPhotosCell.h"
#import "PHObject+SupportCategory.h"
#import "YPPhotoBottomReusableView.h"
#import "YPPhotoBrowerController.h"

#ifdef __IPHONE_9_0
@interface YPPhotosController ()<UIViewControllerPreviewingDelegate,YPPhotoBrowerControllerDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
#else
@interface YPPhotosController ()<YPPhotoBrowerControllerDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
#endif

/// @brief 显示的集合视图
@property (nonatomic, strong) UICollectionView * collectionView;
/// @brief cell‘s size
@property (nonatomic, assign) CGSize assetSize;
/// @brief 所有的照片资源
@property (nonatomic, strong) PHFetchResult * assets;
/// @brief 导航标题
@property (nonatomic, copy) NSString * itemTitle;
/// @brief 对应浏览控制器进行图片控制
@property (nonatomic, strong)NSMutableArray <PHAsset *> * selectAssets;
/// @brief 对应选中图片的状态
@property (nonatomic, strong)NSMutableArray <NSNumber *> * selectAssetStatus;//存储选择的类型:高清还是原图
/// @brief 最大允许的选择数目
@property (nonatomic, strong) NSNumber * maxNumberOfSelectImages;

@end

@implementation YPPhotosController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = _itemTitle;
    _selectAssets = [NSMutableArray arrayWithCapacity:0];
    _selectAssetStatus = [NSMutableArray arrayWithCapacity:0];
    
    //设置navigationItem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(chooseImagesComplete)];

    [self.view addSubview:self.collectionView];

    
    CGFloat sizeHeight = (self.collectionView.frame.size.width - 3) / 4;
    _assetSize = CGSizeMake(sizeHeight, sizeHeight);
    
    if (_assets != nil && _assets.count >= 1) {
        
        //滚动到最后一个
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_assets.count - 1 inSection:0]atScrollPosition:UICollectionViewScrollPositionBottom animated:false];
        
        //重置偏移量
        [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentOffset.y + 64)];
    }
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.assets = nil;
    self.selectAssets = nil;
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
    NSLog(@"YPPhotosController Dealloc");
}


- (void)chooseImagesComplete//click finish buttonItem
{
 
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(photosController:photosSelected:Status:)])
    {
        [self.delegate photosController:self photosSelected:[_selectAssets mutableCopy] Status:[_selectAssetStatus mutableCopy]];;
        _selectAssets = nil;
        _selectAssetStatus = nil;
    }
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
    YPPhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([YPPhotosCell class]) forIndexPath:indexPath];
    
    
#ifdef __IPHONE_9_0
    
//    BOOL isPhoto = (((PHAsset *)[self.assets objectAtIndex:indexPath.row]).mediaType == PHAssetMediaTypeImage);
//    
//    //确定为图片
//    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable || isPhoto == true)
//    {
//        [self registerForPreviewingWithDelegate:self sourceView:cell];
//    }
//    
    
#endif
    
    /**********避免block中进行retail影响对象释放，造成内存泄露*********/
    __weak typeof(YPPhotosCell *)copy_cell = cell;
    __weak typeof(self) copy_self = self;
    __weak typeof(UICollectionView *)weakCollectionView = collectionView;
    /**********end*********/
    
    
    [((PHAsset *)[self.assets objectAtIndex:indexPath.row]) representationImageWithSize:_assetSize complete:^(UIImage * _Nullable image, PHAsset * _Nonnull asset) {

        // Configure the cell
        copy_cell.imageView.image = image;
        
        //如果不是photo类型,隐藏选择标志
        if (asset.mediaType != PHAssetMediaTypeImage)
        {
            copy_cell.chooseImageView.hidden = true;
            copy_cell.messageView.hidden = false;
            copy_cell.messageLabel.text =  [YPPhotosTimeHandleObject timeStringWithTimeDuration:asset.duration];
        }

        else{
            if ([copy_self.selectAssets containsObject:asset]) [copy_cell cellDidSelect];
            else [copy_cell cellDidDeselect];
        }

    }];
    
    cell.imageSelectedBlock = ^(YPPhotosCell * cell){
        
        if (copy_self.selectAssets.count >= copy_self.maxNumberOfSelectImages.unsignedIntegerValue)
        {
            //不再变化状态
            [cell cellDidDeselect];
            
            //alertController提示
            [copy_self alertControllerShouldPresent];
        }
        
        else//此图没有原图选项，所以都为高清
        {
            [copy_self.selectAssets addObject:[copy_self.assets objectAtIndex:[weakCollectionView indexPathForCell:cell].item]];
            [copy_self.selectAssetStatus addObject:[NSNumber numberWithUnsignedInteger:0]];
        }
        
    };
    
    cell.imageDeselectedBlock = ^(YPPhotosCell * cell){
        
        PHAsset * deleteAsset = [copy_self.assets objectAtIndex:[weakCollectionView indexPathForCell:cell].item];
        
        //移除状态位
        [copy_self.selectAssetStatus removeObjectAtIndex:[copy_self.selectAssets indexOfObject:deleteAsset]];
        
        [copy_self.selectAssets removeObject:deleteAsset];
        
    };
    

    return cell;
}


//设置footerView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    YPPhotoBottomReusableView * resuableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([YPPhotoBottomReusableView class]) forIndexPath:indexPath];
    
    resuableView.numberOfAsset = self.assets.count;
    
    return resuableView;
}


#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.assetSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.bounds.size.width, 44);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1.0f;
}

#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (((PHAsset *)[self.assets objectAtIndex:indexPath.row]).mediaType != PHAssetMediaTypeImage) return false;
    
    return true;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转
    YPPhotoBrowerController * viewController = [self createBrowerController:indexPath];
//
    [self.navigationController pushViewController:viewController animated:true];
}



#pragma mark - UIAlertController
- (void)alertControllerShouldPresent
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"你最多只能选择%@张照片",@(_maxNumberOfSelectImages.unsignedIntegerValue)] message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alertController animated:true completion:nil];
}


#pragma mark - <UIViewControllerPreviewingDelegate>

#ifdef __IPHONE_9_0

- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    //获取当前cell的indexPath
    NSIndexPath * indexPath = [self.collectionView indexPathForCell:(YPPhotosCell *)previewingContext.sourceView];
    
    return [self createBrowerController:indexPath];
}


- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    [self showViewController:viewControllerToCommit sender:self];
}
#endif


#pragma mark - CreateViewController
- (YPPhotoBrowerController *)createBrowerController:(NSIndexPath *)indexPath
{
    //跳转
    YPPhotoBrowerController * viewController = [[YPPhotoBrowerController alloc]init];
    
    //设置
    [viewController setValue:self.assets forKey:@"assets"];
    [viewController setValue:(PHAsset *)[self.assets objectAtIndex:indexPath.row] forKey:@"currentAsset"];
    [viewController setValue:self.selectAssets forKey:@"didSelectAssets"];
    [viewController setValue:self.maxNumberOfSelectImages forKey:@"maxNumberOfSelectImages"];
    [viewController setValue:self.selectAssetStatus forKey:@"didSelectAssetStatus"];
    
    viewController.delegate = self;

    return viewController;
}


#pragma mark - <YPPhotoBrowerControllerDelegate>
/** 返回按钮执行的block,用于colletionView更新 */
- (void)photoBrowerControllerShouldBack:(YPPhotoBrowerController *)viewController
{
    [self.collectionView reloadData];
}

/** 点击完成进行的回调 */
- (void)photoBrowerController:(YPPhotoBrowerController *)viewController photosSelected:(nonnull NSArray<PHAsset *> *)photos Status:(nonnull NSArray<NSNumber *> *)status
{
    //执行发送回调
    [self chooseImagesComplete];
}


#pragma mark - Getter Function
-(UICollectionView *)collectionView
{
    if(_collectionView == nil)
    {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
        
        //protocol
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        //property
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        //register View
        [_collectionView registerClass:[YPPhotosCell class] forCellWithReuseIdentifier:@"YPPhotosCell"];
        [_collectionView registerClass:[YPPhotoBottomReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"YPPhotoBottomReusableView"];
    }
    
    return _collectionView;
}



@end




@implementation YPPhotosTimeHandleObject

+(NSString *)timeStringWithTimeDuration:(NSTimeInterval)timeInterval
{
    NSUInteger time = (NSUInteger)timeInterval;
    
    //大于1小时
    if (time >= 60 * 60)
    {
        NSUInteger hour = time / 60 / 60;
        NSUInteger minute = time % 3600 / 60;
        NSUInteger second = time % (3600 * 60);
        
        return [NSString stringWithFormat:@"%.2lu:%.2lu:%.2lu",(unsigned long)hour,(unsigned long)minute,(unsigned long)second];
    }
    
    
    if (time >= 60)
    {
        NSUInteger mintue = time / 60;
        NSUInteger second = time % 60;
        
        return [NSString stringWithFormat:@"%.2lu:%.2lu",(unsigned long)mintue,(unsigned long)second];
    }
    
    return [NSString stringWithFormat:@"00:%.2lu",(unsigned long)time];
}

@end
