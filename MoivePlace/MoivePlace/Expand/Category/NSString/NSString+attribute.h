//
//  NSString+attribute.h
//  WAF
//
//  Created by Kings Yan on 15/9/25.
//  Copyright © 2015年 西安交大捷普网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (attribute)


/**
 *     返回带属性的字符串值
 *
 *     @param color        正常的颜色
 *     @param fontSize     正常的字体大小
 *     @param hint         特殊的文字
 *     @param hintColor    特殊文字的颜色
 *     @param hintFontSize 特殊文字的字体大小
 *
 *     @return 带属性的字符串值
 */
- (NSMutableAttributedString *)attributedStringWithColor:(UIColor *)color fontSize:(CGFloat)fontSize
                                              hintString:(NSString *)hint color:(UIColor *)hintColor fontSize:(CGFloat)hintFontSize;


@end
