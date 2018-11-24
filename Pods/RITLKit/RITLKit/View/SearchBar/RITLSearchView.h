//
//  XNDCustomSearchView.h
//  XiaoNongDingClient
//
//  Created by YueWen on 2017/6/19.
//  Copyright © 2017年 ryden. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RITLSearchView;

@protocol RITLSearchViewDelegate <NSObject>

- (BOOL)customSearchViewShouldBeginEditing:(RITLSearchView *)searchView;

@end


/// 自定义的搜索视图 - 本质为textField
@interface RITLSearchView : UIView

/// 代理对象
@property (nonatomic, weak, nullable) id<RITLSearchViewDelegate> delegate;
/// 占位图
@property (nonatomic, copy) NSString *placeholder;
/// 搜索框位于当前view的inset
@property (nonatomic, assign)UIEdgeInsets searchInsets;
/// 搜索图标位于搜索框的inset
@property (nonatomic, assign)UIEdgeInsets searchIconInsets;
/// 左侧的图片
@property (nonatomic, strong, nullable) UIImage *leftImage;
/// 搜索的字体
@property (nonatomic, strong) UIFont *searchFont;
/// 默认为nil
@property (nonatomic, strong) UIFont *placeholderFont;
/// 默认为nil
@property (nonatomic, strong) UIColor *placeholderColor;
/// 文本域的背景色,默认为[219,219,219]
@property (nonatomic, strong) UIColor * textFieldBackgroundColor;
/// 负责搜索textField
@property (nonatomic, strong, readonly) UITextField *searchTextField;

@end



NS_ASSUME_NONNULL_END
