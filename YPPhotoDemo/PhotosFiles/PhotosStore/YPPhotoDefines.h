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


typedef void(^YPPhotoDidSelectedBlock)(NSArray <UIImage *> *);
typedef void(^YPPhotoDidSelectedBlockAsset)(NSArray <PHAsset *> *,NSArray <NSNumber *> *);


#endif /* YPPhotoDefines_h */
