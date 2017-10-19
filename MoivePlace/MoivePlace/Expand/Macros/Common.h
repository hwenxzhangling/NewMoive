//
//  Common.h
//  Music
//
//  Created by dengwei on 16/1/2.
//  Copyright (c) 2016年 dengwei. All rights reserved.
//

#ifndef Common_h
#define Common_h

//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))


//设备型号
#define IS_IPAD     [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
#define IS_IPHONE   [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )480) < DBL_EPSILON )
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )568) < DBL_EPSILON )
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )667) < DBL_EPSILON )
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )960) < DBL_EPSILON )

//系统版本
#define IS_IOS_VERSION   floorf([[UIDevice currentDevice].systemVersion floatValue]
#define IS_IOS_5    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==5.0 ? 1 : 0
#define IS_IOS_6    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==6.0 ? 1 : 0
#define IS_IOS_7    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==7.0 ? 1 : 0
#define IS_IOS_8    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==8.0 ? 1 : 0
#define IS_IOS_9    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==9.0 ? 1 : 0


//视图高度
#define KNavBarHeight 64
#define KTabBarHeight 49
#define kCellHeight 44
#define kMyCellHeight (186/2)
#define kMainWidth ([[UIScreen mainScreen] bounds].size.width)
#define kMainHeight ([[UIScreen mainScreen] bounds].size.height)

//文本地址
#define kDocumentPath ([NSHomeDirectory() stringByAppendingPathComponent:@"Documents"])

//设置字体大小
#define KFONT(size) [UIFont systemFontOfSize:size]
#define KFONTBOLD(size) [UIFont boldSystemFontOfSize:size]

//获取本地图片
#define KIMG(name) [UIImage imageNamed:name]
#define KPathImage(name) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:name ofType:@"png"]]
//用户本地文件
#define KStandardUserDefaults [NSUserDefaults standardUserDefaults]
//存
#define KSaveStandDate(obj,key) [[NSUserDefaults standardUserDefaults]setObject:obj forKey:key];\
[[NSUserDefaults standardUserDefaults] synchronize]
//取
#define KOutStandDate(key) [[NSUserDefaults standardUserDefaults]objectForKey:key]
//发通知
#define KPOSTNotification(name,obj,userinfo) [[NSNotificationCenter defaultCenter]postNotificationName:name object:obj userInfo:userinfo]
#define KPOSTFastNotification(NAME,obj) [[NSNotificationCenter defaultCenter]postNotificationName:NAME object:obj]
//接收通知
#define KAddNotification(Observer,SEL,Name,obj) [[NSNotificationCenter defaultCenter]addObserver:Observer selector:SEL name:Name object:obj]
//移除通知
#define KRemoveAllNotification [[NSNotificationCenter defaultCenter]removeObserver:self]
#define KRemoveNotification(Observer,NAME,obj) [[NSNotificationCenter defaultCenter]removeObserver:Observer name:NAME object:obj];
//设置颜色
#define KColor_a(r,g,b,a)  [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define KColor(r,g,b)  [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define KColorRandom [UIColor colorWithRed:arc4random()%255/255.0f green:arc4random()%255/255.0f blue:arc4random()%255/255.0f alpha:1.0]

//上一个View y轴的坐标点
#define UpViewY(YV) YV.frame.origin.y+YV.frame.size.height
//上一个View x轴的坐标点
#define UpViewX(XV) XV.frame.origin.x+XV.frame.size.width
//俯视图高的一半
#define SUPERVIEWHEIGHT(view) view.bounds.size.height/2
//俯视图宽的一半
#define SUPERVIEWIDTH(view) view.bounds.size.width/2

#define KMiShowThremeColor KColor(231, 0, 128)
//设备高度
#define KISIPHONE4S (kMainHeight<568?YES:NO)

#define KISIPHONE5S (kMainHeight==568?YES:NO)
#define KISIPHONE5SFollowing (kMainHeight<=568?YES:NO)
//NSUserDefaults 实例化
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

// 用户ID
#define KUserUid [AccountTool account].uid
#define KUserDidLogin [AccountTool account]
#define KAuthSignLogin @"1" //是否需要登录




/****************Jest 里面的宏*************************/


// 3.自定义Log
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...)
#endif

#endif
