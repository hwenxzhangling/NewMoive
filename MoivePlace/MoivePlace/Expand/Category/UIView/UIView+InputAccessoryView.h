//
//  UIView+InputAccessoryView.h
//  Cooking
//
//  Created by Kings Yan on 14-9-13.
//  Copyright (c) 2014年 ___GoGo___. All rights reserved.
//

#import <UIKit/UIKit.h>



/**
 *    inputAccessoryView 视图状态枚举
 */
typedef NS_ENUM(NSUInteger, InputAccessoryViewStatus)
{
    InputAccessoryViewStatusHide = 0,  //        隐藏
    InputAccessoryViewStatusShow = 1,  //        显示
};



@interface UIView (InputAccessoryView_extention)


/**
 *     inputAccessoryView 显示时的阴影对象
 */
@property (nonatomic, strong) UIButton *inputAccessoryView_mask;


@end



/**
 *     靠下面的 inputAccessoryView
 */
@interface UIView (InputAccessoryView_category)


/**
 *     inputAccessoryView 视图定义
 */
@property (nonatomic, strong) UIView *inputAccessoryView_category;

/**
 *     inputAccessoryView 状态定义
 */
@property (nonatomic, assign) InputAccessoryViewStatus inputAccessoryViewState;

/**
 *     设置 inputAccessoryView 显示的高度，默认是 60。
 */
@property (nonatomic, assign) CGFloat showHeight; // < default is 60.

/**
 *     显示 inputAccessoryView 视图的方法
 *
 *     @param animation  是否开启动画过度
 *     @param mask       是否打开阴影
 *     @param completion 显示完成后回调闭包体
 */
- (void)showInputAccessoryViewWithAnimation:(BOOL)animation mask:(BOOL)mask completion:(void (^)())completion;

/**
 *     显示 inputAccessoryView 视图的方法
 *
 *     @param animation  是否开启动画过度
 *     @param mask       是否打开阴影
 *     @param height     显示的高度
 *     @param completion 显示完成后回调闭包体
 */
- (void)showInputAccessoryViewWithAnimation:(BOOL)animation
                                       mask:(BOOL)mask
                                      hight:(CGFloat)height
                                 completion:(void (^)())completion;

/**
 *     隐藏 inputAccessoryView 的方法
 *
 *     @param animation  是否开启动画过度
 *     @param completion 隐藏完成后回调闭包体
 */
- (void)hideInputAccessoryViewWithAnimation:(BOOL)animation completion:(void (^)())completion;


@end



/**
 *     靠左边的 inputAccessoryView
 */
@interface UIView (InputLeftAccessoryView_category)


/**
 *     inputAccessoryView 视图定义
 */
@property (nonatomic, strong) UIView *inputLeftAccessoryView_category;

/**
 *     inputAccessoryView 状态定义
 */
@property (nonatomic, assign) InputAccessoryViewStatus inputLeftAccessoryViewState;

/**
 *     设置 inputAccessoryView 显示的高度，默认是 60。
 */
@property (nonatomic, assign) CGFloat showLeft; // < default is 60.

/**
 *     显示 inputAccessoryView 视图的方法
 *
 *     @param animation  是否开启动画过度
 *     @param mask       是否打开阴影
 *     @param completion 显示完成后回调闭包体
 */
- (void)showInputLeftAccessoryViewWithAnimation:(BOOL)animation completion:(void (^)())completion;

/**
 *     显示 inputAccessoryView 视图的方法
 *
 *     @param animation  是否开启动画过度
 *     @param mask       是否打开阴影
 *     @param height     显示的高度
 *     @param completion 显示完成后回调闭包体
 */
- (void)showInputLeftAccessoryViewWithAnimation:(BOOL)animation
                                          hight:(CGFloat)height
                                     completion:(void (^)())completion;

/**
 *     隐藏 inputAccessoryView 的方法
 *
 *     @param animation  是否开启动画过度
 *     @param completion 隐藏完成后回调闭包体
 */
- (void)hideInputLeftAccessoryViewWithAnimation:(BOOL)animation completion:(void (^)())completion;


@end



/**
   right of inputAccessoryView
 */
@interface UIView (InputRightAccessoryView_category)

/**
 *     inputAccessoryView 视图定义
 */
@property (nonatomic, strong) UIView *inputRightAccessoryView_category;

/**
 *     inputAccessoryView 状态定义
 */
@property (nonatomic, assign) InputAccessoryViewStatus inputRightAccessoryViewState;

/**
 *     设置 inputAccessoryView 显示的高度，默认是 60。
 */
@property (nonatomic, assign) CGFloat showRight; // < default is 60.

/**
 *     显示 inputAccessoryView 视图的方法
 *
 *     @param animation  是否开启动画过度
 *     @param mask       是否打开阴影
 *     @param completion 显示完成后回调闭包体
 */
- (void)showInputRightAccessoryViewWithAnimation:(BOOL)animation completion:(void (^)())completion;

/**
 *     显示 inputAccessoryView 视图的方法
 *
 *     @param animation  是否开启动画过度
 *     @param mask       是否打开阴影
 *     @param height     显示的高度
 *     @param completion 显示完成后回调闭包体
 */
- (void)showInputRightAccessoryViewWithAnimation:(BOOL)animation
                                           hight:(CGFloat)height
                                      completion:(void (^)())completion;

/**
 *     隐藏 inputAccessoryView 的方法
 *
 *     @param animation  是否开启动画过度
 *     @param completion 隐藏完成后回调闭包体
 */
- (void)hideInputRightAccessoryViewWithAnimation:(BOOL)animation completion:(void (^)())completion;


@end



/**
   top of inputAccessoryView
 */
@interface UIView (InputTopAccessoryView_category)


/**
 *     inputAccessoryView 视图定义
 */
@property (nonatomic, strong) UIView *inputTopAccessoryView_category;

/**
 *     inputAccessoryView 状态定义
 */
@property (nonatomic, assign) InputAccessoryViewStatus inputTopAccessoryViewState;

/**
 *     设置 inputAccessoryView 显示的高度，默认是 60。
 */
@property (nonatomic, assign) CGFloat showTop; // < default is 60.

/**
 *     显示 inputAccessoryView 视图的方法
 *
 *     @param animation  是否开启动画过度
 *     @param mask       是否打开阴影
 *     @param completion 显示完成后回调闭包体
 */
- (void)showInputTopAccessoryViewWithAnimation:(BOOL)animation completion:(void (^)())completion;

/**
 *     显示 inputAccessoryView 视图的方法
 *
 *     @param animation  是否开启动画过度
 *     @param height     显示的高度
 *     @param completion 显示完成后回调闭包体
 */
- (void)showInputTopAccessoryViewWithAnimation:(BOOL)animation
                                         hight:(CGFloat)height
                                    completion:(void (^)())completion;

/**
 *     显示 inputAccessoryView 视图的方法
 *
 *     @param animation  是否开启动画过度
 *     @param top        显示的起始位置
 *     @param height     显示的高度
 *     @param completion 显示完成后回调闭包体
 */
- (void)showInputTopAccessoryViewWithAnimation:(BOOL)animation
                                           top:(CGFloat)top
                                         hight:(CGFloat)height
                                    completion:(void (^)())completion;

/**
 *     隐藏 inputAccessoryView 的方法
 *
 *     @param animation  是否开启动画过度
 *     @param completion 隐藏完成后回调闭包体
 */
- (void)hideInputTopAccessoryViewWithAnimation:(BOOL)animation completion:(void (^)())completion;


@end



/**
 *     辅助该类的计算 frame 值的工具类，被该类调用。
 */
@interface UIView (QSInputCFrame)
//sets frame.origin.x = left;
@property (nonatomic) CGFloat qsileft;
//sets frame.origin.y = top;
@property (nonatomic) CGFloat qsitop;
//sets frame.origin.x = right - frame.size.wigth;
@property (nonatomic) CGFloat qsiright;
//sets frame.origin.y = botton - frmae.size.height;
@property (nonatomic) CGFloat qsibottom;
//sets frame.size.width = width;
@property (nonatomic) CGFloat qsiwidth;
//sets frame.size.height = height;
@property (nonatomic) CGFloat qsiheight;
//sets center.x = centerX;
@property (nonatomic) CGFloat qsicenterX;
//sets center.y = centerY;
@property (nonatomic) CGFloat qsicenterY;
//frame.origin
@property (nonatomic) CGPoint qsiorigin;
//frame.size
@property (nonatomic) CGSize qsisize;
- (void)qsiremoveAllSubviews;
- (void)qsibringToFront;
@end
