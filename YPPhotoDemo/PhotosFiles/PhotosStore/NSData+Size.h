//
//  NSData+Size.h
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/25.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Size)

@property (nonatomic, copy, readonly)NSString * sizeString;

+ (NSString *)sizeStringWithLength:(NSUInteger)length;

@end




NS_ASSUME_NONNULL_END