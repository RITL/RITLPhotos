//
//  RITLDownLoaderFileManager.h
//  NongWanCloud
//
//  Created by YueWen on 2018/4/12.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 进行文件的管理以及判定
@interface RITLDownLoaderFileManager : NSObject

#pragma mark - 存储操作

/**
 存储文件到已经下载完毕的文件夹中

 @param localURL 暂时缓存到本地的URL
 @param url 当前下载文件的url
 @return 文件存储的路径
 */
+ (NSString *)saveDataInCompletePathWithLocalURL:(NSURL *)localURL urlKey:(NSString *)url;


/**
 存储文件到断点续传的文件夹中
 
 @param data 存储的文件data
 @param url 当前下载文件的url
 */
+ (void)saveDataInCachePathWithData:(NSData *)data urlKey:(NSString *)url;


#pragma mark - 删除

/**
 移除储存的到已经下载完毕的文件
 
 @param url 文件下载的路径
 */
+ (void)removeDataWithUrl:(NSString *)url;

#pragma mark - 判断以及获取路径

/// 根据url获得当前文件存储的本地路径
+ (nullable NSString *)documentPathForUrl:(NSURL *)url;
/// 根据url的string获得当前文件存储的本地路径
+ (nullable NSString *)documentPathForUrlString:(NSString *)urlString;

/// 根据url的string判断当前文件是否已经下载完毕
+ (BOOL)documentIsCompleteWithUrlString:(NSString *)urltString;
/// 根据url的string判断当前文件是否进行断点续传
+ (BOOL)documentIsCacheWithUrlString:(NSString *)urltString;

/// 根据url的string获得断点续传的本地存储数据
+ (nullable NSData *)cacheDataWithUrl:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
