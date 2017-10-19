//
//  MMovieLunchConfiguration.m
//  MoivePlace
//
//  Created by hewenxue on 17/2/13.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import "MMovieLunchConfiguration.h"
#import "NetworkPublicHeader.h"
#import "MacrosPublicHeader.h"
#import "SDWebImageManager.h"
#import "IQKeyboardManager.h"
#import "AvoidCrash.h"
#import <Small/Small.h>

@implementation MMovieLunchConfiguration
+(MMovieLunchConfiguration *)shareLunchConfiguration
{
    return [[self alloc] init];
}

- (void)run;
{
    [self performSelector:@selector(loadServceConfiguration) withObject:nil afterDelay:0.01];
    [self setupKeyboard];
    [self setupAvoidCrash];
    
    
//    [Small setUpWithComplection:^{
//        
//        NSLog(@"alleBundle:%@",[Small allBundles]);
//        
//        UIViewController *mainController = [Small controllerForUri:@"video"];
//        NSLog(@"---------:%@",mainController);
//    }];
}

//请求并存储后台配置
- (void)loadServceConfiguration
{
    //请求并存储默认配置信息
    [MNetworkManager getDefaultIndexSuccess:^(NSString *urlStr)
    {
        
    } failure:^(NSError *error)
    {
        NSLog(@"-loadServceConfiguration,error:%@",error);
    }];
    
    //请求并存储分享地址信息
    [MNetworkManager getDefaultStartSuccess:^(DefaultStart *defaulStart) {
        
     } failure:^(NSError *error)
     {
         NSLog(@"-loadServceConfiguration,error:%@",error);
     }];
}

//键盘
- (void)setupKeyboard{
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

//防止崩溃
- (void)setupAvoidCrash{
#ifdef DEBUG
#else
    [AvoidCrash becomeEffective];
#endif
}

@end
