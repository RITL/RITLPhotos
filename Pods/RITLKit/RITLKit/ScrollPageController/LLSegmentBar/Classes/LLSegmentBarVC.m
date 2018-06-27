//
//  LLSegmentBarVC.m
//  LLSegmentBar
//
//  Created by liushaohua on 2017/6/3.
//  Copyright © 2017年 416997919@qq.com. All rights reserved.
//

#import "LLSegmentBarVC.h"
#import "UIView+LLSegmentBar.h"

@interface LLSegmentBarVC ()<LLSegmentBarDelegate,UIScrollViewDelegate>

@property (nonatomic,weak) UIScrollView * contentView;

@end

@implementation LLSegmentBarVC

- (LLSegmentBar *)segmentBar{
    if (!_segmentBar) {
        LLSegmentBar *segmentBar = [LLSegmentBar segmentBarWithFrame:self.view.bounds];
        segmentBar.delegate = self;
        segmentBar.backgroundColor = [UIColor greenColor];
        [self.view addSubview:segmentBar];
        _segmentBar = segmentBar;
    }
    return _segmentBar;
}

- (UIScrollView *)contentView {
    if (!_contentView) {
        
        UIScrollView *contentView = [[UIScrollView alloc] init];
        contentView.delegate = self;
        contentView.pagingEnabled = YES;
        [self.view addSubview:contentView];
        _contentView = contentView;
    }
    return _contentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setUpWithItems:(NSArray<NSString *> *)items childVCs:(NSArray<UIViewController *> *)childVCs{
    
    NSAssert(items.count != 0 || items.count == childVCs.count, @"个数不一致, 请自己检查");
    
    self.segmentBar.items = items;
    
    [self.childViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    
    for (UIViewController *vc in childVCs) {
        [self addChildViewController:vc];
    }
    
    self.contentView.contentSize = CGSizeMake(items.count * self.view.width, 0);
    
    self.segmentBar.selectIndex = 0;

}

- (void)showChildVCViewAtIndex:(NSInteger)index{
    
    if (self.childViewControllers.count == 0 || index < 0 || index > self.childViewControllers.count - 1) {
        return;
    }
    
    UIViewController *vc = self.childViewControllers[index];
    vc.view.frame = CGRectMake(index * self.contentView.width, 0, self.contentView.width, self.contentView.height);
    [self.contentView addSubview:vc.view];
    
    // 滑动到对应位置
    [self.contentView setContentOffset:CGPointMake(index * self.contentView.width, 0) animated:YES];
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    if (self.segmentBar.superview == self.view) {
        
        self.segmentBar.frame = CGRectMake(0, 60, self.contentView.width, 35);
        
        CGFloat contentViewY = self.segmentBar.y + self.segmentBar.height;
        CGRect contentFrame = CGRectMake(0, contentViewY, self.view.width, self.view.height - contentViewY);
        self.contentView.frame = contentFrame;
        self.contentView.contentSize = CGSizeMake(self.childViewControllers.count * self.view.width, 0);
        
        return;
    }
    
    CGRect contentFrame = CGRectMake(0, 0, self.view.width, self.view.height);
    self.contentView.frame = contentFrame;
    self.contentView.contentSize = CGSizeMake(self.childViewControllers.count * self.view.width, 0);
    
    self.segmentBar.selectIndex = self.segmentBar.selectIndex;

}
#pragma mark - LLSegmentBarDelegate
- (void)segmentBar:(LLSegmentBar *)segmentBar didSelectIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex{
    [self showChildVCViewAtIndex:toIndex];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger index = self.contentView.contentOffset.x/self.contentView.width;    
    self.segmentBar.selectIndex = index;
}










@end
