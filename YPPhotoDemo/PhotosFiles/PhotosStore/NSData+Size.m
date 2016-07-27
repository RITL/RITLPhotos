//
//  NSData+Size.m
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/25.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "NSData+Size.h"

#define Standard (1024.0)

@implementation NSData (Size)

NSString * sizeWithLength(NSUInteger length)
{
    //转换成Btye
    NSUInteger btye = length;
    
    //如果达到MB
    if (btye > Standard * Standard)
    {
        return [NSString stringWithFormat:@"%.1fMB",btye / Standard / Standard];
    }
    
    
    else if (btye > Standard)
    {
        return [NSString stringWithFormat:@"%.0fKB",btye / Standard];
    }
    
    else
    {
        return [NSString stringWithFormat:@"%@B",@(btye)];
    }
 
}


-(NSString *)sizeString
{
    NSUInteger dataSize = self.length;
    
    return sizeWithLength(dataSize);
}


+(NSString *)sizeStringWithLength:(NSUInteger)length
{
    return sizeWithLength(length);
}

@end
