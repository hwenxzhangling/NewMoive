//
//  UIImage+Extension.h
//  GSJuZhang
//
//  Created by Kings Yan on 15/1/15.
//  Copyright (c) 2015年 __Qing__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)


/**
 *     用颜色来生成图片的方法
 *
 *     @param color 颜色
 *     @param size  图片大小
 *
 *     @return 用颜色生成的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color withSize:(CGSize)size;

/**
 *     修改图片大小
 *
 *     @param image 被修改的图片
 *     @param size  大小
 *
 *     @return 修改后的图片
 */
+ (UIImage *)imageWithImage:(UIImage *)image withSize:(CGSize)size;

/**
 *     剪切图片
 *
 *     @param rect 剪切的区域
 *
 *     @return 被剪切后的图片
 */
- (UIImage *)clipImageFromRect:(CGRect)rect;

/**
 *     生成缩略图
 *
 *     @param asize 缩略图大小
 *
 *     @return 缩略后的图片
 */
- (UIImage *)thumbnailWithSize:(CGSize)asize;

/**
 *     修改图标颜色
 *
 *     @param asize 修改后的颜色
 *
 *     @return 修改后的图片
 */
- (UIImage *)tintColorWithColor:(UIColor *)color;


@end
