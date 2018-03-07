//
//  UISearchBar+RITLCustomColor.m
//  CityBao
//
//  Created by YueWen on 16/4/29.
//  Copyright © 2016年 wangpj. All rights reserved.
//

#import "UISearchBar+RITLCustomColor.h"

@import ObjectiveC;

static NSString const * ConstCustomBottomView;
static NSString const * ConstTextField;

@implementation UISearchBar (YCustomColor)


-(void)dealloc
{
    objc_removeAssociatedObjects(self);
}


- (void)setCustomBottomView:(UIView *)customBottomView
{
    objc_setAssociatedObject(self, &ConstCustomBottomView, customBottomView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (UIView *)customBottomView
{
    return objc_getAssociatedObject(self, &ConstCustomBottomView);
}


- (void)setCustomTextField:(UITextField *)customTextField
{
    objc_setAssociatedObject(self, &ConstTextField, customTextField, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



-(UITextField *)customTextField
{
    if (objc_getAssociatedObject(self, &ConstTextField) == nil)
    {
        self.customTextField = [self searchBarTextField];
    }
    
    return objc_getAssociatedObject(self, &ConstTextField);
}


//设置背景色
- (void)ritl_setBackgroupColor:(UIColor *)color
{
    //移除
    if ([self isHaveSearchBarBackgroud])
    {
        //添加视图
        UIView * bottomView = self.subviews[0];
        bottomView.clipsToBounds = true;
        
        //自定义的视图
        if (self.customBottomView == nil)
        {
            UIView * customView = [[UIView alloc]initWithFrame:CGRectMake(0,-20, bottomView.bounds.size.width, 64)];
            customView.backgroundColor = color;
            
            self.customBottomView = customView;
        }
        
        self.customBottomView.backgroundColor = color;
        
        //插入自定义视图
        [bottomView insertSubview:self.customBottomView atIndex:0];
    }
}



//移除视图
- (BOOL)isHaveSearchBarBackgroud
{
    //获得Searchbar的View
    UIView * bottomView = self.subviews[0];
    
    for (UIView * view in bottomView.subviews)
    {
        if ([NSStringFromClass([view class]) isEqualToString:@"UISearchBarBackground"])
        {
            [view removeFromSuperview];
            
            return true;
        }
    }
    
    return true;
}


//设置光标颜色
-(void)ritl_setTextFieldCursorColor:(UIColor *)color
{
    [self.customTextField setTintColor:color];
}


//设置文本域背景色
-(void)ritl_setTextFieldBackGroudColor:(UIColor *)color
{
    [self.customTextField setBackgroundColor:color];
}


-(void)ritl_setTextFieldPlaceHolderColor:(UIColor *)color
{
    [self.customTextField setValue:color forKeyPath:@"_placeholderLabel.textColor"];
}



- (void)ritl_setPlaceHolderFont:(UIFont *)font
{
    id object = [self.customTextField valueForKey:@"placeholderLabel"];
    [object setValue:font forKey:@"font"];
}



-(void)ritl_setSearchFont:(UIFont *)font
{
    //进行标记
    if (!objc_getAssociatedObject(self, _cmd) && self.customTextField) {
        
        [self.customTextField setValue:font forKey:@"font"];
        objc_setAssociatedObject(self, _cmd, @"1", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    };
}



- (void)ritl_setTextFieldCornerRadius:(CGFloat)cornerRadius
{
    self.customTextField.layer.cornerRadius = cornerRadius;
}


/**
 *  获得SearchBar的文本域
 */
- (UITextField *)searchBarTextField
{
    for (UIView * view in self.subviews)
    {
        for (id subView in view.subviews)
        {
            if ([subView isKindOfClass:[UITextField class]])
            {
                return (UITextField *)subView;
            }
        }
    }
    return nil;
}


- (void)ritl_setSearchFieldBackgroundChangedSize:(CGSize)size
{    
    UITextField *textField = self.searchBarTextField;
    
    if (!textField) {
        
        return;
    }
    
    //获得背景视图
    for (UIView *subView in textField.subviews) {
        
        NSLog(@"class = %@",NSStringFromClass(subView.class));
    }
}

@end
