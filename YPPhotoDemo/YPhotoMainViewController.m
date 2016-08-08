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
<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) CGSize assetSize;
@property (nonatomic, copy)NSArray <UIImage *> * assets;

@end

@implementation YPhotoMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    CGFloat sizeHeight = (self.view.frame.size.width - 3) / 4;
    _assetSize = CGSizeMake(sizeHeight, sizeHeight);
    
    [self.view addSubview:self.collectionView];
    
    //检测是否存在new的相册
    YPPhotoStore * store = [YPPhotoStore new];
    
    [store checkGroupExist:@"new" result:^(BOOL isExist, PHAssetCollection * _Nullable collection) {
       
        if (isExist)  NSLog(@"exist!");
        
        else NSLog(@"not exist!");
        
    }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)photosItemDidTap:(id)sender
{

    YPPhotoNavgationController * photoViewController = [[YPPhotoNavgationController alloc]init];
    
    __weak typeof(self)weakSelf = self;
    
    
#pragma photoViewController.photosDidSelectBlock用法
//    photoViewController.photosDidSelectBlock = ^(NSArray <PHAsset *> * assets,NSArray <NSNumber *> * status){
//        
//        weakSelf.assets = assets;
//        [weakSelf.collectionView reloadData];
//        
//        NSLog(@"%@",assets);
//        NSLog(@"%@",status);
//        
//    };
    
#pragma photoViewController.photoImageSelectBlock 搭配imageSize 的用法
    photoViewController.imageSize = _assetSize;
    photoViewController.photoImageSelectBlock = ^(NSArray <UIImage *> * images){
      
        weakSelf.assets = images;
        [weakSelf.collectionView reloadData];
        
    };
    
    
    
    [self presentViewController:photoViewController animated:true completion:^{}];
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
        _collectionView.backgroundColor = [UIColor whiteColor];
        
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
        YPPhotoStore * photoStore = [YPPhotoStore new];
        
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
