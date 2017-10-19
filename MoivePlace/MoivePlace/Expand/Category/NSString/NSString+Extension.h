//
//  NSString+Extension.h
//  GSJuZhang
//
//  Created by Kings Yan on 15/4/28.
//  Copyright (c) 2015年 __Qing__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Extension)


//判断是否为整形：
- (BOOL)isPureInt;
//判断是否为浮点形：
- (BOOL)isPureFloat;

/**
 *     通过正则表达式在一段字符串中查找数字字符并且返回
 *
 *     @return 通过正则表达式在一段字符串中查找的数字字符
 */
- (NSString *)findNumber;

/**
 *     对其两段字符串的长度，用附加的字符串来补齐
 *
 *     @param string1       字符串
 *     @param string2       字符串2
 *     @param addtionString 附加用于补齐的字符
 */
+ (void)alignmentLenghtAtString:(NSString **)string1 atString:(NSString **)string2 withString:(NSString *)addtionString;

/**
 *     验证版本号字符串是否比应用的版本号高
 *
 *     @param number        新版本号
 *     @param complement    验证结束后回调的闭包体
 *     @return isNew        是否高于应用的版本
 */
+ (void)verifyVersion:(NSString *)number complement:(void(^)(BOOL isNew))complement;


@end



/**
 *     对字符串进行编码的类别
 */
@interface NSString (code)


/**
 *      MD5 32 位编码
 *
 *     @return MD5 32 位的编码
 */
- (NSString *)MD5ENCodeFOR32;

/**
 *      MD5 64 位编码
 *
 *     @return MD5 64 位的编码
 */
- (NSString *)MD5ENCodeFOR64;


@end
