Photos.framework是iOS8后苹果推出的一套替代AssetsLibrary.framework获取相册资源的原生库，至于AL库，欢迎大家给博文[iOS开发------简单实现图片多选功能(AssetsLibrary.framework篇)](http://blog.csdn.net/runintolove/article/details/51163192)提出宝贵的意见。

楼主大部分都是查看官方开发文档进行探索的(当然，实在不明白了也会请求google 的 0.0 )。这里就说一下个人的看法吧，相比AL库，Photos的开发文档显然更像是目前我们接触的ObjC语言(如果不信，可以对比一下AL库和Photos库的开发文档)。初次接触这个库的时候可能会感觉比较乱，毕竟类的数量比AL库多了好多，但在熟悉大体逻辑之后，就会发现它的分工比AL更加明确，并且使用起来要比AL灵活的多。

提醒一下，要使用相册资源库的时候，为了适配一下将来的iOS10，不要忘记在info.plist文件中加入`NSPhotoLibraryUsageDescription`这个描述字段啊，更多的权限坑请关注一下博文[ iOS开发------iOS 10 由于权限问题导致崩溃的那些坑](http://www.jianshu.com/p/7888e26ac2c6)

博文原址 : [iOS开发------简单实现图片多选功能(Photos.framework篇)](http://www.jianshu.com/p/140f8996279e)但我觉得没啥看的必要呢..

<div align="center"><img src="http://7xruse.com1.z0.glb.clouddn.com/RITLPhotos.gif" height=500></img></div>
<br>

