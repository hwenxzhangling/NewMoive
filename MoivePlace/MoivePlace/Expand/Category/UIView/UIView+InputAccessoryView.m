//
//  UIView+InputAccessoryView.m
//  Cooking
//
//  Created by Kings Yan on 14-9-13.
//  Copyright (c) 2014年 ___GoGo___. All rights reserved.
//

#import "UIView+InputAccessoryView.h"
#import "UIView+Category.h"

#import <objc/runtime.h>

#pragma mark - inputAccessory Extension
static char extensionKey;

@implementation UIView (InputAccessoryView_extention)

- (void)setInputAccessoryView_mask:(UIButton *)inputAccessoryView_mask
{
    objc_setAssociatedObject(self, &extensionKey, inputAccessoryView_mask, OBJC_ASSOCIATION_RETAIN);
}

- (UIButton *)inputAccessoryView_mask
{
    id obj = objc_getAssociatedObject(self, &extensionKey);
    if (!obj) {
        UIButton * iav = [[UIButton alloc]initWithFrame:self.bounds];
        iav.backgroundColor = [UIColor blackColor];
        [iav addTarget:self action:@selector(iavTapped_category:) forControlEvents:UIControlEventTouchUpInside];
        [self setInputAccessoryView_mask:iav];
        [self addSubview:self.inputAccessoryView_mask];
    }
    return objc_getAssociatedObject(self, &extensionKey);
}

- (void)iavTapped_category:(UIButton *)sender
{
    if (self.inputAccessoryViewState == InputAccessoryViewStatusShow) {
        [self hideInputAccessoryViewWithAnimation:YES completion:nil];
    }
    if (self.inputLeftAccessoryViewState == InputAccessoryViewStatusShow) {
        [self hideInputLeftAccessoryViewWithAnimation:YES completion:nil];
    }
    if (self.inputRightAccessoryViewState == InputAccessoryViewStatusShow) {
        [self hideInputRightAccessoryViewWithAnimation:YES completion:nil];
    }
    if (self.inputTopAccessoryViewState == InputAccessoryViewStatusShow) {
        [self hideInputTopAccessoryViewWithAnimation:YES completion:nil];
    }
}

@end

#pragma mark - show inputAccessory view - Down
static char iavKey, stateKey, iavHeightKey;

@implementation UIView (InputAccessoryView_category)

- (void)setInputAccessoryView_category:(UIView *)inputAccessoryView_category
{
    objc_setAssociatedObject(self, &iavKey, inputAccessoryView_category, OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)inputAccessoryView_category
{
    id obj = objc_getAssociatedObject(self, &iavKey);
    if (!obj) {
        UIView * iav = [[UIView alloc]initWithFrame:CGRectMake(0, self.bottom, self.width, self.showHeight)];
        iav.backgroundColor = [UIColor whiteColor];
        [self setInputAccessoryView_category:iav];
        self.inputAccessoryView_category.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:self.inputAccessoryView_category];
        self.inputAccessoryViewState = InputAccessoryViewStatusHide;
    }
    return objc_getAssociatedObject(self, &iavKey);
}

- (void)setInputAccessoryViewState:(InputAccessoryViewStatus)inputAccessoryViewState
{
    objc_setAssociatedObject(self, &stateKey, [NSNumber numberWithInteger:inputAccessoryViewState], OBJC_ASSOCIATION_RETAIN);
}

- (InputAccessoryViewStatus)inputAccessoryViewState
{
    return [objc_getAssociatedObject(self, &stateKey) integerValue];
}

- (void)setShowHeight:(CGFloat)showHeight
{
    objc_setAssociatedObject(self, &iavHeightKey, [NSNumber numberWithFloat:showHeight], OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)showHeight
{
    CGFloat showhei = [objc_getAssociatedObject(self, &iavHeightKey) floatValue];
    if (showhei == 0.0) {
        return 58;
    }
    else{
        return showhei;
    }
}

- (void)showInputAccessoryViewWithAnimation:(BOOL)animation mask:(BOOL)mask completion:(void (^)())completion
{
    if (self.inputAccessoryViewState == InputAccessoryViewStatusHide && self.inputAccessoryView_category) {
        
        if (mask) {
            self.inputAccessoryView_mask.alpha = 0;
        }
        [self.inputAccessoryView_category bringToFront];
        [UIView animateWithDuration:(animation == YES)? 0.3 : 0 animations:^{
            
            if (mask) {
                self.inputAccessoryView_mask.alpha = 0.2;
            }
            self.inputAccessoryView_category.bottom = self.height;
        } completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];
        self.inputAccessoryViewState = InputAccessoryViewStatusShow;
    }
}

- (void)showInputAccessoryViewWithAnimation:(BOOL)animation mask:(BOOL)mask hight:(CGFloat)height completion:(void (^)())completion
{
     if (self.inputAccessoryViewState == InputAccessoryViewStatusHide && self.inputAccessoryView_category) {
         self.inputAccessoryView_category.height = height;
         [self showInputAccessoryViewWithAnimation:animation mask:mask completion:completion];
     }
}

- (void)hideInputAccessoryViewWithAnimation:(BOOL)animation completion:(void (^)())completion
{
    if (self.inputAccessoryView_category) {
        [UIView animateWithDuration:(animation == YES)? 0.3 : 0 animations:^{
            
            self.inputAccessoryView_category.top = self.bottom;
            self.inputAccessoryView_mask.alpha = 0;
        } completion:^(BOOL finished) {
            
            [self.inputAccessoryView_mask removeFromSuperview];
            objc_setAssociatedObject(self, &extensionKey, nil, OBJC_ASSOCIATION_RETAIN);
            
            [self.inputAccessoryView_category removeAllSubviews];
            objc_setAssociatedObject(self, &iavKey, nil, OBJC_ASSOCIATION_RETAIN);
            
            self.inputAccessoryViewState = InputAccessoryViewStatusHide;
            objc_removeAssociatedObjects(self);
            self.inputAccessoryView_mask = nil;
            self.inputAccessoryView_category = nil;
            if (completion) {
                completion();
            }
        }];
    }
}

@end

#pragma mark - show inputAccessory view - Left
static char iavLeftKey, stateLeftKey, iavHeightLeftKey;

@implementation UIView (InputLeftAccessoryView_category)

- (void)setInputLeftAccessoryView_category:(UIView *)inputLeftAccessoryView_category
{
    objc_setAssociatedObject(self, &iavLeftKey, inputLeftAccessoryView_category, OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)inputLeftAccessoryView_category
{
    id obj = objc_getAssociatedObject(self, &iavLeftKey);
    if (!obj) {
        UIView * iav = [[UIView alloc]initWithFrame:CGRectMake(- self.showLeft, 0, self.showLeft, self.height)];
        iav.backgroundColor = [UIColor whiteColor];
        [self setInputLeftAccessoryView_category:iav];
        self.inputLeftAccessoryView_category.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:self.inputLeftAccessoryView_category];
        self.inputLeftAccessoryViewState = InputAccessoryViewStatusHide;
    }
    return objc_getAssociatedObject(self, &iavLeftKey);
}

- (void)setInputLeftAccessoryViewState:(InputAccessoryViewStatus)inputLeftAccessoryViewState
{
    objc_setAssociatedObject(self, &stateLeftKey, [NSNumber numberWithInteger:inputLeftAccessoryViewState], OBJC_ASSOCIATION_RETAIN);
}

- (InputAccessoryViewStatus)inputLeftAccessoryViewState
{
    return [objc_getAssociatedObject(self, &stateLeftKey) integerValue];
}

- (void)setShowLeft:(CGFloat)showLeft
{
    objc_setAssociatedObject(self, &iavHeightLeftKey, [NSNumber numberWithFloat:showLeft], OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)showLeft
{
    CGFloat showhei = [objc_getAssociatedObject(self, &iavHeightLeftKey) floatValue];
    if (showhei == 0.0) {
        return 58;
    }
    else{
        return showhei;
    }
}

- (void)showInputLeftAccessoryViewWithAnimation:(BOOL)animation completion:(void (^)())completion
{
    if (self.inputLeftAccessoryViewState == InputAccessoryViewStatusHide && self.inputLeftAccessoryView_category) {
        [self.inputLeftAccessoryView_category bringToFront];
        [UIView animateWithDuration:(animation == YES)? 0.5 : 0 animations:^{
            self.inputLeftAccessoryView_category.left = 0;
        } completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];
        self.inputLeftAccessoryViewState = InputAccessoryViewStatusShow;
    }
}

- (void)showInputLeftAccessoryViewWithAnimation:(BOOL)animation hight:(CGFloat)height completion:(void (^)())completion
{
    if (self.inputLeftAccessoryViewState == InputAccessoryViewStatusHide && self.inputLeftAccessoryView_category) {
        self.inputLeftAccessoryView_category.left = - height;
        self.inputLeftAccessoryView_category.width = height;
        [self showInputLeftAccessoryViewWithAnimation:animation completion:completion];
    }
}

- (void)hideInputLeftAccessoryViewWithAnimation:(BOOL)animation completion:(void (^)())completion
{
    if (self.inputLeftAccessoryView_category) {
        [UIView animateWithDuration:(animation == YES)? 0.5 : 0 animations:^{
            self.inputLeftAccessoryView_category.right = 0;
        } completion:^(BOOL finished) {
            self.inputLeftAccessoryViewState = InputAccessoryViewStatusHide;
            [self.inputLeftAccessoryView_category removeAllSubviews];
            objc_setAssociatedObject(self, &iavLeftKey, nil, OBJC_ASSOCIATION_RETAIN);
            objc_removeAssociatedObjects(self);
            self.inputLeftAccessoryView_category = nil;
            if (completion) {
                completion();
            }
        }];
    }
}

@end

#pragma mark - show inputAccessory view - Right
static char iavRightKey, stateRightKey, iavHeightRightKey;

@implementation UIView (InputRightAccessoryView_category)

- (void)setInputRightAccessoryView_category:(UIView *)inputRightAccessoryView_category
{
    objc_setAssociatedObject(self, &iavRightKey, inputRightAccessoryView_category, OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)inputRightAccessoryView_category
{
    id obj = objc_getAssociatedObject(self, &iavRightKey);
    if (!obj) {
        UIView * iav = [[UIView alloc]initWithFrame:CGRectMake(self.width, 0, self.showRight, self.height)];
        iav.backgroundColor = [UIColor whiteColor];
        [self setInputRightAccessoryView_category:iav];
        self.inputRightAccessoryView_category.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:self.inputRightAccessoryView_category];
        self.inputRightAccessoryViewState = InputAccessoryViewStatusHide;
    }
    return objc_getAssociatedObject(self, &iavRightKey);
}

- (void)setInputRightAccessoryViewState:(InputAccessoryViewStatus)inputRightAccessoryViewState
{
    objc_setAssociatedObject(self, &stateRightKey, [NSNumber numberWithInteger:inputRightAccessoryViewState], OBJC_ASSOCIATION_RETAIN);
}

- (InputAccessoryViewStatus)inputRightAccessoryViewState
{
    return [objc_getAssociatedObject(self, &stateRightKey) integerValue];
}

- (void)setShowRight:(CGFloat)showRight
{
    objc_setAssociatedObject(self, &iavHeightRightKey, [NSNumber numberWithFloat:showRight], OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)showRight
{
    CGFloat showhei = [objc_getAssociatedObject(self, &iavHeightRightKey) floatValue];
    if (showhei == 0.0) {
        return 58;
    }
    else{
        return showhei;
    }
}

- (void)showInputRightAccessoryViewWithAnimation:(BOOL)animation completion:(void (^)())completion
{
    if (self.inputRightAccessoryViewState == InputAccessoryViewStatusHide && self.inputRightAccessoryView_category) {
        [self.inputRightAccessoryView_category bringToFront];
        [UIView animateWithDuration:(animation == YES)? 0.5 : 0 animations:^{
            self.inputRightAccessoryView_category.right = self.width;
        } completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];
        self.inputRightAccessoryViewState = InputAccessoryViewStatusShow;
    }
}

- (void)showInputRightAccessoryViewWithAnimation:(BOOL)animation hight:(CGFloat)height completion:(void (^)())completion
{
    if (self.inputRightAccessoryViewState == InputAccessoryViewStatusHide && self.inputRightAccessoryView_category) {
        self.inputRightAccessoryView_category.width = height;
        [self showInputRightAccessoryViewWithAnimation:animation completion:completion];
    }
}

- (void)hideInputRightAccessoryViewWithAnimation:(BOOL)animation completion:(void (^)())completion
{
    if (self.inputRightAccessoryView_category) {
        [UIView animateWithDuration:(animation == YES)? 0.5 : 0 animations:^{
            self.inputRightAccessoryView_category.right = self.width;
        } completion:^(BOOL finished) {
            self.inputRightAccessoryViewState = InputAccessoryViewStatusHide;
            [self.inputRightAccessoryView_category removeAllSubviews];
            objc_setAssociatedObject(self, &iavRightKey, nil, OBJC_ASSOCIATION_RETAIN);
            objc_removeAssociatedObjects(self);
            self.inputRightAccessoryView_category = nil;
            if (completion) {
                completion();
            }
        }];
    }
}

@end

#pragma mark - show inputAccessory view - Top
static char iavTopKey, stateTopKey, iavHeightTopKey;

@implementation UIView (InputTopAccessoryView_category)

- (void)setInputTopAccessoryView_category:(UIView *)inputTopAccessoryView_category
{
    objc_setAssociatedObject(self, &iavTopKey, inputTopAccessoryView_category, OBJC_ASSOCIATION_RETAIN);
}

- (UIView *)inputTopAccessoryView_category
{
    id obj = objc_getAssociatedObject(self, &iavTopKey);
    if (!obj) {
        UIView * iav = [[UIView alloc]initWithFrame:CGRectMake(0, - self.showTop, self.width, self.showTop)];
        iav.backgroundColor = [UIColor whiteColor];
        [self setInputTopAccessoryView_category:iav];
        self.inputTopAccessoryView_category.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:self.inputTopAccessoryView_category];
        self.inputTopAccessoryViewState = InputAccessoryViewStatusHide;
    }
    return objc_getAssociatedObject(self, &iavTopKey);
}

- (void)setInputTopAccessoryViewState:(InputAccessoryViewStatus)inputTopAccessoryViewState
{
    objc_setAssociatedObject(self, &stateTopKey, [NSNumber numberWithInteger:inputTopAccessoryViewState], OBJC_ASSOCIATION_RETAIN);
}

- (InputAccessoryViewStatus)inputTopAccessoryViewState
{
    return [objc_getAssociatedObject(self, &stateTopKey) integerValue];
}

- (void)setShowTop:(CGFloat)showTop
{
    objc_setAssociatedObject(self, &iavHeightTopKey, [NSNumber numberWithFloat:showTop], OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)showTop
{
    CGFloat showhei = [objc_getAssociatedObject(self, &iavHeightTopKey) floatValue];
    if (showhei == 0.0) {
        return 58;
    }
    else{
        return showhei;
    }
}

- (void)showInputTopAccessoryViewWithAnimation:(BOOL)animation completion:(void (^)())completion
{
    if (self.inputTopAccessoryViewState == InputAccessoryViewStatusHide && self.inputTopAccessoryView_category) {
        [self showInputTopAccessoryViewWithAnimation:animation top:0 hight:self.showTop completion:completion];
    }
}

- (void)showInputTopAccessoryViewWithAnimation:(BOOL)animation hight:(CGFloat)height completion:(void (^)())completion
{
    if (self.inputTopAccessoryViewState == InputAccessoryViewStatusHide && self.inputTopAccessoryView_category) {
        [self showInputTopAccessoryViewWithAnimation:animation top:0 hight:height completion:completion];
    }
}

- (void)showInputTopAccessoryViewWithAnimation:(BOOL)animation top:(CGFloat)top hight:(CGFloat)height completion:(void (^)())completion
{
    if (self.inputTopAccessoryViewState == InputAccessoryViewStatusHide && self.inputTopAccessoryView_category) {
        [self.inputTopAccessoryView_category bringToFront];
        self.inputTopAccessoryView_category.top = -height;
        self.inputTopAccessoryView_category.height = height;
        [UIView animateWithDuration:(animation == YES)? 0.5 : 0 animations:^{
            self.inputTopAccessoryView_category.top = top;
        } completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];
        self.inputTopAccessoryViewState = InputAccessoryViewStatusShow;
    }
}

- (void)hideInputTopAccessoryViewWithAnimation:(BOOL)animation completion:(void (^)())completion
{
    if (self.inputTopAccessoryView_category) {
        [UIView animateWithDuration:(animation == YES)? 0.5 : 0 animations:^{
            self.inputTopAccessoryView_category.bottom = 0;
        } completion:^(BOOL finished) {
            self.inputTopAccessoryViewState = InputAccessoryViewStatusHide;
            [self.inputTopAccessoryView_category removeAllSubviews];
            objc_setAssociatedObject(self, &iavTopKey, nil, OBJC_ASSOCIATION_RETAIN);
            objc_removeAssociatedObjects(self);
            self.inputTopAccessoryView_category = nil;
            if (completion) {
                completion();
            }
        }];
    }
}

@end