//
//  TLTool.m
//  1122Tool
//
//  Created by yanglin on 16/10/15.
//  Copyright © 2016年 wapushidai. All rights reserved.
//

#import "TLTool.h"
#import "NSString+MD5.h"


@implementation TLTool

+(TLTool *)TLTool;
{
    static TLTool *_tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(_tool == nil)
        {
            _tool = [[TLTool alloc] init];
        }
    });
    return _tool;
}

/**
 *  设置圆角
 */
+(void)setRoundCornerWithView:(UIView *)view{
    //创建圆角路径
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:view.size];
    //创建形状图层
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

/**
 添加缓存路径
 */
+(void)saveRequestWithUrl:(NSString *)url{
//    static NSMutableArray *dataArr;
//    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:[TLTool p_filePathWithUrlString:KUserCommonUrl]];
//    if (arr){
//        dataArr = [arr mutableCopy];
//        //没有就加入
//        if (![dataArr containsObject:url]){
//            [dataArr addObject:url];
//            [NSKeyedArchiver archiveRootObject:dataArr toFile:[TLTool p_filePathWithUrlString:KUserCommonUrl]];
//            [TLTool addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:[TLTool p_filePathWithUrlString:KUserCommonUrl]]];
//        }else{
//            //有 替换
//            NSInteger index = [dataArr indexOfObject:url];
//            [dataArr replaceObjectAtIndex:index withObject:url];
//            [NSKeyedArchiver archiveRootObject:dataArr toFile:[TLTool p_filePathWithUrlString:KUserCommonUrl]];
//            [TLTool addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:[TLTool p_filePathWithUrlString:KUserCommonUrl]]];
//        }
//    } else{
//        dataArr = [NSMutableArray array];
//        [dataArr addObject:url];
//        [NSKeyedArchiver archiveRootObject:dataArr toFile:[TLTool p_filePathWithUrlString:KUserCommonUrl]];
//        [TLTool addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:[TLTool p_filePathWithUrlString:KUserCommonUrl]]];
//    }
}

/**
 添加缓存
 */
+(void)saveData:(id)data withUrl:(NSString *)url{
    
    [NSKeyedArchiver archiveRootObject:data toFile:[self p_filePathWithUrlString:url]];
    [TLTool addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:[self p_filePathWithUrlString:url]]];
}

/**
 读取缓存
 */
+(id)getDataWithUrl:(NSString *)url{
    id data = [NSKeyedUnarchiver unarchiveObjectWithFile:[self p_filePathWithUrlString:url]];
    return data;
}

/**
 根据url返回缓存文件路径
 */
+ (NSString *)p_filePathWithUrlString:(NSString *)urlString{
    NSString *cachesPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"UserCommon"];
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:cachesPath]){
        [[NSFileManager defaultManager]createDirectoryAtPath:cachesPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *fileName = [NSString md5:urlString];
    return [cachesPath stringByAppendingPathComponent:fileName];
}

/**
 *  添加iCloud不备份
 *
 *  @param URL 文件夹地址
 *
 */
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES] forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(success){
        //NSLog(@"不被备份");
    }
    else{
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

/**
 生成guid
 */
+ (NSString*)stringWithUUID{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);
    NSString    *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return uuidString;
}




@end
