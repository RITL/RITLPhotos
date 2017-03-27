//
//  RITLTextFieldViewModel.h
//  CityBao
//
//  Created by YueWen on 2016/12/6.
//  Copyright © 2017年 wangpj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RITLPhotoTextFieldViewModel <NSObject>

@optional


/**
 完成协议方法textFieldShouldReturn：

 @param textField
 @return
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField;



/**
 是否允许该字符串书写在textField

 @param character 判定的字符串
 @return 
 */
- (BOOL)textFieldShouldChangeCharacters:(NSString *)character;

@end

NS_ASSUME_NONNULL_END
