//
//  ETScrollPageViewController.m
//  XiaoNongDingClient
//
//  Created by YueWen on 2017/9/4.
//  Copyright © 2017年 ryden. All rights reserved.
//

#import "RITLScrollPageViewController.h"
#import <RITLViewFrame/UIView+RITLFrameChanged.h>
#import "NSArray+RITLExtension.h"
#import "RITLUtility.h"


@interface RITLScrollPageViewController ()<UIGestureRecognizerDelegate>

/// 自定义的滑动手势
@property (nonatomic, strong)UIPanGestureRecognizer *ritl_panGestureRecognizer;

@end


@implementation RITLScrollPageViewController

-(instancetype)init
{
    if (self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:self.orientation options:nil]) {
        
        self.delegate = self;
        self.dataSource = self;
    }
    
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    [self.contentViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
}



- (UIPageViewControllerNavigationOrientation)orientation
{
    return UIPageViewControllerNavigationOrientationHorizontal;
}



-(NSInteger)currentIndex
{
    if (!self.currentViewController) { return NSNotFound; }
    
    return [self.contentViewControllers indexOfObject:self.currentViewController];
}



-(void)setContentViewControllers:(NSArray<UIViewController *> *)contentViewControllers
{
    [self.contentViewControllers makeObjectsPerformSelector:@selector(removeFromParentViewController)];
    
    _contentViewControllers = contentViewControllers;
    
    if (contentViewControllers.count == 0) {
        
        return;
    }
    
    [contentViewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [self addChildViewController:obj];
        
    }];
    
    [self setViewControllers:@[contentViewControllers.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:false completion:nil];
    
    self.currentViewController = contentViewControllers.firstObject;
}




-(void)setCurrentViewController:(UIViewController *)currentViewController
{
    if (!currentViewController) {
        return;
    }
    
    //如果控制器一样，不作操作
    if ([currentViewController isEqual:self.currentViewController]) {
        return;
    }
    
    //获得当前的控制器
    UIViewController *lastCurrentViewController = self.currentViewController;
    
    //存在跳转的vc
    if ([self.contentViewControllers containsObject:currentViewController]) {
        
        //获得将要去的index
        NSInteger toIndex = [self.contentViewControllers indexOfObject:currentViewController];
        
        //从哪里来的index
        NSInteger fromIndex = 0;
        
        //获得准备跳转的fromIndex
        if ([self.contentViewControllers containsObject:lastCurrentViewController]) {
            
             fromIndex = [self.contentViewControllers indexOfObject:lastCurrentViewController];
        }
        
        //方向
        UIPageViewControllerNavigationDirection direction = fromIndex < toIndex ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
        
        //设置
        _currentViewController = currentViewController;
        
        [self setViewControllers:@[currentViewController] direction:direction animated:false completion:nil];
    }
}


@end





@interface RITLScrollHorizontalPageViewController ()

/// 标志动画是否完成
@property (nonatomic, assign)BOOL translateFinish;

@end



@implementation RITLScrollHorizontalPageViewController


- (UIPageViewControllerNavigationOrientation)orientation
{
    return UIPageViewControllerNavigationOrientationHorizontal;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.segmentBar.hidden) {
        
         [self.view addSubview:self.segmentBar];
    }
    
    self.translateFinish = true;
    
    //初始化手势
    self.ritl_panGestureRecognizer = [UIPanGestureRecognizer new];
    self.ritl_panGestureRecognizer.delegate = self;
    
    //获得需要失败的手势
    if (!self.popPanGestureRecognizer && self.navigationController) {
        
        self.popPanGestureRecognizer = self.navigationController.interactivePopGestureRecognizer;
    }
    
    else if (self.popPanGestureRecognizer  && self.parentViewController.navigationController) {
        
        self.popPanGestureRecognizer = self.parentViewController.navigationController.interactivePopGestureRecognizer;
    }
    
    if (self.popPanGestureRecognizer) {
        
         [self.ritl_panGestureRecognizer requireGestureRecognizerToFail:self.popPanGestureRecognizer];//自定义的高于导航栏
    }
    
    [self.ritl_scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.ritl_panGestureRecognizer];//滚动视图的手势高于pageController
    
    [self.ritl_scrollView addGestureRecognizer:self.ritl_panGestureRecognizer];
}


- (void)doSomething:(UIPanGestureRecognizer *)sender
{
    NSLog(@"do something");
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.segmentBar.ritl_width = self.ritl_width;
    
    //选出底部视图
    UIView *scrollView = [[self.view.subviews ritl_filter:^BOOL(__kindof UIView * _Nonnull view) {
        
        return [view isKindOfClass:[UIScrollView class]];
        
    }] ritl_safeObjectAtIndex:0];

//    BOOL hidden = self.segmentBar.hidden;
    
    //重置height
    scrollView.ritl_originY = self.segmentBar.hidden ? 0 : self.segmentBar.ritl_height;
    scrollView.ritl_height = self.ritl_height - (self.segmentBar.hidden ? 0 : self.segmentBar.ritl_height);
}


-(void)dealloc
{
//    [self.ritl_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}




#pragma mark - UIGestureRecognizerDelegate


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *)gestureRecognizer;
    
    CGPoint translate = [recognizer translationInView:gestureRecognizer.view];

//    NSLog(@"translate = %@",NSStringFromCGPoint(translate));
    
    if (translate.x <= 0) {//到达最右侧
        
        return self.currentIndex == self.contentViewControllers.count - 1 && self.translateFinish;
        
    }
    
    return self.currentIndex == 0 && self.translateFinish;
}



#pragma mark - setter

- (void)setCurrentViewController:(UIViewController *)currentViewController
{
    if (!currentViewController) {
        
        return;
    }
    
    [super setCurrentViewController:currentViewController];
    
    if (self.ritl_delegate && [self.ritl_delegate respondsToSelector:@selector(ritl_scrollHorizontalPageViewController:willToIndex:)]) {
        
        [self.ritl_delegate ritl_scrollHorizontalPageViewController:self willToIndex:self.currentIndex];
    }
    
    
    //变化segment
    [self.segmentBar changedSelectedOnlyWithIndex:self.currentIndex];
}




#pragma mark - getter

- (LLSegmentBar *)segmentBar
{
    if (!_segmentBar) {
        
        _segmentBar = [[LLSegmentBar alloc]initWithFrame:CGRectMake(0, 0, 0, (35))];
        _segmentBar.delegate = self;

        //进行设置
        [_segmentBar updateWithConfig:^(LLSegmentBarConfig *config) {
            
            config.itemFont([UIFont fontWithName:RITLFontPingFangSC_Regular size:14])
            .itemNormalColor(RITLColorFromIntRBG(77, 77, 77))
            .itemSelectColor(RITLColorFromIntRBG(41, 195, 144))
            .indicatorColor(RITLColorFromIntRBG(41, 195, 144))
            .indicatorHeight((1.5))
            .segmentBarBackColor([UIColor whiteColor]);
        }];
    }
    
    return _segmentBar;
}



#pragma mark - LLSegmentBarDelegate
- (void)segmentBar:(LLSegmentBar *)segmentBar didSelectIndex: (NSInteger)toIndex fromIndex: (NSInteger)fromIndex
{
    //获得将要去的viewController
    UIViewController *toViewController = [self.contentViewControllers ritl_safeObjectAtIndex:toIndex];
  
    self.currentViewController = toViewController;
}





#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    self.translateFinish = false;
}


- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
    [super pageViewController:pageViewController didFinishAnimating:finished previousViewControllers:previousViewControllers transitionCompleted:completed];

    self.translateFinish = true;
    
    if (self.ritl_delegate && [self.ritl_delegate respondsToSelector:@selector(ritl_scrollHorizontalPageViewController:willToIndex:)]) {
        
        [self.ritl_delegate ritl_scrollHorizontalPageViewController:self willToIndex:self.currentIndex];
    }
    
    //进行设置
    [self.segmentBar changedSelectedOnlyWithIndex:self.currentIndex];
    
}


@end



@implementation RITLScrollVerticalPageViewController


- (UIPageViewControllerNavigationOrientation)orientation
{
    return UIPageViewControllerNavigationOrientationVertical;
}


@end




@implementation UIPageViewController (RITLScrollView)

-(UIScrollView *)ritl_scrollView
{
    for (UIView *view in self.view.subviews) {
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            
            return (UIScrollView *)view;
        }
    }
    return nil;
}


- (UIPanGestureRecognizer *)ritl_scrollPanGestureRecongnizer
{
    return [self.ritl_gestureRecongnizers ritl_filter:^BOOL(UIGestureRecognizer * _Nonnull gestureRecognizer) {
        
        return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
        
    }].ritl_safeFirstObject;
}



- (NSArray<UIGestureRecognizer *> *)ritl_gestureRecongnizers
{
    UIScrollView *scrollView = self.ritl_scrollView;
    
    if (scrollView) {
        
        return scrollView.gestureRecognizers;
    }
    
    return nil;
}


@end




@implementation RITLScrollPageViewController (UIPageViewControllerDataSource)

//前一页
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    //控制器索引
    NSInteger index = [self.contentViewControllers indexOfObject:viewController];
    
    if(index == 0 || index == NSNotFound) { return nil; }
    
    index--;
    
    //设置当前的控制器
    return [self.contentViewControllers objectAtIndex:index];
}




//后一页
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    //控制器索引
    NSInteger index = [self.contentViewControllers indexOfObject:viewController];
    
    if(index == NSNotFound || index == self.contentViewControllers.count - 1) {  return nil; }
    
    index++;
    
    //设置当前的控制器
    return [self.contentViewControllers objectAtIndex:index];
}


@end




@implementation RITLScrollPageViewController (UIPageViewControllerDelegate)

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    //设置当前
    _currentViewController = pageViewController.viewControllers.firstObject;
    
}

@end

