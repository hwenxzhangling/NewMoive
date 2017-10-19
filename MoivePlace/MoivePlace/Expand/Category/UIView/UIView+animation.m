//
//  UIView+animation.m
//  WAF
//
//  Created by Kings Yan on 15/9/15.
//  Copyright (c) 2015年 西安交大捷普网络科技有限公司. All rights reserved.
//

#import "UIView+animation.h"
#import "UIView+Category.h"

#import <objc/runtime.h>

static char waveAnimationOriginColorKey, scaleAnimationComplementKey, flipAnimationComplementKey;

@implementation UIView (animation)

#pragma mark - flip

- (void)flipAnimation:(void (^)())animatin complement:(void (^)())complement
{
    objc_setAssociatedObject(self, &flipAnimationComplementKey, complement, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [UIView beginAnimations:@"Flip" context:nil];
    //设置时常
    [UIView setAnimationDuration:1];
    //设置动画淡入淡出
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //设置代理
    [UIView setAnimationDelegate:self];
    //设置翻转方向
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:YES];
    
    //动画结束
    [UIView commitAnimations];
    if (animatin) {
        animatin();
    }
    [self performSelector:@selector(flipAnimationComplement) withObject:nil afterDelay:1];
}

- (void)flipAnimationComplement
{
    void (^block)() = objc_getAssociatedObject(self, &flipAnimationComplementKey);
    if (block) {
        block();
    }
}

#pragma mark - wave

- (void)setWaveAnimationOriginColor:(UIColor *)waveAnimationOriginColor
{
    objc_setAssociatedObject(self, &waveAnimationOriginColorKey, waveAnimationOriginColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)waveAnimationOriginColor
{
    return objc_getAssociatedObject(self, &waveAnimationOriginColorKey);
}

- (void)waveAnimationWithNumber:(NSInteger)number disapear:(BOOL)disapear disapearColor:(UIColor *)disapearColor complement:(void (^)())complement
{
    [self waveAnimationWithNumber:number disapear:disapear disapearColor:disapearColor rewind:NO interval:0.7 scale:1.5 complement:complement];
}

- (void)waveAnimationWithNumber:(NSInteger)number disapear:(BOOL)disapear disapearColor:(UIColor *)disapearColor
                         rewind:(BOOL)rewind interval:(CGFloat)interval scale:(CGFloat)scale complement:(void (^)())complement
{
    
    void (^animation)(NSInteger currentCount) = ^ (NSInteger currentCount) {
        [UIView animateWithDuration:interval animations:^{
            
            self.transform = CGAffineTransformMakeScale(scale, scale);
            if (disapear) {
                
                self.alpha = 0;
                if (disapearColor) {
                    
                    self.waveAnimationOriginColor = self.backgroundColor;
                    self.backgroundColor = disapearColor;
                }
            }
        } completion:^(BOOL finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                void (^replay)(void) = ^{
                    
                    if (disapear) {
                        self.alpha = 1;
                    }
                    if (currentCount < number) {
                        [self waveAnimationWithNumber:number - 1 disapear:disapear disapearColor:disapearColor rewind:rewind interval:interval scale:scale complement:complement];
                    }
                    else{
                        if (complement) {
                            complement();
                        }
                    }
                };
                
                if (rewind) {
                    [UIView animateWithDuration:interval animations:^{
                        
                        self.transform = CGAffineTransformMakeScale(1, 1);
                        if (disapear) {
                            
                            self.alpha = 1;
                            if (disapearColor) {
                                self.backgroundColor = self.waveAnimationOriginColor;
                            }
                        }
                    } completion:^(BOOL finished) {
                        replay();
                    }];
                }
                else{
                    if (disapear && disapearColor) {
                        self.backgroundColor = self.waveAnimationOriginColor;
                    }
                    self.transform = CGAffineTransformMakeScale(1, 1);
                    replay();
                }
            });
        }];
    };
    animation(1);
}

#pragma mark - falling

- (void)fallingAnimationWithValues:(NSArray *)values interval:(CGFloat)interval
{
    [self fallingAnimationWithValues:values interval:interval withGradient:NO];
}

- (void)fallingAnimationWithValues:(NSArray *)values interval:(CGFloat)interval withGradient:(BOOL)gradient
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            [keyAnimation setValues:values];
            keyAnimation.duration = interval;
            keyAnimation.autoreverses = NO;
            
            [keyAnimation setCalculationMode:kCAAnimationCubic];
            [self.layer addAnimation:keyAnimation forKey:@"falling"];
            
            if (gradient) {
                
                CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
                positionAnimation.duration = interval;
                //            positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
                positionAnimation.fromValue = [NSNumber numberWithFloat:0];
                positionAnimation.toValue = [NSNumber numberWithFloat:1];
                //            [_precisionView setValue:[NSNumber numberWithFloat:[[_pathPoints lastObject] CGPointValue].y] forKeyPath:@"position.y"];
                [self.layer addAnimation:positionAnimation forKey:@"opacity"];
            }
            CGPoint point = [values[values.count - 1] CGPointValue];
            self.centerY = point.y;
            self.centerX = point.x;
        });
    });
}

- (void)boundsAnimationWithSize:(CGSize)size interval:(CGFloat)interval
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
//            [keyAnimation setValues:values];
//            keyAnimation.duration = interval;
//            keyAnimation.autoreverses = NO;
//            
//            [keyAnimation setCalculationMode:kCAAnimationCubic];
//            [self.layer addAnimation:keyAnimation forKey:@"falling"];
//            
//            if (gradient) {
            
                CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
                positionAnimation.duration = interval;
                //            positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
                positionAnimation.fromValue = [NSValue valueWithCGRect:self.bounds];
                positionAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, size.width, size.height)];
                //            [_precisionView setValue:[NSNumber numberWithFloat:[[_pathPoints lastObject] CGPointValue].y] forKeyPath:@"position.y"];
                [self.layer addAnimation:positionAnimation forKey:@"bounds"];
//            }
//            CGPoint point = [values[values.count - 1] CGPointValue];
//            self.centerY = point.y;
//            self.centerX = point.x;
            self.bounds = CGRectMake(0, 0, size.width, size.height);
        });
    });
}


- (void)scaleAnimationWithValues:(NSArray *)values interval:(CGFloat)interval complement:(void (^)())complement
{
    objc_setAssociatedObject(self, &scaleAnimationComplementKey, complement, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            [keyAnimation setValues:values];
            keyAnimation.duration = interval;
            keyAnimation.autoreverses = NO;
            
            [keyAnimation setCalculationMode:kCAAnimationCubic];
            [self.layer addAnimation:keyAnimation forKey:@"scale"];
            
            CGFloat scale = [values[values.count - 1] floatValue];
            self.transform = CGAffineTransformMakeScale(scale, scale);
            [self performSelector:@selector(scaleAnimationComplement) withObject:nil afterDelay:interval];
        });
    });
}

- (void)scaleAnimationComplement
{
    void (^block)() = objc_getAssociatedObject(self, &scaleAnimationComplementKey);
    if (block) {
        block();
    }
}

- (void)shakeAnimation
{
    [self shakeAnimationWithRange:15];
}

- (void)shakeAnimationWithRange:(CGFloat)range
{
    UIView *view = self;
    CGFloat scale = range;
    [self fallingAnimationWithValues:@[[NSValue valueWithCGPoint:CGPointMake(view.centerX, view.centerY)],
                                       [NSValue valueWithCGPoint:CGPointMake(view.centerX + scale, view.centerY)],
                                       [NSValue valueWithCGPoint:CGPointMake(view.centerX - scale, view.centerY)],
                                       [NSValue valueWithCGPoint:CGPointMake(view.centerX + scale / 4, view.centerY)],
                                       [NSValue valueWithCGPoint:CGPointMake(view.centerX, view.centerY)]] interval:0.3];
    
}

- (void)dropsOilAnimationWithComplement:(void (^)(BOOL))complement
{
    if (!self.superview && complement) {
        complement(NO);
    }
    CGFloat originHeight = self.height;
    [UIView animateWithDuration:1.5 animations:^{
        
        self.alpha = .95;
        self.height = self.height + 1.3;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:5 animations:^{
            self.top = self.superview.height;
        } completion:^(BOOL finished) {
            
            self.alpha = 1;
            self.height = originHeight;
            if (complement) {
                complement(YES);
            }
        }];
    }];
}

#pragma mark - login

- (void)loginAnimationWithComplement:(void (^)(BOOL *))complement
{
//    NSArray *colors = @[[UIColor grayColor],
//                        [UIColor purpleColor],
//                        [UIColor brownColor],
//                        [UIColor blueColor]];
    [self waveAnimationWithNumber:1 disapear:YES disapearColor:[UIColor brownColor] rewind:YES interval:1 scale:[UIScreen mainScreen].bounds.size.width / 320 * 3 complement:^{
        
//        self.backgroundColor = colors[arc4random() % 3];
        if (complement) {
            BOOL finish = NO;
            complement(&finish);
            if (!finish) {
                [self loginAnimationWithComplement:complement];
            }
        }
    }];
}

//- (void)presentAnimationWithTarget:(UIWindow *)target complement:(void (^)(UIImage *, CGRect))complement
//{
//    UIImageView *capture = [[UIImageView alloc] init];
//    capture.image = [self capture];
//    CGRect originRect = [self.superview convertRect:self.frame toView:target];
//    capture.frame = originRect;
//    [target addSubview:capture];
//    
//    [UIView animateWithDuration:0.5 animations:^{
//        capture.frame = [UIScreen mainScreen].bounds;
//    } completion:^(BOOL finished) {
//        
//        if (complement) {
//            complement(capture.image, originRect);
//        }
//        [capture removeFromSuperview];
//    }];
//}

- (void)dismissAnimationWithOrignRect:(CGRect)orignRect capture:(UIImage *)capture
{
    UIImageView *captureV = [[UIImageView alloc] init];
    captureV.image = capture;
    captureV.frame = [UIScreen mainScreen].bounds;
    [((id <UIApplicationDelegate>)[UIApplication sharedApplication].delegate).window addSubview:captureV];
    
    [UIView animateWithDuration:0.5 animations:^{
        captureV.frame = orignRect;
    } completion:^(BOOL finished) {
        [captureV removeFromSuperview];
    }];
}

@end
