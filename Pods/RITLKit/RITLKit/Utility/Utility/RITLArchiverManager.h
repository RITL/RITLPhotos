//
//  TKArchiverManager.h
//  CityBao
//
//  Created by YueWen on 2016/12/6.
//  Copyright © 2016年 wangpj. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 负责进行本地序列化的类
@interface RITLArchiverManager : NSObject




/**
 开始本地序列化，会自动覆盖本地文件

 @param archiverObjects 本地序列化的数组数据
 @param document 本地序列化存储的文件名
 @param error 如果发生错误,error不为nil
 @return true表示本地序列化成功，false表示失败
 */
- (BOOL)ritl_startArchiver:(NSArray <id<NSCoding>> *)archiverObjects document:(NSString *)document error:(NSError **)error;



/**
 开始本地序列化

 @param archiverObjects 本地序列化的数组数据
 @param document 本地序列化存储的文件名
 @param error 如果发生错误,error不为nil
 @param replace true表示覆盖，false表示不覆盖，如果出现同名，出现error
 @return true表示本地序列化成功，false表示失败
 */
- (BOOL)ritl_startArchiver:(NSArray <id<NSCoding>> *)archiverObjects document:(NSString *)document error:(NSError **)error isReplace:(BOOL)replace;




/**
 读取本地序列化的数据

 @param document 本地序列化存储的文件名
 @return 返回数据
 */
- (nullable NSArray <id<NSCoding>> *)ritl_readArchiverObjectsInDocument:(NSString *)document;


@end

NS_ASSUME_NONNULL_END
