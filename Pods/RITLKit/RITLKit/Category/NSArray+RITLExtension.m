//
//  NSArray+RITLExtension.m
//  EattaClient
//
//  Created by YueWen on 2017/6/22.
//  Copyright © 2017年 ryden. All rights reserved.
//

#import "NSArray+RITLExtension.h"

@implementation NSArray (RITLExtension)


-(NSArray *)ritl_map:(id  _Nonnull (^)(id _Nonnull))mapHander
{
    return [self ritl_reduce:@[] reduceHandler:^NSArray * _Nonnull(NSArray * _Nonnull result, id _Nonnull element) {
        
        return [result arrayByAddingObject:mapHander(element)];
    }];
}




- (NSArray *)ritl_detailMap:(id(^)(id,NSInteger))mapHandler
{
    return [self ritl_detailReduce:@[] reduceHandler:^NSArray * _Nonnull(NSArray * _Nonnull result, id _Nonnull element, NSInteger index) {
        
        return [result arrayByAddingObject:mapHandler(element,index)];
    }];
}


-(NSArray *)ritl_filter:(BOOL (^)(id _Nonnull))filterHandler
{
    return [self ritl_reduce:@[] reduceHandler:^NSArray * _Nonnull(NSArray * _Nonnull result, id _Nonnull element) {
        
        return filterHandler(element) ? [result arrayByAddingObject:element] : result;
    }];
}


- (NSArray *)ritl_detailFilter:(BOOL (^)(id _Nonnull, NSInteger))filterHandler
{
    return [self ritl_detailReduce:@[] reduceHandler:^NSArray * _Nonnull(NSArray * _Nonnull result, id _Nonnull element, NSInteger index) {
        
        return filterHandler(element,index) ? [result arrayByAddingObject:element] : result;
    }];
}



-(NSArray *)ritl_reduce:(NSArray *)initial
         reduceHandler:(NSArray* _Nonnull (^)(NSArray *_Nonnull, id _Nonnull))reduceHandler
{
    NSArray *result = initial;
    
    for (id object in self) {
        
        result = reduceHandler(result,object);
    }
    
    return result;
}



- (NSArray *)ritl_detailReduce:(NSArray *)initial reduceHandler:(NSArray * _Nonnull (^)(NSArray * _Nonnull, id _Nonnull, NSInteger))reduceHandler
{
    __block NSArray *result = initial;
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        result = reduceHandler(result,obj,idx);
    }];
    
    return result;
}


- (id)ritl_safeFirstObject
{
    return [self ritl_safeObjectAtIndex:0];
}


-(id)ritl_safeObjectAtIndex:(NSInteger)index
{
    if (index >= self.count || index < 0) {
        
        return nil;
    }
    
    return [self objectAtIndex:index];
}


-(id)ritl_revertObjectAtIndex:(NSInteger)index
{
    if (index < 0 || index >= self.count) {
        
        return nil;
    }
    
    return [self objectAtIndex:(self.count - index - 1)];
}


- (NSArray *)ritl_revert
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:self.count];
    
    for(NSInteger i = self.count - 1; i >= 0; i--) {
        
        [array addObject:self[i]];
    }

    return array.mutableCopy;
}

@end




