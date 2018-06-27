//
//  TKArchiverManager.m
//  CityBao
//
//  Created by YueWen on 2016/12/6.
//  Copyright © 2016年 wangpj. All rights reserved.
//

#import "RITLArchiverManager.h"

static NSString * RITLArchiverFolderName = @"RITLArchiverFolderName_Default";

@implementation RITLArchiverManager


#pragma mark - public

-(BOOL)ritl_startArchiver:(NSArray<id<NSCoding>> *)archiverObjects document:(NSString *)document error:(NSError * _Nullable __autoreleasing *)error
{
    return [self ritl_startArchiver:archiverObjects document:document error:error isReplace:true];
}





-(BOOL)ritl_startArchiver:(NSArray<id<NSCoding>> *)archiverObjects document:(NSString *)document error:(NSError * _Nullable __autoreleasing *)error isReplace:(BOOL)replace
{
    //拼接路径文件
    NSString * path = [[self p_defaultFullArchiverPath] stringByAppendingPathComponent:document];
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:path] && !replace)
    {
        if (error)//如果error存在
        {
            *error = [NSError errorWithDomain:@"出现同名文件" code:1001 userInfo:@{@"message":@"建议换一个文件名字!"}];
        }
        
        return false;
    }

    //开始存储
    return [NSKeyedArchiver archiveRootObject:archiverObjects toFile:path];
}





-(NSArray<id<NSCoding>> *)ritl_readArchiverObjectsInDocument:(NSString *)document
{
    //拼接路径
    NSString * path = [[self p_defaultFullArchiverPath] stringByAppendingPathComponent:document];
    
    //如果不存在
    if (![[NSFileManager defaultManager]fileExistsAtPath:path])
    {
        return nil;
    }
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}





#pragma mark - pirvate func

/// 完整的路径
- (NSString *)p_defaultFullArchiverPath
{
    //
    NSString * defaultArchiverPath = [self p_defaultArchiverPath];
    
    BOOL isDirectory;
    
    //如果不存在文件夹，创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:defaultArchiverPath isDirectory:&isDirectory])
    {
        [[NSFileManager defaultManager]createDirectoryAtPath:defaultArchiverPath withIntermediateDirectories:true attributes:nil error:nil];
    }
    
    return defaultArchiverPath;
}


/// 默认的保存路径
- (NSString *)p_defaultArchiverPath
{
    return [[self p_documentPath] stringByAppendingPathComponent:RITLArchiverFolderName];
}


/// 沙盒目录
- (NSString *)p_documentPath
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject;
}





@end
