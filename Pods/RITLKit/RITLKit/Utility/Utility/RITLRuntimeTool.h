//
//  RITLRuntimeTool.h
//  EattaClient
//
//  Created by YueWen on 2017/9/14.
//  Copyright © 2017年 ryden. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// runtime 交换方法
void RITL_swizzledInstanceSelector(Class classObject,SEL originSel,SEL swizzledSel);
void RITL_swizzledClassSelector(Class classObject,SEL originSel,SEL swizzledSel);


@interface NSObject (RITLSwizzled)

+ (void)ritl_swizzledInstanceSelector:(SEL)originSel swizzled:(SEL)sel;
+ (void)ritl_swizzledClassSelector:(SEL)originSel swizzled:(SEL)sel;

@end

NS_ASSUME_NONNULL_END
