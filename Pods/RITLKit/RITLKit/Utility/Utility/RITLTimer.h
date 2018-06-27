//
//  RITLTimer.h
//  CollectionBannerView
//
//  Created by YueWen on 16/7/21.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^RITLTimerBlock)(id info);


@interface RITLTimer : NSObject

@property (nullable, nonatomic, weak) id target;
@property (nullable, nonatomic, assign) SEL aSelector;
@property (nonatomic, weak)NSTimer * timer;


/** 获得一个计时器  */
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)aTarget selector:(SEL)aSelector userInfo:(id __nullable)userInfo repeats:(BOOL)isRepeats;

/** 获得一个计时器，Block执行 */
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval userInfo:(id __nullable)userInfo repeats:(BOOL)isRepeats BlockHandle:(RITLTimerBlock)blockHandle;

@end

NS_ASSUME_NONNULL_END
