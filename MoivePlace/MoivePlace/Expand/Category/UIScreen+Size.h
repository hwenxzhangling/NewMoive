//
//  UIScreen+Size.h
//  Jest
//
//  Created by 段振伟 on 16/4/18.
//  Copyright © 2016年 段振伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (Size)
+ (CGSize) screenSize;
+ (CGFloat) screenWidth;
+ (CGFloat) screenHeight;

+ (BOOL) iphone4Size;
+ (BOOL) iphone5Size;
+ (BOOL) iphone6Size;
+ (BOOL) iphone6PlusSize;
@end
