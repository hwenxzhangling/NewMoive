//
//  UILabel+attribute.m
//  WAF
//
//  Created by Kings Yan on 15/12/9.
//  Copyright © 2015年 西安交大捷普网络科技有限公司. All rights reserved.
//

#import "UILabel+attribute.h"

@implementation UILabel (attribute)

- (void)setGapForAttrubtedText:(CGFloat)gap
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle1 setLineSpacing:gap];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, self.text.length)];
    
    self.attributedText = attributedString;
    [self sizeToFit];
}

@end
