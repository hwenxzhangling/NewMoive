//
//  TNPTool.h
//  马桶段子
//
//  Created by TNP on 16/11/9.
//  Copyright © 2016年 WPSD. All rights reserved.
//

#ifndef TNPTool_h
#define TNPTool_h
/**********************此区域放一些定义的常量 数字类型*/
#define TScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define TScreenHeight ([[UIScreen mainScreen] bounds].size.height)
#define TNavBarHeight 64
#define TTabBarHeight 49
#define TCellHeight 44
#define TViewWidth(view)        view.frame.size.width
#define TViewHeight(view)       view.frame.size.height
#define TViewOriginX(view)      view.frame.origin.x
#define TViewOriginY(view)      view.frame.origin.y
#define TRectM(x, y, w, h)      CGRectMake(x, y, w, h)
#define TSizeM(w,h)             CGSizeMake(w,h)
#define TEdgeM(top, left, bottom, right) UIEdgeInsetsMake(top, left, bottom, right)


/**********************此区域放一些快捷用法*/
/**设置字体大小*/
#define TFont(size) [UIFont systemFontOfSize:size]
#define TFontBold(size) [UIFont boldSystemFontOfSize:size]

//获取本地图片
#define TImg(imagenamed) [UIImage imageNamed:imagenamed]
#define TPathImage(imagenamed) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:imagenamed ofType:@"png"]]

/**数据存本地*/
#define TUserDefaults [NSUserDefaults standardUserDefaults]
#define TWriteDate(obj,key) [TUserDefaults setObject:obj forKey:key];\
[TUserDefaults synchronize]
/**取出数据*/
#define TOutDate(key) [TUserDefaults objectForKey:key]
/**发通知*/
#define TNotificationCenter [NSNotificationCenter defaultCenter]
#define TPostNotification(name,obj,userinfo) [TNotificationCenter postNotificationName:name object:obj userInfo:userinfo]
#define TPostFastNotification(name,obj) [TNotificationCenter postNotificationName:name object:obj]
/**接收通知*/
#define TAddObserverNotification(SEL,Name,obj) [TNotificationCenter addObserver:self selector:SEL name:Name object:obj]
/**移除通知*/
#define TRemoveAllNotification [TNotificationCenter removeObserver:self]
#define TRemoveNotification(Observer,Name,obj) [TNotificationCenter removeObserver:Observer name:Name object:obj];
/**设置颜色*/
#define TColor_a(r,g,b,a)  [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define TColor(r,g,b)  [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0]
#define TColorRandom [UIColor colorWithRed:arc4random()%255/255.0f green:arc4random()%255/255.0f blue:arc4random()%255/255.0f alpha:1.0]
//清除背景色
#define TCLEARCOLOR [UIColor clearColor]
/**获取Document根目录路径地址*/
#define TDocumentsPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
/**获取Library根目录路径地址*/
#define TLibraryPath NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0]
/**获取Caches根目录路径地址*/
#define TCachesPath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]
/**获取window视图*/
#define TMainWindow [[UIApplication sharedApplication].delegate window]
/**强弱引用*/
#define TWeakSelf(obj)  __weak typeof(obj) weak##obj = obj;
#define TStrongSelf(obj)  __strong typeof(obj) obj = weak##obj;
//字符串是否为空
#define TStringIsEmpty(str) (([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1) ? YES : NO )
//数组是否为空
#define TArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define TDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
//是否是空对象
#define TObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))
/**********************此区域放一些通知*/


/**********************此区域放系统的属性*/
/**UUID*/
#define TUUID [WpsAppModel AppModel].uuid
/**设备型号*/
#define IS_IPAD     [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
#define IS_IPHONE   [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )480) < DBL_EPSILON )
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )568) < DBL_EPSILON )
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )667) < DBL_EPSILON )
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )960) < DBL_EPSILON )

/**系统版本*/
#define IS_IOS_VERSION   floorf([[UIDevice currentDevice].systemVersion floatValue])
#define IS_IOS_5    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==5.0 ? 1 : 0
#define IS_IOS_6    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==6.0 ? 1 : 0
#define IS_IOS_7    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==7.0 ? 1 : 0
#define IS_IOS_8    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==8.0 ? 1 : 0
#define IS_IOS_9    floorf([[UIDevice currentDevice].systemVersion floatValue]) ==9.0 ? 1 : 0
/**********************此区域放一些通知*/
/**给view添加边缘线条 */
#define TClipsRounded(view,radius,color,borderWidth) view.layer.cornerRadius = radius;\
view.clipsToBounds = YES;\
[view.layer setBorderColor:[color CGColor]];\
[view.layer setBorderWidth:borderWidth]
/**********************此区域放第三方的key*/


/**********************第三方再封装*/
//如果没有引入头文件 或者没有库 可以注释掉此区域
#define TMBShowSuccess(str) [MBProgressHUD showSuccess:str]
#define TMBShowError(str) [MBProgressHUD showError:str]
/**********************其他*/
/**创建单例的宏定义方法 SingletonH 在点h文件中用  SingletonM点m文件中*/
#define SingletonH(name) + (instancetype)shared##name;
#define SingletonM(name) \
static id _instance; \
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
\
+ (instancetype)shared##name \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
}\
\
- (id)mutableCopyWithZone:(NSZone *)zone { \
return _instance; \
}
/**GCD*/
//GCD - 一次性执行
//GCD - 回到主线程^{} == block
#define TDISPATCH_MAIN_THREAD(block) dispatch_async(dispatch_get_main_queue(), block);
//GCD - 开启异步线程^{}
#define TDISPATCH_GLOBAL_QUEUE(block) dispatch_async(dispatch_get_global_queue(0, 0), block);

#endif
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#   define TLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define TLog(...)
#endif
