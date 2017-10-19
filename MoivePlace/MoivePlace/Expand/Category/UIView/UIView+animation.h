//
//  UIView+animation.h
//  WAF
//
//  Created by Kings Yan on 15/9/15.
//  Copyright (c) 2015年 西安交大捷普网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef BOOL (^complement)(BOOL finish);

@interface UIView (animation)


/**
 *     视图实现反转动画
 *
 *     @param animatin   反转动画之后对 view 的改变闭包体
 *     @param complement 动画结束后的回调闭包体
 */
- (void)flipAnimation:(void (^)())animatin complement:(void (^)())complement;

/**
 *     爆炸动画效果
 */
// waveAnimationOriginColorAvailable only waveAnimation methods of disapearColor property is ture;
@property (nonatomic, strong) UIColor *waveAnimationOriginColor;

/**
 *     爆炸动画
 *
 *     @param number        爆炸的次数
 *     @param disapear      爆炸动画是否加淡出动画
 *     @param disapearColor 淡出动画的颜色
 *     @param complement    动画结束后回调闭包体
 */
- (void)waveAnimationWithNumber:(NSInteger)number disapear:(BOOL)disapear disapearColor:(UIColor *)disapearColor complement:(void (^)())complement;

/**
 *     爆炸动画
 *
 *     @param number        爆炸的次数
 *     @param disapear      爆炸动画是否加淡出动画
 *     @param disapearColor 淡出动画的颜色
 *     @param rewind        爆炸动画一次后是否倒回动画
 *     @param interval      动画时间
 *     @param scale         爆炸的大小
 *     @param complement    动画结束后回调闭包体
 */
- (void)waveAnimationWithNumber:(NSInteger)number disapear:(BOOL)disapear disapearColor:(UIColor *)disapearColor rewind:(BOOL)rewind interval:(CGFloat)interval scale:(CGFloat)scale complement:(void (^)())complement;

/**
 *     曲线动画
 *
 *     @param values   曲线数组，值为 NSPoint 值的 NSValue 对象
 *     @param interval 动画时间
 */
- (void)fallingAnimationWithValues:(NSArray <NSValue*>*)values interval:(CGFloat)interval;

/**
 *     曲线动画，加淡入效果
 *
 *     @param values   曲线数组，值为 NSPoint 值的 NSValue 对象
 *     @param interval 动画时间
 *     @param gradient 是否有淡入效果
 */
- (void)fallingAnimationWithValues:(NSArray <NSValue*>*)values interval:(CGFloat)interval withGradient:(BOOL)gradient;

/**
 *     改变 transform scale 的动画
 *
 *     @param values     scale 值的数组, float值
 *     @param interval   动画时间
 *     @param complement 动画结束后的回调闭包体
 */
- (void)scaleAnimationWithValues:(NSArray *)values interval:(CGFloat)interval complement:(void (^) ())complement;

/**
 *     改变 bounds   的动画
 *
 *     @param size  动画改编后的大小
 *     @param interval   动画时间
 */
- (void)boundsAnimationWithSize:(CGSize)size interval:(CGFloat)interval;

/**
 *     抖动动画
 */
- (void)shakeAnimation;

/**
 *     抖动动画，可设置抖动范围
 *
 *     @param range 抖动范围大小
 */
- (void)shakeAnimationWithRange:(CGFloat)range;

/**
 *     类似球掉地的动画
 *
 *     @param complement 动画结束后的回调闭包体
 */
- (void)dropsOilAnimationWithComplement:(void(^)(BOOL finished))complement;

/**
 *     基于爆炸效果动画实现的登陆动画
 *
 *     @param complement 动画结束后的回调闭包体
 */
- (void)loginAnimationWithComplement:(void (^)(BOOL *finish))complement;

//- (void)presentAnimationWithTarget:(UIWindow *)target complement:(void (^)(UIImage *capture, CGRect orignRect))complement;

/**
 *     控制器返回的缩小动画
 *
 *     @param orignRect 缩小后的区域
 *     @param capture   动画过程的显示内容
 */
- (void)dismissAnimationWithOrignRect:(CGRect)orignRect capture:(UIImage *)capture;


@end
