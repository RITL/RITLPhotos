//
//  UITableView+RITLCellRegister.m
//  EattaClient
//
//  Created by YueWen on 2017/5/9.
//  Copyright © 2017年 ryden. All rights reserved.
//

#import "UITableView+RITLCellRegister.h"

@implementation UITableView (RITLCellRegister)


/// 注册cell
- (void)ritl_registeCellWithIdentidiers:(NSSet *)identifiers
{
    for (NSString * identifier in identifiers) {
    
        [self registerClass:NSClassFromString(identifier) forCellReuseIdentifier:identifier];
    }
}



- (void)ritl_registerClasses:(NSArray<Class> *)cellClasses forCellReuseIdentifiers:(NSArray<NSString *> *)identifiers
{
    if (cellClasses.count != identifiers.count) {
        
        return;
    }
    
    for (NSInteger i = 0; i < cellClasses.count; i++) {
        
        [self registerClass:cellClasses[i] forCellReuseIdentifier:identifiers[i]];
    }
}

@end


@implementation UITableView (RITLDequeueCell)

- (UITableViewCell *)ritl_dequeueReusableCellWithIdentifier:(NSString *)identifier class:(Class)cellClass
{
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell =  [[cellClass alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}


- (UITableViewCell *)ritl_dequeueReusableCellWithIdentifier:(NSString *)identifier class:(Class)cellClass buildComplete:(RITLReusableCellInitHandler)handler
{
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell =  [[cellClass alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        if (handler) {  handler(cell); }
    }
    
    return cell;
}

@end
