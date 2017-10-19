//
//  TLTool.h
//  1122Tool
//
//  Created by yanglin on 16/10/15.
//  Copyright © 2016年 wapushidai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+Category.h"

@interface TLTool : NSObject

+(TLTool *)TLTool;
/**
 *  设置圆角
 */
+(void)setRoundCornerWithView:(UIView *)view;

/**
 添加缓存路径
 */
+(void)saveRequestWithUrl:(NSString *)url;

/**
 添加缓存
 */
+(void)saveData:(id)data withUrl:(NSString *)url;

/**
 读取缓存
 */
+(id)getDataWithUrl:(NSString *)url;

/**
 生成guid
 */
+ (NSString*)stringWithUUID;



@end
