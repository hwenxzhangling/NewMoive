//
//  UIWebView+extension.m
//  1122Tool
//
//  Created by wapushidai on 16/11/16.
//  Copyright © 2016年 wapushidai. All rights reserved.
//

#import "UIWebView+extension.h"
#import <objc/runtime.h>

@implementation UIWebView (extension)

#pragma mark-WebActionDisablingCALayerDelegate类找不到相应的方法实现
+ (void)load
{
    //  "v@:"
    Class class = NSClassFromString(@"WebActionDisablingCALayerDelegate");
    class_addMethod(class, @selector(setBeingRemoved), setBeingRemoved, "v@:");
    class_addMethod(class, @selector(willBeRemoved), willBeRemoved, "v@:");
    class_addMethod(class, @selector(removeFromSuperview), willBeRemoved, "v@:");
}

id setBeingRemoved(id self, SEL selector, ...)
{
    return nil;
}

id willBeRemoved(id self, SEL selector, ...)
{
    return nil;
}
@end
