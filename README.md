<div align="center"><img src="http://7xruse.com1.z0.glb.clouddn.com/RITLPhotos.gif" height=500></img></div>
<br>

- 请不要忘记将`Localizable.strings`下的多语言化复制到自己的多语言文件中

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
