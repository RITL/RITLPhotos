//
//  YPPhotoGroupController.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/13.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "RITLPhotoGroupViewController.h"
#import "RITLPhotoGroupViewModel.h"
#import "RITLPhotoGroupCell.h"
//#import "YPPhotosController.h"

#import "RITLPhotosViewController.h"
#import "RITLPhotosViewModel.h"

#import <objc/message.h>

static NSString * cellIdentifier = @"RITLPhotoGroupCell";

@interface RITLPhotoGroupViewController ()

@end

@implementation RITLPhotoGroupViewController

-(instancetype)initWithViewModel:(id <RITLPhotoTableViewModel>)viewModel
{
    if (self = [super init])
    {
        _viewModel = viewModel;
    }
    
    return self;
}



+(instancetype)photosViewModelInstance:(id <RITLPhotoTableViewModel>)viewModel
{
    return  [[self alloc] initWithViewModel:viewModel];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self extensionTableView];
    [self extensionNavigation];
    [self bindViewModel];
    
    //开始获取相片
    ((void(*)(id,SEL))objc_msgSend)(self.viewModel,@selector(fetchDefaultGroups));
}


/// 设置tableView的拓展属性
- (void)extensionTableView
{
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView registerClass:[RITLPhotoGroupCell class] forCellReuseIdentifier:cellIdentifier];
}


/// 设置导航栏属性
- (void)extensionNavigation
{
    self.navigationItem.title = self.viewModel.title;
    
    // 回归到viewModel
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancle" style:UIBarButtonItemStylePlain target:self.viewModel action:@selector(dismissGroupController)];
    
}


/// 绑定viewModel
- (void)bindViewModel
{
    __weak typeof(self) weakSelf = self;
    
    if ([self.viewModel isMemberOfClass:[RITLPhotoGroupViewModel class]])
    {
        
        RITLPhotoGroupViewModel * viewModel = self.viewModel;
    
        viewModel.dismissGroupBlock = ^(){
          
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            [strongSelf dismissViewControllerAnimated:true completion:^{}];
            
        };
        
        
        viewModel.fetchGroupsBlock = ^(NSArray * groups){
          
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            [strongSelf.tableView reloadData];
            
            // 跳入第一个
            [strongSelf ritlTableView:strongSelf.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] Animated:false];
            
        };
        
        
        
        
        viewModel.selectedBlock = ^(PHAssetCollection * colletion,NSIndexPath * indexPath,BOOL animate){
          
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            RITLPhotosViewModel * viewModel = [RITLPhotosViewModel new];
            
            //设置标题
            viewModel.navigationTitle = colletion.localizedTitle;
            
            //设置数据源
            viewModel.assetCollection = colletion;
            
            //弹出控制器
            [strongSelf.navigationController pushViewController:[RITLPhotosViewController photosViewModelInstance:viewModel] animated:animate];
        };
    }
}




- (IBAction)cancleItemButtonDidTap:(id)sender
{
    [self dismissViewControllerAnimated:true completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc
{
//    self.groups = nil;
#ifdef RITLDebug
    NSLog(@"Dealloc %@",NSStringFromClass([self class]));
#endif
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.viewModel.numberOfGroup;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.viewModel numberOfRowInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RITLPhotoGroupCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RITLPhotoGroupCell class]) forIndexPath:indexPath];
    
    //设置
    [(RITLPhotoGroupViewModel *)self.viewModel loadGroupTitleImage:indexPath complete:^(id _Nonnull title, id _Nonnull image, id _Nonnull appendTitle, NSUInteger count) {
       
        cell.titleLabel.text = appendTitle;
        cell.imageView.image = image;
        
    }];
    
    return cell;
}



#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //消除选择痕迹
    [tableView deselectRowAtIndexPath:indexPath animated:false];
//    [self.viewModel didSelectRowAtIndexPath:indexPath];
    [self ritlTableView:tableView didSelectRowAtIndexPath:indexPath Animated:true];
    
}

- (void)ritlTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath Animated:(BOOL)animated
{
    //进行viewModel转换
    [((RITLPhotoGroupViewModel *)self.viewModel) ritl_didSelectRowAtIndexPath:indexPath animated:animated];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return [self.viewModel heightForRowAtIndexPath:indexPath];
}



#pragma mark - 

-(id <RITLPhotoTableViewModel>)viewModel
{
    if (!_viewModel)
    {
        _viewModel = [RITLPhotoGroupViewModel new];
    }
    
    return _viewModel;
}


@end
