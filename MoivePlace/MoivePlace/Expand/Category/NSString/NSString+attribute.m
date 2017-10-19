//
//  NSString+attribute.m
//  WAF
//
//  Created by Kings Yan on 15/9/25.
//  Copyright © 2015年 西安交大捷普网络科技有限公司. All rights reserved.
//

#import "NSString+attribute.h"
#import <CoreText/CoreText.h>

@implementation NSString (attribute)

- (NSMutableAttributedString *)attributedStringWithColor:(UIColor *)color fontSize:(CGFloat)fontSize
                                              hintString:(NSString *)hint color:(UIColor *)hintColor fontSize:(CGFloat)hintFontSize
{
    NSRange differentRect  = [self rangeOfString:hint];
    NSDictionary *attributes2 = @{(NSString *)kCTForegroundColorAttributeName: (id)color.CGColor,
                                  (NSString *)kCTFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc]initWithString:self attributes:attributes2];
    [hintString addAttributes:@{(NSString *)kCTForegroundColorAttributeName :(id)hintColor,
                                (NSString *)kCTFontAttributeName:[UIFont systemFontOfSize:hintFontSize]} range:differentRect];
    return hintString;
}

@end
