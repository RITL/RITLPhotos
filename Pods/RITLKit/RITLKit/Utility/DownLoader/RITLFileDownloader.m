//
//  RITLFileDownloader.m
//  NongWanCloud
//
//  Created by YueWen on 2018/4/10.
//  Copyright © 2018年 YueWen. All rights reserved.
//

#import "RITLFileDownloader.h"
#import "RITLDownLoaderFileManager.h"

@interface RITLFileDownloader () <NSURLSessionDownloadDelegate>

@end

@implementation RITLFileDownloader


- (void)startDownload
{
    [self startDownloadWithUrl:self.url];
}


- (void)startDownloadWithUrl:(NSString *)url
{
    if (!url) { return; }
    
    self.url = url;

    [self cancleCurrentTask];//取消当前的下载任务
    
    //已经下载完毕
    if([RITLDownLoaderFileManager documentIsCompleteWithUrlString:url]){
        
        //获得url
        NSString *filePath = [RITLDownLoaderFileManager documentPathForUrlString:url];
        
        //进行回调
        if (self.delegate && [self.delegate respondsToSelector:@selector(downLoader:session:downloadTask:didFinishDownloadingToURL:filePath:)]) {
            
            [self.delegate downLoader:self session:self.urlSession downloadTask:self.downloadTask didFinishDownloadingToURL:[NSURL fileURLWithPath:filePath] filePath:filePath]; return;
        }
    }

    //如果存在已经下载的断点文件，断点下载
    if ([RITLDownLoaderFileManager documentIsCacheWithUrlString:url]) {
        
        //获得Data
        NSData *cacheData = [RITLDownLoaderFileManager cacheDataWithUrl:url];
        
        self.downloadTask = [self.urlSession downloadTaskWithResumeData:cacheData];
        [self.downloadTask resume];
        return;
    }
    
    //进行下载
    self.downloadTask = [self.urlSession downloadTaskWithURL:[NSURL URLWithString:self.url]];
    
    //开始
    [self.downloadTask resume];
}


- (void)dealloc
{
    [self cancleCurrentTask];//取消当前下载的线程
}



/// 取消当前的数据
- (void)cancleCurrentTask
{
    //进行下载停止
    if (self.downloadTask) {
        
        [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            
            //保存到本地，以供断点下载
            [RITLDownLoaderFileManager saveDataInCachePathWithData:resumeData urlKey:self.url];
            
        }];
    }
}


#pragma mark - getter

- (NSURLSession *)urlSession
{
    if (!_urlSession) {
        
        _urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:NSOperationQueue.mainQueue];
    }
    
    return _urlSession;
}


#pragma mark - NSURLSessionDownloadDelegate

/// 下载完毕
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    //进行存储
    NSString *path = [RITLDownLoaderFileManager saveDataInCompletePathWithLocalURL:location urlKey:self.url];
    
    //进行回调
    if (self.delegate && [self.delegate respondsToSelector:@selector(downLoader:session:downloadTask:didFinishDownloadingToURL:filePath:)]) {
        
        [self.delegate downLoader:self session:session downloadTask:downloadTask didFinishDownloadingToURL:location filePath:path];
    }
}



/// 下载进度的回调
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(downLoader:session:downloadTask:didWriteData:totalBytesWritten:totalBytesExpectedToWrite:)]) {
        
        [self.delegate downLoader:self session:session downloadTask:downloadTask didWriteData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
    }
}



/// 恢复下载
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    //
    if (self.delegate && [self.delegate respondsToSelector:@selector(downLoader:session:downloadTask:didResumeAtOffset:expectedTotalBytes:)]) {
        
        [self.delegate downLoader:self session:session downloadTask:downloadTask didResumeAtOffset:fileOffset expectedTotalBytes:expectedTotalBytes];
    }
}


/// 下载失败，保留当前恢复的数据
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSData *resumeData = [error.userInfo valueForKey:NSURLSessionDownloadTaskResumeData];
    
    if (resumeData) {
        
       [RITLDownLoaderFileManager saveDataInCachePathWithData:resumeData urlKey:self.url];//保存当前恢复的数据
    }
    
    //进行回调
    if ([self.delegate respondsToSelector:@selector(downLoader:session:task:didCompleteWithError:)] && error) {
        
        [self.delegate downLoader:self session:session task:task didCompleteWithError:error];
    }
}



@end
