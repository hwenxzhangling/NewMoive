//
//  UITableViewCell+Extension.m
//  Cooking
//
//  Created by Kings Yan on 14/11/6.
//  Copyright (c) 2014年 ___GoGo___. All rights reserved.
//

#import "UITableViewCell+Extension.h"

@implementation UITableViewCell (Extension)

- (void)setSafeBackgroundColor:(UIColor *)backgroundColor
{
    self.contentView.backgroundColor = backgroundColor;
    self.backgroundColor = backgroundColor;
}

@end
