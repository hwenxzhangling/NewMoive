//
//  CYWebViewController.h
//  CYWebviewController
//
//  Created by 万鸿恩 on 16/5/30.
//  Copyright © 2016年 万鸿恩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "UIWebView+extension.h"
#import "TLBaseSearchController.h"
//#import "UIButton+FloatDrag.h"

typedef NS_ENUM(NSInteger, TLControllerType)
{
    TLOther     = 0, //其他
    TLCommon    = 1, //应用 是webview加载
    TLInJump    = 2, //是内部跳转
    TLGame      = 3,  //游戏
    TLXZDeatil  = 5,   //资讯详情
    TLBDDeatil  = 4   //百度搜索详情
};

/* Detect if we're running iOS 7.0 or higher (With the new minimal UI) */
#define MINIMAL_UI      ([[UIViewController class] instancesRespondToSelector:@selector(edgesForExtendedLayout)])


/**
 *  返回系统语言对应的文字
 *
 *  @param key 关键字
 */
#define CYLocalize(key) NSLocalizedString(key, nil)
@interface CYWebViewController : UIViewController<UIScrollViewDelegate>
@property (assign, nonatomic)TLControllerType controllerType;
@property (nonatomic,assign)BOOL                isShowNavBar;//是否要显示导航栏 //默认是不显示 NO
@property (nonatomic,assign)BOOL                isShowToolBar;//是否要底部工具栏 //默认是不显示 NO
@property (nonatomic,assign)BOOL                isShowNewDetails;//新闻资讯详情Title //默认是不显示 YES
@property (nonatomic,assign)NSInteger           webViewTag;//webView Tag 唯一标示
@property (nonatomic,assign)BOOL                isGotoLogin;//是否是经过登录界面进入的app，YES是 默认NO；
/**
 *  url string
 */
@property (nonatomic, strong) NSString *urlString;

/**
 *  website url
 */
@property (nonatomic,strong) NSURL *url;



/**
 * The tint colour of the page loading progress bar.
 * If not set on iOS 7 and above, the loading bar will defer to the app's global UIView tint color.
 * If not set on iOS 6 or below, it will default to the standard system blue tint color.
 *
 * Default value is nil.
 */
@property (nonatomic,copy)      UIColor *loadingBarTintColor;



/**
 * webview bg color
 */
@property (nonatomic,copy)      NSString *bgcolor;


/**
 *  show URL while web loading. 
 *  Default value is NO.
 */
@property (nonatomic,assign)    BOOL showURLWhileLoading;

/**
 *  Show web page title.
 *  Default value is Yes.
 */
@property (nonatomic,assign)    BOOL showWebPageTitle;



/**
 *  Show action button.
 *  Default value is Yes.
 */
@property (nonatomic,assign)    BOOL showActionButton;



/**
 Shows the Done button when presented modally. When tapped, it dismisses the view controller.
 
 Default value is YES.
 */
@property (nonatomic,assign)    BOOL showDoneButton;


/**
 *  If desired, override the title of the system 'Done' button to this string.
 *  Default value is nil.
 */
@property (nonatomic,copy)    NSString *doneBtnTitle;


/**
 *  Wechat Mode, back button icon. If no set, has default image
 */
@property (nonatomic,strong)  UIImage *backIcon;



/**
 *  Initializes object with url
 *
 *  @param url webpage url
 *
 *  @return CYWebViewController object
 */
- (id)initWithURL:(NSURL *)url;


/**
 *  Initializes object with url string
 *
 *  @param urlString webpage url string
 *
 *  @return CYWebViewController object
 */
- (id)initWithURLString:(NSString *)urlString;


@end
