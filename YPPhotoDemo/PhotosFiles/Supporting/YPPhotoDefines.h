//
//  YPPhotoDefines.h
//  YPPhotoDemo
//
//  Created by YueWen on 16/7/13.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#ifndef YPPhotoDefines_h
#define YPPhotoDefines_h


#ifdef __cplusplus
#define YPPHOTO_EXTERN extern "C" __attribute__((visibility ("default")))
#else
#define YPPHOTO_EXTERN extern __attribute__((visibility ("default")))
#endif


//**************RGB颜色转换（16进制->10进制）**************
#define UIColorFromRGB(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

#define UIColorFromIntRBG(RED, GREEN, BLUE) [UIColor colorWithRed:RED/255.0 green:GREEN/255.0 blue:BLUE/255.0 alpha:1.0]



//**************** 进行通用回调的block ***************
typedef void(^YPPhotoDidSelectedBlock)(NSArray <UIImage *> *);
typedef void(^YPPhotoDidSelectedBlockAsset)(NSArray <PHAsset *> *,NSArray <NSNumber *> *);




//**************** 将图片大小转换为字符串的C函数
#define Standard (1024.0)

static inline NSString * sizeWithLength(NSUInteger length)
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


#endif /* YPPhotoDefines_h */
