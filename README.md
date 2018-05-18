

# 2018-05-18更新



<div align="center"><img src="https://github.com/RITL/RITLImagePickerDemo/blob/master/RITLPhotoDemo/RITLPhotos.gif" height=500></img></div>

# 使用方法
```
RITLPhotosViewController *photoController = RITLPhotosViewController.photosViewController;
photoController.configuration.maxCount = 5;//最大的选择数目
photoController.configuration.containVideo = false;//选择类型，目前只选择图片不选择视频
photoController.photo_delegate = self;
photoController.thumbnailSize = self.assetSize;//缩略图的尺寸

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
 */
- (void)photosViewController:(UIViewController *)viewController
             thumbnailImages:(NSArray <UIImage *> *)thumbnailImages
{

}
```
```
/**
 选中图片以及视频等资源的原比例图片
 适用于不使用缩略图，或者展示高清图片
 与是否原图无关
 
 @param viewController RITLPhotosViewController
 @param images 选中资源的原比例图
 */
- (void)photosViewController:(UIViewController *)viewController
                      images:(NSArray <UIImage *> *)images
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

- 2018-05-18 `version2.0` 增加了图片多选库中对`Live`以及`Video`的支持，增加了对顺序获取图片的支持

# 之前版本

- 请前往`version1.0`分值获得之前版本的代码以及`README`
