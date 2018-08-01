//
//  RITLDownLoaderFileManager.m
//  NongWanCloud
//
//  Created by YueWen on 2018/4/12.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "RITLDownLoaderFileManager.h"

@interface RITLDownLoaderFileManager ()

/// 文件的管理
@property (nonatomic, strong, readonly, class) NSFileManager *fileManager;
/// 沙盒路径
@property (nonatomic, copy, readonly, class) NSString *documentPath;

/// 保存下载完毕存储的文件路径
@property (nonatomic, copy, readonly, class) NSString *completePath;
/// 保存可断点续传的文件路径
@property (nonatomic, copy, readonly, class) NSString *cachePath;


@end

@implementation RITLDownLoaderFileManager


#pragma mark - 存储

+ (NSString *)saveDataInCompletePathWithLocalURL:(NSURL *)localURL urlKey:(NSString *)url
{
    //获得完成存储的path
    NSString *path = [self documentCompletePathForUrl:url];
    
    //获得URL
    NSURL *toUrl = [NSURL fileURLWithPath:path];
    
    //进行存储
    [self.fileManager moveItemAtURL:localURL toURL:toUrl error:nil];
    
    //从缓存文件中删除
    if ([self documentIsCacheWithUrlString:url]) {
        
        [self.fileManager removeItemAtPath:[self documentCachePathForUrl:url] error:nil];
    }
    
    return toUrl.absoluteString;
}


+ (void)removeDataWithUrl:(NSString *)url
{
    //获得完成存储的path
    NSString *path = [self documentCompletePathForUrl:url];
    
    //获得URL
    NSURL *toUrl = [NSURL fileURLWithPath:path];
    
    //移除
    if ([self.fileManager fileExistsAtPath:path]) {
        [self.fileManager removeItemAtURL:toUrl error:nil];
    }
}



+ (void)saveDataInCachePathWithData:(NSData *)data urlKey:(NSString *)url
{
    //获得缓存断点续传的url
    NSString *path = [self documentCachePathForUrl:url];
    
    //进行文件存储
    [data writeToFile:path atomically:true];
}


#pragma mark - public

+ (NSString *)documentPathForUrl:(NSURL *)url
{
    return [self documentPathForUrlString:url.absoluteString];
}

+ (NSString *)documentCompletePathForUrl:(NSString *)url
{
    NSString *path = [self addingPercentEncoding:url];
    
    return [self.completePath stringByAppendingPathComponent:path];
}

/// 缓存文件中的路径
+ (NSString *)documentCachePathForUrl:(NSString *)url
{
     NSString *path = [self addingPercentEncoding:url];
    
    return [self.cachePath stringByAppendingPathComponent:path];
}



+ (NSString *)documentPathForUrlString:(NSString *)urlString
{
    if ([self documentIsCompleteWithUrlString:urlString]) {//如果完成文件夹存在
        return [self documentCompletePathForUrl:urlString];//获得文件名称
    }
    
    if ([self documentIsCacheWithUrlString:urlString]) {//存在缓存问价
        return [self documentCachePathForUrl:urlString];//获得文件数据缓存路径
    }
    
    return nil;
}


+ (BOOL)documentIsCompleteWithUrlString:(NSString *)urltString
{
    return [self.fileManager fileExistsAtPath:[self documentCompletePathForUrl:urltString]];
}


+ (BOOL)documentIsCacheWithUrlString:(NSString *)urltString
{
    return [self.fileManager fileExistsAtPath:[self documentCachePathForUrl:urltString]];
}


+ (NSData *)cacheDataWithUrl:(NSString *)url
{
    if (![self documentIsCacheWithUrlString:url]) {
        return nil;
    }
    
    //获得本地的fileString
    NSString *urlPath = [self documentCachePathForUrl:url];
    
    return [NSData dataWithContentsOfFile:urlPath];
}


#pragma mark - base64

/// 对urlString进行base64编码
+ (NSString *)addingPercentEncoding:(NSString *)urlString
{
    NSString *character = [urlString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    
    return [character componentsSeparatedByString:@"/"].lastObject;
    
//    NSString *base64String = [[urlString dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//    
//    return [base64String stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
}



#pragma mark - 文件

+ (NSFileManager *)fileManager
{
    return NSFileManager.defaultManager;
}


+ (NSString *)documentPath
{
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject stringByAppendingPathComponent:@"ritl_file"];
    
    if (![self.fileManager fileExistsAtPath:path]) {
        
        [self.fileManager createDirectoryAtPath:path withIntermediateDirectories:true attributes:nil error:nil];
    }
    
    return path;
}


+ (NSString *)completePath
{
    NSString *completePath = [self.documentPath stringByAppendingPathComponent:@"ritl_files"];
    
    //判断不存在该路径
    if (![self.fileManager fileExistsAtPath:completePath]) {
        
        //创建
        [self.fileManager createDirectoryAtPath:completePath withIntermediateDirectories:true attributes:nil error:nil];
    }
    
    return completePath;
}


+ (NSString *)cachePath
{
    NSString *cachePath = [self.documentPath stringByAppendingPathComponent:@"ritl_cache"];
    
    //判断不存在该路径
    if (![self.fileManager fileExistsAtPath:cachePath]) {
        
        //创建
        [self.fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:true attributes:nil error:nil];
    }
    
    return cachePath;
}


@end
