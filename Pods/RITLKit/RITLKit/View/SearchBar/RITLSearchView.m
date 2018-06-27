//
//  XNDCustomSearchView.m
//  XiaoNongDingClient
//
//  Created by YueWen on 2017/6/19.
//  Copyright © 2017年 ryden. All rights reserved.
//

#import "RITLSearchView.h"
#import "RITLSearchTextField.h"
#import "RITLUtility.h"
#import <RITLViewFrame/UIView+RITLFrameChanged.h>

@interface RITLSearchView()<UITextFieldDelegate>

@property (nonatomic, strong, readwrite)RITLSearchTextField *searchTextField;

@end

@implementation RITLSearchView

@synthesize textFieldBackgroundColor = _textFieldBackgroundColor;

-(instancetype)init
{
    if (self = [super init]) {
     
        self.searchInsets = UIEdgeInsetsZero;
        self.searchIconInsets = UIEdgeInsetsZero;
    }
    
    return self;
}



-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.searchTextField];
    }
    
    return self;
}



-(void)layoutSubviews
{
    CGFloat width = self.ritl_width - self.searchInsets.left - self.searchInsets.right;
    CGFloat height = self.ritl_height - self.searchInsets.top - self.searchInsets.bottom;
    
    //进行searchTextField布局
    self.searchTextField.frame = CGRectMake(self.searchInsets.left, self.searchInsets.top, width, height);
    self.searchTextField.backgroundColor = self.textFieldBackgroundColor;
    self.searchTextField.placeholder = self.placeholder;
    self.searchTextField.font = self.searchFont;
    
    
    //left
    if (self.leftImage) {
        
        CGFloat height = self.searchTextField.ritl_height - self.searchIconInsets.top - self.searchIconInsets.bottom;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.searchIconInsets.left, 0, height + self.searchIconInsets.right, height)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = self.leftImage;
        
        self.searchTextField.leftView = imageView;
    }
}


#pragma mark - getter


-(RITLSearchTextField *)searchTextField
{
    if (!_searchTextField) {
     
        RITLSearchTextField *textField = [[RITLSearchTextField alloc]initWithFrame:CGRectZero];
        textField.font = self.searchFont;
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.returnKeyType = UIReturnKeySearch;
        textField.placeholderLeftMargin = 3;
        textField.textLeftMargin = 8;
        textField.placeholder = @"小农丁";
        textField.placeholder = self.placeholder;
        textField.delegate = self;
        
        _searchTextField = textField;
    }
    return _searchTextField;
}




-(UIColor *)textFieldBackgroundColor
{
    if (!_textFieldBackgroundColor) {
        
        _textFieldBackgroundColor = RITLColorFromIntRBG(219, 219, 219);
    }
    
    return _textFieldBackgroundColor;
}




#pragma mark - setter

-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    self.searchTextField.placeholder = placeholder;
}


-(void)setTextFieldBackgroundColor:(UIColor *)textFieldBackgroundColor
{
    _textFieldBackgroundColor = textFieldBackgroundColor;
    
    self.searchTextField.backgroundColor = textFieldBackgroundColor;
}


- (void)setSearchIconInsets:(UIEdgeInsets)searchIconInsets
{
    _searchIconInsets = searchIconInsets;
    
    ((RITLSearchTextField *)self.searchTextField).searchIconLeftMargin = searchIconInsets.left;
}


- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    [self.searchTextField setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
}


- (void)setPlaceholderFont:(UIFont *)placeholderFont
{
    _placeholderFont = placeholderFont;
    
    id object = [self.searchTextField valueForKey:@"placeholderLabel"];
    [object setValue:placeholderFont forKey:@"font"];
    [self.searchTextField setValue:placeholderFont forKeyPath:@"_placeholderLabel.font"];
}


#pragma mark - UITextFieldDelegate


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //执行回调
    if (self.delegate && [self.delegate respondsToSelector:@selector(customSearchViewShouldBeginEditing:)]) {
        
        return [self.delegate customSearchViewShouldBeginEditing:self];
    }
    
    return false;
}
@end



