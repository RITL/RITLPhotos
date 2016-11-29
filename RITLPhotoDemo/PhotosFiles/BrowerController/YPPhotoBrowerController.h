//
//  YPPhotoBrowerController.h
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/14.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YPPhotoBrowerCDelegate.h"
#import "YPPhotoBrowerDataSource.h"

#ifdef __IPHONE_10_0
#import "YPPhotoBrowerPreDataSource.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@class YPPhotoBrowerController;

@protocol YPPhotoBrowerControllerDelegate <NSObject>

@optional

/** 返回按钮执行的block,用于colletionView更新 */
- (void)photoBrowerControllerShouldBack:(YPPhotoBrowerController *)viewController;

/** 点击完成进行的回调 */
- (void)photoBrowerController:(YPPhotoBrowerController *)viewController photosSelected:(NSArray <PHAsset *> *)photos Status:(NSArray <NSNumber *> *)status;

@end


typedef void(^YPPhotoBrowerBackBlock)(void);

NS_CLASS_AVAILABLE_IOS(8_0) @interface YPPhotoBrowerController : UIViewController

/// @brief 返回
@property (nonatomic, strong)UIButton * backButtonItem;
/// @brief 选择
@property (nonatomic, strong)UIButton * selectButtonItem;

/// @brief 高清图的响应Control
@property (strong, nonatomic) IBOutlet UIControl * highQualityControl;
/// @brief 选中圆圈
@property (strong, nonatomic) IBOutlet UIImageView * hignSignImageView;
/// @brief 原图:
@property (strong, nonatomic) IBOutlet UILabel * originPhotoLabel;
/// @brief 等待风火轮
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView * activityIndicatorView;
/// @brief 照片大小
@property (strong, nonatomic) IBOutlet UILabel *photoSizeLabel;
/// @brief 发送按钮
@property (strong, nonatomic) UIButton * sendButton;
/// @brief 显示数目
@property (strong, nonatomic) UILabel * numberOfLabel;

@property (nullable, nonatomic, weak)id <YPPhotoBrowerControllerDelegate> delegate;

@property (nonatomic, readonly, strong)YPPhotoBrowerCDelegate * browerDelegate;
@property (nonatomic, readonly, strong)YPPhotoBrowerDataSource * browerDatasource;


#ifdef __IPHONE_10_0
@property (nonatomic, readonly, strong)YPPhotoBrowerPreDataSource * browerPreDataSource NS_AVAILABLE_IOS(10_0);
#endif


/// 选择按钮被点击
- (void)buttonDidSelect;
/// 消除选择按钮的状态
- (void)buttonDidDeselect;
/// 转变为高清图状态
- (void)changeHightQualityStatus;
/// 转变为非高清图状态
- (void)changeDehightQualityStatus;
/// 设置选择的资源数
- (void)setNumbersForSelectAssets;
/// 显示当前资源的大小
- (void)showHighQualityData;


//Data
/**
 *  设置浏览数据源对象的资源
 *
 *  @param assets          传入浏览的对象，可以为Array类型或者PHFetchResult对象
 *  @param currentAsset    当前第一个占位的资源对象
 *  @param didSelectAssets 已经选择的资源对象数组
 *  @param status          已经选择资源对象的状态数组
 *  @param maxNumber       最多支持的数量
 */
- (void)setBrowerDataSource:(id)assets currentAsset:(PHAsset *)currentAsset didSelectAssets:(NSMutableArray <PHAsset *> *)didSelectAssets status:(NSMutableArray <NSNumber *> *)status maxNumberOfSelectImages:(NSNumber *)maxNumber;


@end

NS_ASSUME_NONNULL_END
