//
//  ViewController.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/13.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLPhotoMainViewController.h"
#import "YPPhotosCell.h"
#import "PHObject+SupportCategory.h"
#import "YPPhotoNavgationController.h"


#import "RITLPhotoNavigationViewController.h"
#import "RITLPhotoNavigationViewModel.h"

@interface RITLPhotoMainViewController ()
<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) CGSize assetSize;
@property (nonatomic, copy)NSArray <UIImage *> * assets;

@end

@implementation RITLPhotoMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    CGFloat sizeHeight = (self.collectionView.frame.size.width - 3) / 4;
    _assetSize = CGSizeMake(sizeHeight, sizeHeight);
    
    [self.view addSubview:self.collectionView];
    
    //检测是否存在new的相册
    RITLPhotoStore * store = [RITLPhotoStore new];
    
    [store checkGroupExist:@"new" result:^(BOOL isExist, PHAssetCollection * _Nullable collection) {
       
//        if (isExist)  NSLog(@"exist!");
        
//        else NSLog(@"not exist!");
        
    }];
    
}
- (IBAction)refresh:(id)sender
{
    self.assets = @[];
    
    [self.collectionView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)photosItemDidTap:(id)sender
{

//    YPPhotoNavgationController * photoViewController = [[YPPhotoNavgationController alloc]init];
//    
//    __weak typeof(self)weakSelf = self;
//    
//    
//#pragma photoViewController.photosDidSelectBlock用法
////    photoViewController.photosDidSelectBlock = ^(NSArray <PHAsset *> * assets,NSArray <NSNumber *> * status){
////        
////        weakSelf.assets = assets;
////        [weakSelf.collectionView reloadData];
////        
////        NSLog(@"%@",assets);
////        NSLog(@"%@",status);
////        
////    };
//    
//#pragma photoViewController.photoImageSelectBlock 搭配imageSize 的用法
//    photoViewController.imageSize = _assetSize;
//    photoViewController.photoImageSelectBlock = ^(NSArray <UIImage *> * images){
//      
//        weakSelf.assets = images;
//        [weakSelf.collectionView reloadData];
//        
//    };
//    
//    RITLPhotoNavigationViewController * viewController = [RITLPhotoNavigationViewController new];
    
   
    RITLPhotoNavigationViewModel * viewModel = [RITLPhotoNavigationViewModel new];
    
    __weak typeof(self) weakSelf = self;
    
//    viewModel.imageSize = _assetSize;
    
    viewModel.RITLBridgeGetImageBlock = ^(NSArray <UIImage *> * images){
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.assets = images;
        
        [strongSelf.collectionView reloadData];
        
    };
    
     RITLPhotoNavigationViewController * viewController = [RITLPhotoNavigationViewController photosViewModelInstance:viewModel];
    
    
    [self presentViewController:viewController animated:true completion:^{}];
    
//    [self presentViewController:photoViewController animated:true completion:^{}];
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
    YPPhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
#pragma photoViewController.photoImageSelectBlock 搭配imageSize 的用法
    cell.imageView.image = self.assets[indexPath.item];
    cell.chooseImageView.hidden = true;
    
#pragma photoViewController.photosDidSelectBlock用法，自己对资源进行裁剪
    /**********避免block中进行retain影响对象释放，造成内存泄露*********/
//    __weak typeof(YPPhotosCell *)copy_cell = cell;
//    
//    [((PHAsset *)[self.assets objectAtIndex:indexPath.item]) representationImageWithSize:_assetSize complete:^(UIImage * _Nullable image, PHAsset * _Nonnull asset) {
//        
//        copy_cell.imageView.image = image;
//        copy_cell.chooseImageView.hidden = true;
//        
//    }];
    
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
        _collectionView.backgroundColor = UIColorFromRGB(0xF6FFB7);
        
        [_collectionView registerClass:[YPPhotosCell class] forCellWithReuseIdentifier:@"Cell"];
    }
    
    return _collectionView;
}



#pragma mark - Action
- (IBAction)addGroupDidTap:(id)sender
{
    //弹出AlertController
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"新建相册" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"新建相册名字";
    
    }];
    
    
    __weak typeof(alertController) weakAlert = alertController;
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //获得textFiled
        UITextField * textField = weakAlert.textFields.firstObject;
        
        if (textField.text.length == 0) {
            return ;
        }
        
        
        //创建新的相册
        RITLPhotoStore * photoStore = [RITLPhotoStore new];
        
        [photoStore addCustomGroupWithTitle:textField.text completionHandler:^{
            ;
        } failture:^(NSString * _Nonnull error) {
            ;
        }];
        
    }]];
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"改变主意了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertController animated:true completion:^{}];
    
}



@end
