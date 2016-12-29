//
//  YPPhotosController.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/14.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLPhotosViewController.h"
#import "RITLPhotosCell.h"
#import "RITLPhotoBottomReusableView.h"
#import "RITLPhotosViewModel.h"

#import "RITLPhotoBrowerController.h"
#import "RITLPhotoBrowerViewModel.h"

#import "UIButton+RITLBlockButton.h"

static NSString * cellIdentifier = @"RITLPhotosCell";
static NSString * reusableViewIdentifier = @"RITLPhotoBottomReusableView";


//#ifdef __IPHONE_10_0
//@interface RITLPhotosViewController ()<UIViewControllerPreviewingDelegate,YPPhotoBrowerControllerDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDataSourcePrefetching>
//#else
//
//#ifdef __IPHONE_9_0
//@interface RITLPhotosViewController ()<UIViewControllerPreviewingDelegate,YPPhotoBrowerControllerDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
//
//#else
@interface RITLPhotosViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
//#endif
//
//#endif

/// @brief 显示的集合视图
@property (nonatomic, strong) UICollectionView * collectionView;
/// @brief 底部的tabBar
@property (nonatomic, strong) UITabBar * bottomBar;
/// @brief 发送按钮
@property (strong, nonatomic) UIButton * sendButton;
/// @brief 显示数目
@property (strong, nonatomic) UILabel * numberOfLabel;
/// @brief 预览按钮
@property (strong, nonatomic) UIButton * bowerButton;

@end

@implementation RITLPhotosViewController


-(instancetype)initWithViewModel:(id<RITLCollectionViewModel>)viewModel
{
    if (self = [super init])
    {
       self.viewModel = viewModel;
    }

    return self;
}


+(instancetype)photosViewModelInstance:(id<RITLCollectionViewModel>)viewModel
{
    return [[self alloc]initWithViewModel:viewModel];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.viewModel.title;
    
    //绑定viewModel
    [self bindViewModel];

    //设置navigationItem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissViewController)];

    //添加视图
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.bottomBar];
    
    
    //获得资源数
    NSUInteger items = [self.viewModel numberOfItemsInSection:0];
  
    if (items >= 1)
    {
        //滚动到最后一个
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:items - 1 inSection:0]atScrollPosition:UICollectionViewScrollPositionBottom animated:false];

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
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
    NSLog(@"YPPhotosController Dealloc");
}



- (void)bindViewModel
{
    if ([self.viewModel isMemberOfClass:[RITLPhotosViewModel class]])
    {
        RITLPhotosViewModel * viewModel = self.viewModel;
        
        __weak typeof(self) weakSelf = self;
 
        // 跳转至预览视图
        viewModel.photoDidTapShouldBrowerBlock = ^(NSArray <PHAsset *> * allPhotoAssets,PHAsset * asset,NSUInteger index){
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            //进入随意一个浏览控制器
//            [strongSelf.navigationController pushViewController:[RITLPhotoBrowerController photosViewModelInstance:nil] animated:true];
            
        };
        
        
        viewModel.photoSendStatusChangedBlock = ^(BOOL enable,NSUInteger count){
          
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            strongSelf.bowerButton.enabled = enable;
            strongSelf.sendButton.enabled = enable;
            
            //设置标签数目
            [strongSelf updateNumbersForSelectAssets:count];
        };
    }
}


//- (void)cancleButtonDidTap//cancle button did tap
//{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(photosControllerShouldBack:)])
//    {
//        [self.delegate photosControllerShouldBack:self];
//        [self.navigationController popViewControllerAnimated:false];
//
//    }
//}

//
//- (void)chooseImagesComplete//click finish buttonItem
//{
// 
//    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(photosController:photosSelected:Status:)])
//    {
//        [self.delegate photosController:self photosSelected:[_selectAssets mutableCopy] Status:[_selectAssetStatus mutableCopy]];;
//        _selectAssets = nil;
//        _selectAssetStatus = nil;
//        [self.navigationController popViewControllerAnimated:false];
//    }
//}


//- (void)bowerButtonDidTap//预览按钮被点击
//{
//    NSLog(@"预览啦!");
//    //跳转
//    YPPhotoBrowerController * viewController = [[YPPhotoBrowerController alloc]init];
//    
//    //设置
//    [viewController setBrowerDataSource:_selectAssets currentAsset:_selectAssets.firstObject didSelectAssets:_selectAssets status:_selectAssetStatus maxNumberOfSelectImages:_maxNumberOfSelectImages];
//    
//    
//    viewController.delegate = self;
//    
//    [self.navigationController pushViewController:viewController animated:true];
//}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.viewModel.numberOfSection;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.viewModel numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RITLPhotosCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if ([self.viewModel isMemberOfClass:[RITLPhotosViewModel class]])
    {
        RITLPhotosViewModel * viewModel = self.viewModel;
        
        // 获得图片对象
        [viewModel imageForIndexPath:indexPath collection:collectionView complete:^(UIImage * _Nonnull image, PHAsset * _Nonnull asset, BOOL isImage) {
            
            cell.imageView.image = image;
            
            cell.chooseControl.hidden = !isImage;
    
        }];

        
        // 响应选择
        cell.chooseImageDidSelectBlock = ^(RITLPhotosCell * cell){
          
            // 修改数据源
            [viewModel didSelectImageAtIndexPath:indexPath];
            
            // 修改UI
            [cell cellSelectedAction:[viewModel imageDidSelectedAtIndexPath:indexPath]];
        };
    }
    
    
    
//    self.viewModel
    
    
#ifdef __IPHONE_9_0
    
//    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
//    {
//        BOOL isPhoto = (((PHAsset *)[self.assets objectAtIndex:indexPath.row]).mediaType == PHAssetMediaTypeImage);
//        
//        //确定为图片
//        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable && isPhoto == true)
//        {
//            [self registerForPreviewingWithDelegate:self sourceView:cell];
//        }
//        
//    }
    

    
#endif
    
//    /**********避免block中进行retail影响对象释放，造成内存泄露*********/
//    __weak typeof(YPPhotosCell *)copy_cell = cell;
//    __weak typeof(self) copy_self = self;
//    __weak typeof(UICollectionView *)weakCollectionView = collectionView;
//    /**********end*********/
//    
    
//    [((PHAsset *)[self.assets objectAtIndex:indexPath.row]) representationImageWithSize:_assetSize complete:^(UIImage * _Nullable image, PHAsset * _Nonnull asset) {
//
//        // Configure the cell
//        copy_cell.imageView.image = image;
//        
//        //如果不是photo类型,隐藏选择标志
//        if (asset.mediaType != PHAssetMediaTypeImage)
//        {
//            copy_cell.chooseImageView.hidden = true;
//            copy_cell.messageView.hidden = false;
//            copy_cell.messageLabel.text =  [RITLPhotosTimeHandleObject timeStringWithTimeDuration:asset.duration];
//        }
//
//        else{
//            if ([copy_self.selectAssets containsObject:asset]) [copy_cell cellDidSelect];
//            else [copy_cell cellDidDeselect];
//        }
//
//    }];
//    
//    cell.imageSelectedBlock = ^(YPPhotosCell * cell){
//        
//        if (copy_self.selectAssets.count >= copy_self.maxNumberOfSelectImages.unsignedIntegerValue)
//        {
//            //不再变化状态
//            [cell cellDidDeselect];
//            
//            //alertController提示
//            [copy_self alertControllerShouldPresent];
//        }
//        
//        else//此图没有原图选项，所以都为高清
//        {
//            [copy_self.selectAssets addObject:[copy_self.assets objectAtIndex:[weakCollectionView indexPathForCell:cell].item]];
//            [copy_self.selectAssetStatus addObject:[NSNumber numberWithUnsignedInteger:0]];
//        }
//        
//        [copy_self setNumbersForSelectAssets:copy_self.selectAssets.count];
//        
//    };
//    
//    cell.imageDeselectedBlock = ^(YPPhotosCell * cell){
//        
//        PHAsset * deleteAsset = [copy_self.assets objectAtIndex:[weakCollectionView indexPathForCell:cell].item];
//        
//        //移除状态位
//        [copy_self.selectAssetStatus removeObjectAtIndex:[copy_self.selectAssets indexOfObject:deleteAsset]];
//        
//        [copy_self.selectAssets removeObject:deleteAsset];
//        
//        [copy_self setNumbersForSelectAssets:copy_self.selectAssets.count];
//        
//    };
//    

    return cell;
}


//设置footerView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    RITLPhotoBottomReusableView * resuableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reusableViewIdentifier forIndexPath:indexPath];

    resuableView.numberOfAsset = ((RITLPhotosViewModel *)self.viewModel).assetCount;
    
    return resuableView;
}


#pragma mark - <UICollectionViewDelegateFlowLayout>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.viewModel sizeForItemAtIndexPath:indexPath inCollection:collectionView];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return [self.viewModel referenceSizeForFooterInSection:section inCollection:collectionView];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return [self.viewModel minimumLineSpacingForSectionAtIndex:section];
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return [self.viewModel minimumInteritemSpacingForSectionAtIndex:section];
}

#pragma mark <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.viewModel shouldSelectItemAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewModel didSelectItemAtIndexPath:indexPath];
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    //是否显示选中标志
    [((RITLPhotosCell *)cell) cellSelectedAction:[((RITLPhotosViewModel *)self.viewModel) imageDidSelectedAtIndexPath:indexPath]];
}


#pragma mark - <UICollectionViewDataSourcePrefetching>

#ifdef __IPHONE_10_0

- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    [self.viewModel prefetchItemsAtIndexPaths:indexPaths];
}

- (void)collectionView:(UICollectionView *)collectionView cancelPrefetchingForItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    [self.viewModel cancelPrefetchingForItemsAtIndexPaths:indexPaths];
}


#endif



//#pragma mark - <UIViewControllerPreviewingDelegate>
//
//#ifdef __IPHONE_9_0
//
//#warning 会出现内存泄露，临时不使用
//- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
//{
//    //获取当前cell的indexPath
//    NSIndexPath * indexPath = [self.collectionView indexPathForCell:(YPPhotosCell *)previewingContext.sourceView];
//    
//    //获得当前的资源
//    PHAsset * asset = (PHAsset *)[_assets objectAtIndex:indexPath.item];
//    
//    YPPhotoPreviewController * viewController = [YPPhotoPreviewController previewWithShowAsset:asset];
//    
////    viewController.assetSize = _assetSize;
//    
//    return viewController;
//}
//
//
//- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
//{
////    //获取当前cell的indexPath
////    NSIndexPath * indexPath = [self.collectionView indexPathForCell:(YPPhotosCell *)previewingContext.sourceView];
////    
////    [self showViewController:[self createBrowerController:indexPath] sender:self];
//}
//#endif


//#pragma mark - CreateViewController
//- (YPPhotoBrowerController *)createBrowerController:(NSIndexPath *)indexPath
//{
//    //跳转
//    YPPhotoBrowerController * viewController = [[YPPhotoBrowerController alloc]init];
//    
//    //设置
//    [viewController setBrowerDataSource:_assets currentAsset:((PHAsset *)[_assets objectAtIndex:indexPath.row]) didSelectAssets:_selectAssets status:_selectAssetStatus maxNumberOfSelectImages:_maxNumberOfSelectImages];
//    
//    viewController.delegate = self;
//
//    return viewController;
//}


//#pragma mark - <YPPhotoBrowerControllerDelegate>
///** 返回按钮执行的block,用于colletionView更新 */
//- (void)photoBrowerControllerShouldBack:(YPPhotoBrowerController *)viewController
//{
////    [self setNumbersForSelectAssets:self.selectAssets.count];
//    [self.collectionView reloadData];
//}
//
///** 点击完成进行的回调 */
//- (void)photoBrowerController:(YPPhotoBrowerController *)viewController photosSelected:(nonnull NSArray<PHAsset *> *)photos Status:(nonnull NSArray<NSNumber *> *)status
//{
//    //执行发送回调
//    [self chooseImagesComplete];
//}
//

#pragma mark - Getter Function
-(UICollectionView *)collectionView
{
    if(_collectionView == nil)
    {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height - 44) collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
        
        //protocol
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
#ifdef __IPHONE_10_0
        if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0f)
        {
            _collectionView.prefetchDataSource = self;
        }
        
#endif
        
        //property
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        //register View
        [_collectionView registerClass:[RITLPhotosCell class] forCellWithReuseIdentifier:cellIdentifier];
        [_collectionView registerClass:[RITLPhotoBottomReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reusableViewIdentifier];
    }
    
    return _collectionView;
}

-(UITabBar *)bottomBar
{
    if (_bottomBar == nil)
    {
        _bottomBar = [[UITabBar alloc]initWithFrame:CGRectMake(0, self.height - 44, self.width, 44)];
        
        //add subviews
        [_bottomBar addSubview:self.sendButton];
        [_bottomBar addSubview:self.numberOfLabel];
        [_bottomBar addSubview:self.bowerButton];
    }
    
    return _bottomBar;
}

-(UIButton *)bowerButton
{
    if (_bowerButton == nil)
    {
        _bowerButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, 60, 30)];
        
        [_bowerButton setTitle:@"预览" forState:UIControlStateNormal];
        [_bowerButton setTitle:@"预览" forState:UIControlStateDisabled];
        
        [_bowerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_bowerButton setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.25] forState:UIControlStateDisabled];
        
        [_bowerButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_bowerButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        _bowerButton.showsTouchWhenHighlighted = true;
        
        //默认不可点击
        _bowerButton.enabled = false;
        
//        [_bowerButton addTarget:self action:@selector(bowerButtonDidTap) forControlEvents:UIControlEventTouchUpInside];
        
        __weak typeof(self) weakSelf = self;
        
        [_bowerButton controlEvents:UIControlEventTouchUpInside handle:^(UIButton * _Nonnull sender) {
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            NSLog(@"预览啦!");
            
        }];
        
        
    }
    return _bowerButton;
}




-(UIButton *)sendButton
{
    if (_sendButton == nil)
    {
        _sendButton = [[UIButton alloc]initWithFrame:CGRectMake(_bottomBar.width - 50 - 5, 0, 50, 40)];
        _sendButton.center = CGPointMake(_sendButton.center.x, _bottomBar.center.y - _bottomBar.originY);
        
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitle:@"发送" forState:UIControlStateDisabled];
        
        [_sendButton setTitleColor:UIColorFromRGB(0x2dd58a) forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColorFromRGB(0x2DD58A) colorWithAlphaComponent:0.25] forState:UIControlStateDisabled];
        
        [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_sendButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        _sendButton.showsTouchWhenHighlighted = true;
        
        //默认为不可点击
        _sendButton.enabled = false;
        
//        [_sendButton addTarget:self action:@selector(chooseImagesComplete) forControlEvents:UIControlEventTouchUpInside];
        
        __weak typeof(self) weakSelf = self;
        
        [_sendButton controlEvents:UIControlEventTouchUpInside handle:^(UIButton * _Nonnull sender) {
           
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            NSLog(@"发送!");
            
        }];
        
    }
    
    return _sendButton;
}

-(UILabel *)numberOfLabel
{
    if (_numberOfLabel == nil)
    {
        _numberOfLabel = [[UILabel alloc]initWithFrame:CGRectMake(_sendButton.originX - 20, 0, 20, 20)];
        _numberOfLabel.center = CGPointMake(_numberOfLabel.center.x, _sendButton.center.y);
        _numberOfLabel.backgroundColor = UIColorFromRGB(0x2dd58a);
        _numberOfLabel.textAlignment = NSTextAlignmentCenter;
        _numberOfLabel.font = [UIFont boldSystemFontOfSize:14];
        _numberOfLabel.text = @"";
        _numberOfLabel.hidden = true;
        _numberOfLabel.textColor = [UIColor whiteColor];
        _numberOfLabel.layer.cornerRadius = _numberOfLabel.width / 2.0;
        _numberOfLabel.clipsToBounds = true;
    }
    
    return _numberOfLabel;
}


-(RITLPhotosViewModel *)viewModel
{
    if (!_viewModel)
    {
        _viewModel = [RITLPhotosViewModel new];
    }
    
    return _viewModel;
}



-(void)dismissViewController
{
    return [super dismissViewControllerAnimated:true completion:nil];
}


#pragma mark - 设置numberOfLabel的数目


//#pragma mark - UIAlertController
//- (void)alertControllerShouldPresent
//{
//    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"你最多只能选择%@张照片",@(_maxNumberOfSelectImages.unsignedIntegerValue)] message:nil preferredStyle:UIAlertControllerStyleAlert];
//    
//    [alertController addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil]];
//    
//    [self presentViewController:alertController animated:true completion:nil];
//}




@end



//
//@implementation RITLPhotosTimeHandleObject
//
//+(NSString *)timeStringWithTimeDuration:(NSTimeInterval)timeInterval
//{
//    NSUInteger time = (NSUInteger)timeInterval;
//    
//    //大于1小时
//    if (time >= 60 * 60)
//    {
//        NSUInteger hour = time / 60 / 60;
//        NSUInteger minute = time % 3600 / 60;
//        NSUInteger second = time % (3600 * 60);
//        
//        return [NSString stringWithFormat:@"%.2lu:%.2lu:%.2lu",(unsigned long)hour,(unsigned long)minute,(unsigned long)second];
//    }
//    
//    
//    if (time >= 60)
//    {
//        NSUInteger mintue = time / 60;
//        NSUInteger second = time % 60;
//        
//        return [NSString stringWithFormat:@"%.2lu:%.2lu",(unsigned long)mintue,(unsigned long)second];
//    }
//    
//    return [NSString stringWithFormat:@"00:%.2lu",(unsigned long)time];
//}
//
//@end


@implementation RITLPhotosViewController (updateNumberOfLabel)

-(void)updateNumbersForSelectAssets:(NSUInteger)number
{
    BOOL hidden = (number == 0);
    
    _numberOfLabel.hidden = hidden;
    
    if (!hidden)
    {
        _numberOfLabel.text = [NSString stringWithFormat:@"%@",@(number)];
        
        //设置放射以及动画
        _numberOfLabel.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        
        [UIView animateWithDuration:0.3 animations:^{
          
            _numberOfLabel.transform = CGAffineTransformIdentity;
            
        }];
    }
}


@end
