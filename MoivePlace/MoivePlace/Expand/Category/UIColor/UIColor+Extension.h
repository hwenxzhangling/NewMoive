//
//  UIColor+Extension.h
//  WPsdInternal
//
//  Created by Kings Yan on 16/8/23.
//  Copyright © 2016年 wapushidai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)


//+ (UIColor *)colorWithHexColor:(NSString *)hexColor;

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)color;


@end
