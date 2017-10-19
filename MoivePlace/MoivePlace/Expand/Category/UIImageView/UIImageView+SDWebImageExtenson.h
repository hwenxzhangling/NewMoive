//
//  UIImageView+SDWebImageExtenson.h
//  GSJuZhang
//
//  Created by Kings Yan on 15/5/7.
//  Copyright (c) 2015年 __Qing__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"

@interface UIImageView (SDWebImageExtenson)


/**
 *     设置网络图片，实现在图片加载过程中提示一个网络加载指示
 *
 *     @param url            图片网络上的地址
 *     @param addtional      网络失败后从连的次数
 *     @param completedBlock 加载结束后的回调
 */
- (void)setImageAddtionalIndicatorWithURL:(NSURL *)url addtional:(id)addtional completed:(SDWebImageCompletedBlock)completedBlock;

/**
 *     设置网络图片，实现在图片加载过程中提示一个网络加载指示，可以设置网络加载指示控件的样式
 *
 *     @param indicatorStyle 网络加载指示控件的样式
 *     @param url            图片网络上的地址
 *     @param addtional      网络失败后从连的次数
 *     @param completedBlock 加载结束后的回调
 */
- (void)setImageAddtionalIndicatorWithIndicatorStyle:(UIActivityIndicatorViewStyle)indicatorStyle URL:(NSURL *)url addtional:(id)addtional completed:(SDWebImageCompletedBlock)completedBlock;


@end
