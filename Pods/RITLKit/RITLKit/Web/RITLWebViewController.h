//
//  TKWebViewController.h
//  EattaClient
//
//  Created by YueWen on 2017/6/30.
//  Copyright © 2017年 ryden. All rights reserved.
//

@import UIKit;
@import WebKit;

NS_ASSUME_NONNULL_BEGIN

@protocol WKScriptMessageHandler;
@protocol WKNavigationDelegate;
@class RITLWebViewController;

@protocol RITLScriptMessageHandler <NSObject>

/// 注册的名字
@property (nonatomic, copy) NSString *name;

@end

typedef void(^RITLWebControllerConfigHandler)(RITLWebViewController *viewController);
typedef void(^RITLWebControllerTapHandler)(RITLWebViewController *viewController,UIBarButtonItem *item);


/// 网页加载控制器
@interface RITLWebViewController : UIViewController <WKNavigationDelegate>


/// 信息交互的handler
@property (nonatomic, copy, nullable)NSArray<id <WKScriptMessageHandler,RITLScriptMessageHandler> > * scriptMessageHandlers;

/// 加载的控制器
@property (nonatomic, strong, readonly) WKWebView *webView;

/// 设置独立的代理
@property (nonatomic, weak, nullable)id <WKNavigationDelegate> navigationDelegate;

/// 网页加载的url
@property (nonatomic, copy, nullable) NSString *url;

/// 网页的标题
@property (nonatomic, copy, nullable) NSString *webTitle;

/// 是否抓取webView的title，默认为true
@property (nonatomic, assign) BOOL autoTitle;



/// 进度条视图
@property (nonatomic, strong) UIProgressView *progressView;

/// 控制器当做自己的WKScriptMessageHandler进行注册的names - 默认为nil
@property (nonatomic, copy, readonly, nullable)NSArray < NSString *> *messageHanderNames;


/**
 便利构造器

 @param configHandler 配合方法
 @return TKWebViewController对象
 */
+ (instancetype)ritl_WebControllerHandler:(RITLWebControllerConfigHandler)configHandler;


/// 是否在初始化时自动加载url信息，默认为true
- (BOOL)autoRequestUrlAtViewDidLoad;

/// 加载url
- (void)requestUrl;



#pragma mark - item

/// default : 32
@property (nonatomic, assign)CGFloat closeWidth;


/// 默认为false
@property (nonatomic, assign)BOOL useRightCloseItem;
/// 关闭存在于右侧导航栏的image
@property (nonatomic, strong, nullable) UIImage *rightCloseImage;
/// rightCloseButtondidTap
@property (nonatomic, copy, nullable)RITLWebControllerTapHandler rightCloseButtonTap;
/// 默认(0,20,0,20)
@property (nonatomic, assign)UIEdgeInsets rightImageInset;

/// 默认为false
@property (nonatomic, assign)BOOL useLeftCloseItem;
/// 关闭存在与back右侧栏的image
@property (nonatomic, strong, nullable) UIImage *leftCloseImage;
/// leftCloseButtondidTap
@property (nonatomic, copy, nullable)RITLWebControllerTapHandler leftCloseButtonTap;
/// 默认(0,20,0,20)
@property (nonatomic, assign)UIEdgeInsets leftImageInset;



#pragma mark - Deprecated

/**
 关闭的itemButton的图片
 即将废弃 --- 使用rightCloseImage
 */
@property (nonatomic, strong) UIImage *closeImage;

@end

NS_ASSUME_NONNULL_END
