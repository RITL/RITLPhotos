

---


<div align="center"><img src="http://7xruse.com1.z0.glb.clouddn.com/RITLPhotos.gif" height=500></img></div>
<br>

- 请不要忘记将`Localizable.strings`下的多语言化复制到自己的多语言文件中

- swift版本:[Swift-RITLImagePickerDemo](https://github.com/RITL/Swift-RITLImagePickerDemo)

- 用法比较简单:
```
RITLPhotoNavigationViewModel * viewModel = [RITLPhotoNavigationViewModel new];

__weak typeof(self) weakSelf = self;

//    设置需要图片剪切的大小，不设置为图片的原比例大小
//    viewModel.imageSize = _assetSize;

viewModel.RITLBridgeGetImageBlock = ^(NSArray <UIImage *> * images){
    
    //获得图片
    
};

viewModel.RITLBridgeGetImageDataBlock = ^(NSArray <NSData *> * datas){
  
    //可以进行数据上传操作..
    
    
};

 RITLPhotoNavigationViewController * viewController = [RITLPhotoNavigationViewController photosViewModelInstance:viewModel];

[self presentViewController:viewController animated:true completion:^{}];

```



# 2017-11-30 更新

由于近期一直很忙，其实我也在一直用这个库，稍微在项目里面完善了一下

- 去掉了必须使用Objc++模式
- 增加了代理，并且代理方法的优先级位于block之上



```
//设置代理如下
RITLPhotoNavigationViewModel * viewModel = [RITLPhotoNavigationViewModel new];
    
viewModel.bridgeDelegate = self;//优先级高于block回调
```

```
/// 代理方法

#pragma mark - RITLPhotoBridgeDelegate

/**
 初始化时设置imageSize时，回调获得响应大小图片的方法
 如果没有设置图片大小，返回的数据与ritl_bridgeGetImage:相同
 
 @param images 缩略图数组
 */
- (void)ritl_bridgeGetThumImage:(NSArray <UIImage *> *)images
{
    self.assets = images;
    
    [self.collectionView reloadData];
}


/**
 获得原尺寸比例大小的图片
 
 @param images 原比例大小的图片
 */
- (void)ritl_bridgeGetImage:(NSArray <UIImage *>*)images
{
    
}


/**
 获得所选图片的data数组
 
 @param datas 获得原图或者ritl_bridgeGetImage:数据的数据对象
 */
- (void)ritl_bridgeGetImageData:(NSArray <NSData *>*)datas
{
    //可以进行数据上传操作..
}



/**
 获得所选图片原资源对象(PHAsset)
 
 @param assets 所选图片原资源对象(PHAsset)
 */
- (void)ritl_bridgeGetAsset:(NSArray <PHAsset *>*)assets
{
    
}

```

