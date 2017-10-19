//
//  NSString+Extension.m
//  GSJuZhang
//
//  Created by Kings Yan on 15/4/28.
//  Copyright (c) 2015年 __Qing__. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extension)

- (BOOL)isPureInt
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isPureFloat
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

- (NSString *)findNumber
{
    // Intermediate
    NSMutableString *numberString = [[NSMutableString alloc] init];
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    while (![scanner isAtEnd]) {
        NSString *tempStr = @"";
        // Throw away characters before the first number.
        [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
        
        // Collect numbers.
        [scanner scanCharactersFromSet:numbers intoString:&tempStr];
        [numberString appendString:tempStr];
    }
    // Result.
    
    return numberString;
}

+ (void)alignmentLenghtAtString:(NSString **)string1 atString:(NSString **)string2 withString:(NSString *)addtionString
{
    NSMutableString *str1 = [NSMutableString stringWithString:*string1];
    NSMutableString *str2 = [NSMutableString stringWithString:*string2];
    while (str1.length != str2.length) {
        if (str1.length > str2.length) {
            for (int i = 0; i < (str1.length - str2.length);  i ++) {
                [str2 appendString:addtionString];
            }
        }
        else{
            for (int i = 0; i < (str2.length - str1.length);  i ++) {
                [str1 appendString:addtionString];
            }
        }
    }
    *string1 = str1;
    *string2 = str2;
}

+ (void)verifyVersion:(NSString *)number complement:(void (^)(BOOL))complement
{
//    if (!complement) {
//        
//        NSLog(@"%@ do not used complement!", _cmd);
//        return;
//    }
//    if (!number) {
//        
//        NSLog(@"%@ version number is nil!", _cmd);
//        return;
//    }
//    NSString *currentNumber = BundleVersion;
//    [NSString alignmentLenghtAtString:&number atString:&currentNumber withString:@".0"];
//    if ([[number findNumber] integerValue] > [[currentNumber findNumber] integerValue]) {
//        complement(YES);
//    }
//    else{
//        complement(NO);
//    }
}

@end

@implementation NSString (code)

- (NSString *)MD5ENCodeFOR32
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    
//    const char *cStr = [self UTF8String];
//    unsigned char digest[CC_MD5_DIGEST_LENGTH];
//    CC_MD5(cStr, (int)self.length, digest);
//    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
//    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
//        [result appendFormat:@"%02x", digest[i]];
//    return result;
}

- (NSString *)MD5ENCodeFOR64
{
    const char *cStr = [self UTF8String];
    unsigned char result[32];
    CC_MD5(cStr, (int)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0],result[1],result[2],result[3],
            result[4],result[5],result[6],result[7],
            result[8],result[9],result[10],result[11],
            result[12],result[13],result[14],result[15],
            result[16], result[17],result[18], result[19],
            result[20], result[21],result[22], result[23],
            result[24], result[25],result[26], result[27],
            result[28], result[29],result[30], result[31]];
}

@end
