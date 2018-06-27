//
//  RITLFileDownloader.h
//  NongWanCloud
//
//  Created by YueWen on 2018/4/10.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RITLFileDownloader;

@protocol RITLFileDownloaderTask <NSObject>

@optional

/// 下载完毕后的回调
- (void)downLoader:(RITLFileDownloader *)downLoader session:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location filePath:(NSString *)path;

/// 下载的进度回调
- (void)downLoader:(RITLFileDownloader *)downLoader session:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite;

/// 恢复下载的回调
- (void)downLoader:(RITLFileDownloader *)downLoader session:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes;

/// 下载失败的回调
- (void)downLoader:(RITLFileDownloader *)downLoader session:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error;

@end


/// 文件的断点下载
@interface RITLFileDownloader : NSObject

/// 代理对象
@property (nonatomic, weak, nullable)id<RITLFileDownloaderTask>delegate;

/// 下载的控制器
@property (nonatomic, strong) NSURLSession *urlSession;

/// 下载的任务
@property (nonatomic, strong, nullable) NSURLSessionDownloadTask *downloadTask;

/// 文件下载的url
@property (nonatomic, copy) NSString *url;

/// 开始下载
- (void)startDownload;
- (void)startDownloadWithUrl:(NSString *)url;

/// 暂停
- (void)cancleCurrentTask;

@end

NS_ASSUME_NONNULL_END
