//
//  ViewController.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/13.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "RITLPhotoMainViewController.h"
#import "RITLPhotosCell.h"


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
    
//    //检测是否存在new的相册
//    RITLPhotoStore * store = [RITLPhotoStore new];
//    
//    [store checkGroupExist:@"new" result:^(BOOL isExist, PHAssetCollection * _Nullable collection) {
//       
////        if (isExist)  NSLog(@"exist!");
//        
////        else NSLog(@"not exist!");
//        
//    }];
    
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
    RITLPhotoNavigationViewModel * viewModel = [RITLPhotoNavigationViewModel new];

    __weak typeof(self) weakSelf = self;

    //    设置需要图片剪切的大小，不设置为图片的原比例大小
    //    viewModel.imageSize = _assetSize;

    viewModel.RITLBridgeGetImageBlock = ^(NSArray <UIImage *> * images){
        
        //获得图片
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.assets = images;
        
        [strongSelf.collectionView reloadData];
        
    };

    viewModel.RITLBridgeGetImageDataBlock = ^(NSArray <NSData *> * datas){
      
        //可以进行数据上传操作..

        
    };

     RITLPhotoNavigationViewController * viewController = [RITLPhotoNavigationViewController photosViewModelInstance:viewModel];

    [self presentViewController:viewController animated:true completion:^{}];
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
    
    cell.imageView.image = self.assets[indexPath.item];
    cell.chooseImageView.hidden = true;
    
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
        
        [_collectionView registerClass:[RITLPhotosCell class] forCellWithReuseIdentifier:@"Cell"];
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
