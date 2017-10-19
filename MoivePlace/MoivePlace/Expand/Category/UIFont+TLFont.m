//
//  UIFont+TLFont.m
//  1122Tool
//
//  Created by wapushidai on 16/10/9.
//  Copyright © 2016年 wapushidai. All rights reserved.
//

#import "UIFont+TLFont.h"
#define KTLFontName @"iconfont"

@implementation UIFont (TLFont)
+(UIFont *)tl_fontSize:(NSInteger)size;
{
    return [UIFont fontWithName:KTLFontName size:size];
}
@end
