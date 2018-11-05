//
//  RITLPhotosGroupTableViewController.m
//  RITLPhotoDemo
//
//  Created by YueWen on 2018/3/7.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "RITLPhotosGroupTableViewController.h"
#import "RITLPhotosCollectionViewController.h"

#import "RITLPhotosGroupCell.h"

#import "RITLPhotosConfiguration.h"

#import "NSBundle+RITLPhotos.h"
#import "NSArray+RITLPhotos.h"
#import "PHAssetCollection+RITLPhotos.h"
#import "PHFetchResult+RITLPhotos.h"
#import "PHPhotoLibrary+RITLPhotoStore.h"

#import <RITLKit/RITLKit.h>

@interface RITLPhotosGroupTableViewController (PHPhotoLibraryChangeObserver)<PHPhotoLibraryChangeObserver>

@end


@interface RITLPhotosGroupTableViewController (AssetData)

/// 加载默认的组
- (void)loadDefaultAblumGroups;

@end

@interface RITLPhotosGroupTableViewController (RITLString)

- (NSAttributedString *)titleForCollection:(PHAssetCollection *)collection count:(NSInteger)count;

@end

@interface RITLPhotosGroupTableViewController (RITLPhotosCollectionViewController)

- (void)pushPhotosCollectionViewController:(NSIndexPath *)indexPath animated:(BOOL)animated;

@end


@interface RITLPhotosGroupTableViewController ()

@property (nonatomic, strong)NSMutableArray<NSArray<PHAssetCollection *>*>*groups;

/// 用于比较变化的原生相册
@property (nonatomic, strong)PHFetchResult *regular;
@property (nonatomic, strong)PHFetchResult *moment;

@property (nonatomic, strong)RITLPhotosConfiguration *configuration;
/// 图片库
@property (nonatomic, strong)PHPhotoLibrary *photoLibrary;

@end

@implementation RITLPhotosGroupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //navigationItem
    self.navigationItem.title = @"照片";
    self.configuration = RITLPhotosConfiguration.defaultConfiguration;
    
    //register
    self.photoLibrary = PHPhotoLibrary.sharedPhotoLibrary;
    [self.photoLibrary registerChangeObserver:self];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancle" style:UIBarButtonItemStyleDone target:self action:@selector(dismissPhotoControllers)];
    
    //data
    self.groups = [NSMutableArray arrayWithCapacity:10];
    
    //tableView
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    //cell
    [self.tableView registerClass:RITLPhotosGroupCell.class forCellReuseIdentifier:@"group"];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.groups.count == 0) {
        [self loadDefaultAblumGroups];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if ([self isViewLoaded]) {
        [self.photoLibrary unregisterChangeObserver:self];//消除注册
    }
}


#pragma mark - Dismiss

- (void)dismissPhotoControllers
{
    //获得绑定viewController
    [NSNotificationCenter.defaultCenter postNotificationName:@"PhotosControllerDidDismissNotification" object:nil];
    
    if(self.navigationController.presentingViewController){//如果是模态弹出
        
        [self.navigationController dismissViewControllerAnimated:true completion:nil];
        
    }else if(self.navigationController){
        
        [self.navigationController popViewControllerAnimated:true];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groups[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RITLPhotosGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"group" forIndexPath:indexPath];
    
    // Configure the cell...
    PHAssetCollection *collection = self.groups[indexPath.section][indexPath.row];
    
    [collection ritl_headerImageWithSize:CGSizeMake(30, 30) mode:PHImageRequestOptionsDeliveryModeOpportunistic complete:^(NSString * _Nonnull title, NSUInteger count, UIImage * _Nullable image) {
        
        //set value
        cell.titleLabel.attributedText = [self titleForCollection:collection count:count];
        cell.imageView.image = count > 0 ? image : NSBundle.ritl_placeholder;
        
    }];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushPhotosCollectionViewController:indexPath animated:true];
}

@end




@implementation RITLPhotosGroupTableViewController (AssetData)

- (void)loadDefaultAblumGroups
{
    [PHPhotoLibrary.sharedPhotoLibrary fetchAblumRegularAndTopLevelUserResults:^(PHFetchResult<PHAssetCollection *> * _Nonnull regular, PHFetchResult<PHAssetCollection *> * _Nullable moment) {
        
        self.regular = regular;
        self.moment = moment;
        [self filterGroups];
        if (NSThread.isMainThread) {
            [self.tableView reloadData];//reload
        }else {
            [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:false];
        }
    }];
}


- (NSArray<PHAssetCollection *> *)filterGroupsWhenHiddenNoPhotos:(NSArray<PHAssetCollection *> *)groups
{
    return [groups ritl_filter:^BOOL(PHAssetCollection * _Nonnull obj) {
       
        PHFetchResult * assetResult = [PHAsset fetchAssetsInAssetCollection:obj options:nil];
        return assetResult != nil && assetResult.count > 0;
    }];
}


/// 进行筛选
- (void)filterGroups
{
    NSArray <PHAssetCollection *> *regularCollections = self.regular.array.sortRegularAblumsWithUserLibraryFirst;
    NSArray <PHAssetCollection *> *momentCollections = self.moment.array;
    
    [self.groups removeAllObjects];//移除所有的，进行重新添加
    
    if (self.configuration.hiddenGroupWhenNoPhotos == false) {
        [self.groups addObject:regularCollections];
        [self.groups addObject:momentCollections];
    }else {//进行数量的二次筛选
        [self.groups addObject:[self filterGroupsWhenHiddenNoPhotos:regularCollections]];
        [self.groups addObject:[self filterGroupsWhenHiddenNoPhotos:momentCollections]];
    }
}

@end




@implementation RITLPhotosGroupTableViewController (RITLString)

- (NSAttributedString *)titleForCollection:(PHAssetCollection *)collection count:(NSInteger)count
{
    //数据拼接
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc]
                                         initWithString:collection.localizedTitle
                                  attributes:@{NSFontAttributeName: RITLUtilityFont(RITLFontPingFangSC_Medium, 15)}];
    
    if (count < 0 || count == NSNotFound) {
        
        count = 0;
    }
    
    //
    NSString *countString = [NSString stringWithFormat:@"  (%@)",@(count).stringValue];
    
    //数量
    NSMutableAttributedString *countResult = [[NSMutableAttributedString alloc]
                                       initWithString:countString
                                              attributes:@{NSFontAttributeName: RITLUtilityFont(RITLFontPingFangSC_Medium, 15),NSForegroundColorAttributeName:RITLColorSimpleFromIntRBG(102)}];
    
    [result appendAttributedString:countResult];
    
    return result;
}

@end



@implementation RITLPhotosGroupTableViewController (RITLPhotosCollectionViewController)

- (void)pushPhotosCollectionViewController:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    PHAssetCollection *collection = self.groups[indexPath.section][indexPath.row];
    
    [self.navigationController pushViewController:({
        
        RITLPhotosCollectionViewController *collectionViewController = RITLPhotosCollectionViewController.photosCollectionController;
        
        //设置
        collectionViewController.navigationItem.title = NSLocalizedString(collection.localizedTitle, @"");
        collectionViewController.localIdentifier = collection.localIdentifier;
        
        collectionViewController;
        
    }) animated:animated];
}

@end


@implementation RITLPhotosGroupTableViewController (PHPhotoLibraryChangeObserver)

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    // 刷新UI
    dispatch_sync(dispatch_get_main_queue(), ^{

        // 还能相册发生变化
        PHFetchResultChangeDetails *regularChangeDetails = [changeInstance changeDetailsForFetchResult:self.regular];
        if (regularChangeDetails != nil) {
            self.regular = regularChangeDetails.fetchResultAfterChanges;
            [self filterGroups];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }

        // 个人组相册发生变化
        PHFetchResultChangeDetails *momentChangeDetails = [changeInstance changeDetailsForFetchResult:self.moment];
        if (momentChangeDetails != nil) {
            self.moment = momentChangeDetails.fetchResultAfterChanges;
            [self filterGroups];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    });
}

@end
