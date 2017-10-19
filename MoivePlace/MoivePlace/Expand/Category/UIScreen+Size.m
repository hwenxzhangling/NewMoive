//
//  UIScreen+Size.m
//  Jest
//
//  Created by 段振伟 on 16/4/18.
//  Copyright © 2016年 段振伟. All rights reserved.
//

#import "UIScreen+Size.h"

@implementation UIScreen (Size)

+ (CGFloat)screenHeight {
    
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGSize)screenSize {
    return [UIScreen mainScreen].bounds.size;
}

+ (CGFloat)screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (BOOL)iphone4Size {
    
    return CGSizeEqualToSize([UIScreen mainScreen].bounds.size , CGSizeMake(320.f, 480.f));
}

+ (BOOL)iphone5Size {
    return CGSizeEqualToSize([UIScreen mainScreen].bounds.size,CGSizeMake(320.f, 568.f));
}

+ (BOOL)iphone6Size {
    
    return CGSizeEqualToSize([UIScreen mainScreen].bounds.size,CGSizeMake(375.f, 667.f));
}

+ (BOOL)iphone6PlusSize{
    
    return CGSizeEqualToSize([UIScreen mainScreen].bounds.size,CGSizeMake(414, 736));
}
@end
