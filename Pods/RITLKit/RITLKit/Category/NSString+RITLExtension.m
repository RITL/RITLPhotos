//
//  NSString+RITLImageAttributeString.m
//  EattaClient
//
//  Created by YueWen on 2017/5/15.
//  Copyright © 2017年 ryden. All rights reserved.
//

#import "NSString+RITLExtension.h"
#import <CommonCrypto/CommonDigest.h>
//#import "NSObject+ RITLExtension.h"


@implementation NSString (RITLImageAttributeString)


-(NSAttributedString *)ritl_imageAttributeStringWithImage:(UIImage *)image attributes:(NSDictionary *)attributes baselineOffValue:(NSNumber *)value
{
    NSMutableAttributedString *attibuteResult = [[NSMutableAttributedString alloc]initWithString:@""];
    
    //自身文字
    NSString * handleString = [NSString stringWithFormat:@"%@",self];
    
    NSMutableAttributedString * attributeString = [[NSMutableAttributedString alloc]initWithString:handleString attributes:attributes];
    
    
    //放置图片
    NSTextAttachment * textAttachement = [NSTextAttachment new];
    textAttachement.image = image;
    NSAttributedString * imageAttributeString = [NSAttributedString attributedStringWithAttachment:textAttachement];
    NSMutableAttributedString *imageHandler = [[NSMutableAttributedString alloc]initWithAttributedString:imageAttributeString];
    [imageHandler addAttribute:NSUnderlineColorAttributeName value:[UIColor clearColor] range:NSMakeRange(0, imageHandler.length)];
    [imageHandler addAttribute:NSBaselineOffsetAttributeName value:value range:NSMakeRange(0, imageHandler.length)];
    
    //拼接
    [attibuteResult appendAttributedString:attributeString];
    [attibuteResult appendAttributedString:imageHandler];
    
    return [attibuteResult mutableCopy];
}

@end



@implementation NSString (RITLMD5)

-(NSString *)ritl_md5ForLower32Bate
{
    const char *input = self.UTF8String;//转成C字符串
    unsigned char result[CC_MD5_DIGEST_LENGTH];//存放结果
    
    CC_MD5(input, (CC_LONG)strlen(input), result);//进行加密
    
    // 拼接成字符串
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        
        [digest appendFormat:@"%02x",result[i]];
    }
    
    return digest;
}

@end


@implementation NSString (RITLURL)

-(NSURL *)ritl_url
{
    if (self.ritl_containChinese) {
        
       return [NSURL URLWithString:[self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    }
    
    return [NSURL URLWithString:self];
}

@end


@implementation NSString (RITLPhone)

-(NSString *)ritl_phone
{
    if (self.length < 3) {
        
        return @"";
    }
    
    //获得所有的长度
    NSInteger length = self.length;
    
    //获得*的个数
    NSInteger numberhide = length - 7  < 0 ? 0 : length - 7;
    
    //进行替换
    NSString *numberhideString = @"";
    
    
    for (NSInteger i = 0; i < numberhide; i ++) {
        
        numberhideString = [numberhideString stringByAppendingString:@"*"];
    }
    
    //进行替换
    NSString *numberResult = [self stringByReplacingCharactersInRange:NSMakeRange(3, numberhide) withString:numberhideString];
    
    return numberResult;
}

@end


@implementation NSString (RITLAttributeString)

-(NSAttributedString *)ritl_underLineString
{
    //初始化
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:self attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
    
    return string.mutableCopy;
}


- (NSAttributedString *)ritl_middleLineStringWithColor:(UIColor *)lineColor font:(UIFont *)font
{
    NSMutableAttributedString *handlePrice = [[NSMutableAttributedString alloc]initWithString:self attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSBaselineOffsetAttributeName:@(0),NSForegroundColorAttributeName:lineColor,NSFontAttributeName:font}];
    
    return handlePrice.mutableCopy;
}

@end



@implementation NSString (RITLDate)

- (NSString *)ritl_dayDate
{
    if (self.integerValue == 0) {
        
        return self;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.integerValue];

    NSDateFormatter *formatter = ({
        
        NSDateFormatter *formatter = NSDateFormatter.new;
        formatter.dateFormat = @"yyyy-MM-dd";
        formatter;
        
    })/*[NSDateFormatter ritl_object:^(__kindof NSDateFormatter *  _Nonnull object) {
        
        object.dateFormat = @"yyyy-MM-dd";
    }]*/;
    
    
    //设置转换
    return [formatter stringFromDate:date];
}


- (NSString *)ritl_detailDate
{
    if (self.integerValue == 0) {
        
        return self;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.integerValue];
    
    NSDateFormatter *formatter = NSDateFormatter.new;
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
//    [NSDateFormatter ritl_object:^(__kindof NSDateFormatter *  _Nonnull object) {
//
//        object.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    }];
//
    
    //设置转换
    return [formatter stringFromDate:date];
}


- (NSString *)ritl_AutoDiscriminatingTodayDate
{
    if (self.integerValue == 0) {
        
        return self;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.integerValue];
    
    NSDateFormatter *formatter1 = ({
        
        NSDateFormatter *formatter = NSDateFormatter.new;
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
        formatter;
        
    })/*[NSDateFormatter ritl_object:^(__kindof NSDateFormatter *  _Nonnull object) {
        
        object.dateFormat = @"yyyy-MM-dd HH:mm";
        
    }]*/;
    
    NSDateFormatter *formatter2 = ({
        
        NSDateFormatter *formatter = NSDateFormatter.new;
        formatter.dateFormat = @"yyyy-MM-dd";
        formatter;
    })/*[NSDateFormatter ritl_object:^(__kindof NSDateFormatter *  _Nonnull object) {
        
        object.dateFormat = @"yyyy-MM-dd";
        
    }]*/;
    
    //获得字符串
    NSString *date1 = [formatter1 stringFromDate:date];
    NSString *date2 = [formatter2 stringFromDate:date];
    
    //如果包含
    if ([date1 hasPrefix:date2]) {
        
        //进行替换
        return [date1 stringByReplacingOccurrencesOfString:date2 withString:@"今天 "];
    }
    
    return date1;
}

@end


@implementation NSString (RITLRandom)

+ (NSString *)ritl_randowString
{
    NSString *string = [[NSString alloc]init];
    
    for (int i = 0; i < 32; i++) {
        
        int number = arc4random() % 36;
        
        if (number < 10)
        {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }
        
        else
        {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    
    return string;
}

@end



@implementation NSString (UIImage)

- (UIImage *)ritl_image
{
    return [UIImage imageNamed:self];
}

@end


@implementation NSString (RITLChecker)


- (BOOL)ritl_hasSpaceWord
{
    if (!self || [self isEqualToString:@""]) {  return false; }
    
    NSMutableString * propertyHandler = [self mutableCopy];
    
    //去掉所有的空格
    [propertyHandler replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [propertyHandler length])];
    
    //不为nil并且不为空格
    return [propertyHandler isEqualToString:@""];
}



- (BOOL)ritl_isInteger
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}



- (BOOL)ritl_containChinese
{
    for(int i = 0; i< [self length]; i++)
    {
        unichar a = [self characterAtIndex:i];
        if( a >= 0x4E00 && a <= 0x9FA5){
            return true;
        }
    }
    return false;
}


- (BOOL)isEmpty
{
    return [self isEqualToString:@""];
}

@end


@implementation NSString (RITLPredicated)

- (BOOL)ritl_evaluatePredicate:(NSString *)predicate
{
    NSPredicate *nspredicate = [NSPredicate predicateWithFormat:predicate];
    
    return [nspredicate evaluateWithObject:self];
}

@end


@implementation NSString (RITLNumber)

- (NSString *)ritl_limitLettersMaxLength:(NSInteger)maxLength
{
    if (maxLength < 0 || self.length <= maxLength) { return self; }
    
    //开始截取
    NSString *sub = [self substringToIndex:maxLength];
    
    return [sub stringByAppendingString:@"..."];
    
}


- (NSString *)ritl_unitNumber
{
    NSInteger count = self.integerValue;
    
    if (count <= 999) { return self; }
    
    if (count > 999 && count < 10000){
        return [NSString stringWithFormat:@"%.1fk",self.floatValue];
    }
    
    return [NSString stringWithFormat:@"%.1fw",self.floatValue];
}


@end

