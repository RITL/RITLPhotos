//
//  RITLPhotoGroupViewModel.h
//  RITLPhotoDemo
//
//  Created by YueWen on 2016/11/29.
//  Copyright © 2017年 YueWen. All rights reserved.
//

#import "RITLPhotoBaseViewModel.h"
#import "RITLPhotoTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN


typedef PhotoBlock PhotoGroupDissmissBlock;
typedef PhotoCompleteBlock0 PhotoGroupCompleteBlock;
typedef PhotoCompleteBlock4 PhotoGroupSelectedBlock;
typedef PhotoCompleteBlock2 PhotoGroupMessageBlock;


/// 显示组的控制器的viewModel
@interface RITLPhotoGroupViewModel : RITLPhotoBaseViewModel <RITLPhotoTableViewModel>

/// 每张图片的大小，default (60,60)
@property (nonatomic, assign)CGSize imageSize;

/// 控制器弹回触发的block
@property (nonatomic, copy)PhotoGroupDissmissBlock dismissGroupBlock;

/// 获取相册组完成触发的block
@property (nonatomic, copy)PhotoGroupCompleteBlock fetchGroupsBlock;

/**
 点击相册触发的block,返回 PHAssetCollection类型以及当前位置indexPath
 由-didSelectRowAtIndexPath:indexPath:触发
 */
@property (nonatomic, copy)PhotoGroupSelectedBlock selectedBlock;



/**
 控制器模态弹回，触发dismissGroupBlock
 */
- (void)dismissGroupController;


/**
 请求获取默认的相册组，完成后触发fetchGroupsBlock
 */
- (void)fetchDefaultGroups;


/**
 当前位置的PHAssetCollection对象

 @param indexPath 所在的位置
 @return 当前位置的PHAssetCollection对象，如果当前位置没有返回nil
 */
- (nullable PHAssetCollection *)assetCollectionIndexPath:(NSIndexPath *)indexPath;


/**
 获取当前位置相册组和标题

 @param indexPath 当前的位置
 @param competeBlock 获取信息完成的回调,返回顺序:标题，图片，按照默认格式拼接的title,数量
 */
- (void)loadGroupTitleImage:(NSIndexPath *)indexPath
              complete:(PhotoGroupMessageBlock)competeBlock;



/**
 获取当前位置相册的所有照片集合

 @param indexPath 当前位置
 @return 当前当前位置相册的所有照片集合
 */
-(PHFetchResult *)fetchPhotos:(NSIndexPath *)indexPath;
    
    



/**
 当前tableView的row被点击触发

 @param indexPath 当前位置
 @param animate 是否进行动画跳转
 */
- (void)ritl_didSelectRowAtIndexPath:(NSIndexPath *)indexPath
                            animated:(BOOL)animate;

@end


NS_ASSUME_NONNULL_END
