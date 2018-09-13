

# 2018-05-18更新



<div align="center"><img src="https://github.com/RITL/RITLImagePickerDemo/blob/master/RITLPhotoDemo/RITLPhotos.gif" height=500></img></div>

# 依赖的库
```
pod 'RITLKit'
pod 'Masonry'
```
# CocoaPod
```
pod 'RITLPhotos'
```
```
#import <RITLPhotos/RITLPhotos.h>
```

# 使用方法
```
RITLPhotosViewController *photoController = RITLPhotosViewController.photosViewController;
photoController.configuration.maxCount = 5;//最大的选择数目
photoController.configuration.containVideo = false;//选择类型，目前只选择图片不选择视频

photoController.photo_delegate = self;
photoController.thumbnailSize = self.assetSize;//缩略图的尺寸
photoController.defaultIdentifers = self.saveAssetIds;//记录已经选择过的资源

[self presentViewController:photoController animated:true completion:^{}];
```

# 回调方法
```
#pragma mark - RITLPhotosViewControllerDelegate
/**** 为了提高相关性能，如果用不到的代理方法，不需要多实现  ****/

/**
 选中图片以及视频等资源的本地identifer
 可用于设置默认选好的资源
 
 @param viewController RITLPhotosViewController
 @param identifiers 选中资源的本地标志位
 */
- (void)photosViewController:(UIViewController *)viewController
            assetIdentifiers:(NSArray <NSString *> *)identifiers
{
    
}
```
```
/**
 选中图片以及视频等资源的默认缩略图
 根据thumbnailSize设置所得，如果thumbnailSize为.Zero,则不进行回调
 与是否原图无关
 
 @param viewController RITLPhotosViewController
 @param thumbnailImages 选中资源的缩略图
 @param infos 选中资源的缩略图的相关信息
 */
- (void)photosViewController:(UIViewController *)viewController thumbnailImages:(NSArray<UIImage *> *)thumbnailImages infos:(NSArray<NSDictionary *> *)infos
{
    self.assets = thumbnailImages;
    [self.collectionView reloadData];
    
    NSLog(@"%@",infos);
}
```
```
/**
 选中图片以及视频等资源的原比例图片
 适用于不使用缩略图，或者展示高清图片
 与是否原图无关
 
 @param viewController RITLPhotosViewController
 @param images 选中资源的原比例图
 @param infos 选中资源的原比例图的相关信息
 */
- (void)photosViewController:(UIViewController *)viewController images:(NSArray<UIImage *> *)images infos:(NSArray<NSDictionary *> *)infos
{
    //获得原比例的图片
}
```
```
/**
 选中图片以及视频等资源的数据
 根据是否选中原图所得
 如果为原图，则返回原图大小的数据
 如果不是原图，则返回原始比例的数据
 注: 不会返回thumbnailImages的数据大小
 
 @param viewController RITLPhotosViewController
 @param datas 选中资源的数据
 */
- (void)photosViewController:(UIViewController *)viewController
                       datas:(NSArray <NSData *> *)datas
{
    
}
```
```
/**
 选中图片以及视频等资源的源资源对象
 如果需要使用源资源对象进行相关操作，请实现该方法
 
 @param viewController RITLPhotosViewController
 @param assets 选中的源资源
 */
- (void)photosViewController:(UIViewController *)viewController
                      assets:(NSArray <PHAsset *> *)assets
{
    
}

```


# 更新日志
- 2018-07-10 修复部分`icloud`图片获得失败的问题
- 2018-06-26 修复部分系统加载bundle图片失败的问题
- 2018-06-15 修复拒绝权限崩溃的问题
- 2018-05-21 使用`defaultIdentifers`属性可以记录选中的资源，可通过代理回调获得，支持Pod
- 2018-05-18 `Version 2.0` 增加了图片多选库中对`Live`以及`Video`的支持，增加了对顺序获取图片的支持
- 2017-11-30 去除必须使用的`Objective-C++`模式，新增代理方法替代`Block`
- 2017-05-19 `Version 1.0`
- 2016-09-24 支持`3D Touch`
- 2016-04-05 `Version 0.1`

# 待办清单
 - [ ] 支持拓展性的视图文字以及边框主题色
 - [x] 支持图片按点击顺序排列
 - [ ] 支持拖动进行的排序
 - [x] 支持CocoaPod
 - [x] 支持3D Touch响应
 - [x] 支持原图返回数据内存监控问题
 - [ ] 支持图片编辑功能
 - [ ] 支持图片裁剪功能
 - [ ] 支持相册变化的监听回调功能
 - [ ] 支持下滑返回手势功能

# 之前版本

- 请前往[version1.0](https://github.com/RITL/RITLImagePickerDemo/tree/version1.0)分支获得之前版本的代码以及`README.md`
