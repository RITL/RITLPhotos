//
//  RITLBannerTimer.m
//  CollectionBannerView
//
//  Created by YueWen on 16/7/21.
//  Copyright © 2016年 YueWen. All rights reserved.
//

#import "RITLTimer.h"

@implementation RITLTimer

-(instancetype)initTimer:(id)target selector:(SEL)aSelector
{
    if (self = [super init])
    {
        self.target = target;
        self.aSelector = aSelector;
    }

    return self;
}


+(instancetype)bannerViewTimer:(id)target selector:(SEL)aSelector
{
    return [[self alloc] initTimer:target selector:aSelector];
}

-(void)dealloc
{
    NSLog(@"RITLBannerTimer dealloc");
}


- (void)fire:(NSTimer *)timer
{
    if (self.target != nil)
    {
        [self.target performSelector:self.aSelector withObject:timer.userInfo afterDelay:0];
    }
    
    else
    {
        [timer invalidate];
    }
}


+ (void)blockFire:(NSArray *)userInfo
{
    //获得block对象
    RITLTimerBlock block = userInfo.lastObject;
    
    //获得info
    id info = userInfo.firstObject;
    
    if (block != nil)
    {
        block(info);
    }
    
}



+(NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)isRepeats
{
    
    RITLTimer * timerObject = [RITLTimer bannerViewTimer:aTarget selector:aSelector];
    
    //转移强引用对象
    timerObject.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:timerObject selector:@selector(fire:) userInfo:userInfo repeats:isRepeats];
    
    //添加到runloop
    [[NSRunLoop mainRunLoop]addTimer:timerObject.timer forMode:NSRunLoopCommonModes];

    return timerObject.timer;
}




+(NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval userInfo:(id)userInfo repeats:(BOOL)isRepeats BlockHandle:(RITLTimerBlock)blockHandle
{
    NSArray * userInfoArray;
    
    if (userInfo == nil) {
        
        userInfoArray = @[[NSNull null],[blockHandle copy]];
    }
    
    else
    {
       userInfoArray = @[userInfo,[blockHandle copy]];
    }
    
    return [self scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(blockFire:) userInfo:userInfoArray repeats:isRepeats];
}


@end
