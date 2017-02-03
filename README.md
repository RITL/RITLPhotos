Photos.framework是iOS8后苹果推出的一套替代AssetsLibrary.framework获取相册资源的原生库，至于AL库，欢迎大家给博文[iOS开发------简单实现图片多选功能(AssetsLibrary.framework篇)](http://blog.csdn.net/runintolove/article/details/51163192)提出宝贵的意见。


提醒一下，要使用相册资源库的时候，为了适配一下将来的iOS10，不要忘记在info.plist文件中加入`NSPhotoLibraryUsageDescription`这个描述字段啊，更多的权限坑请关注一下博文[ iOS开发------iOS 10 由于权限问题导致崩溃的那些坑](http://www.jianshu.com/p/7888e26ac2c6)

博文原址 : [iOS开发------简单实现图片多选功能(Photos.framework篇)](http://www.jianshu.com/p/140f8996279e)但我觉得没啥看的必要呢..

<div align="center"><img src="http://7xruse.com1.z0.glb.clouddn.com/RITLPhotos.gif" height=500></img></div>
<br>

swift版本:[Swift-RITLImagePickerDemo](https://github.com/RITL/Swift-RITLImagePickerDemo)

用法比较简单:
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
