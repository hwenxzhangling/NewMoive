//
//  CYWebViewController.m
//  CYWebviewController
//
//  Created by 万鸿恩 on 16/5/30.
//  Copyright © 2016年 万鸿恩. All rights reserved.
//

#import "CYWebViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "UIColor+WHE.h"
#import "UIButton+WHE.h"
#import "UIImage+CYButtonIcon.h"
#import "MacrosPublicHeader.h"
#import "UIView+Category.h"

//#import "UIButton+FloatDrag.h"
//#import "ZYSuspensionView.h"

typedef NS_ENUM(NSInteger, CYWebViewControlMode)
{
    /**
     *  微信内置浏览器模式，顶部导航栏带关闭按钮,default value
     */
    CYWebViewControlWechatMode = 0,
    
    /**
     *  Safari浏览器模式，底部包涵toolbars按钮
     */
    CYWebViewControlSafariMode = 1
};

@interface CYWebViewController ()<UIWebViewDelegate,UIActionSheetDelegate,
UIPopoverControllerDelegate,NJKWebViewProgressDelegate>
@property (strong, nonatomic) UIWebView * webView;
@property (nonatomic,strong) NJKWebViewProgressView *progressView;
@property (nonatomic,strong) NJKWebViewProgress *progressProxy;

/**
 *  Get/set the request
 */
@property (nonatomic,strong)    NSMutableURLRequest *urlRequest;


/**
 *  浏览器模式，便于以后控制mode
 */
@property (nonatomic,assign)    CYWebViewControlMode webMode;

/* Navigation Buttons */
/**
 *  Moves the web view one page back
 */
@property (nonatomic,strong) UIBarButtonItem *backButton;

/**
 *  Moves the web view one page forward
 */
@property (nonatomic,strong) UIBarButtonItem *forwardButton;

/**
 *  Reload & Stop buttons
 */
@property (nonatomic,strong) UIBarButtonItem *reloadStopButton;


/**
 *  Shows the UIActivityViewController
 */
@property (nonatomic,strong) UIBarButtonItem *actionButton;

/**
 *  The 'Done' button for modal contorllers
 */
@property (nonatomic,strong) UIBarButtonItem *doneButton;

//分享
@property (nonatomic,strong) UIBarButtonItem *shareButton;

//回到首页
@property (nonatomic,strong) UIBarButtonItem *homeButton;

/**
 *  reload button image
 */
@property (nonatomic,strong) UIImage *reloadImg;

/**
 *  stop button image
 */
@property (nonatomic,strong) UIImage *stopImg;

//忽略UIPopoverController 已经deprecated
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
@property (nonatomic,strong) UIPopoverController *sharingPopoverController;

@property (strong, nonatomic) UIButton *gameBackBtn;    //游戏返回
@property (strong, nonatomic) UIButton *commonBackBtn;  //程序返回


@property (copy,nonatomic)NSString *documentTitle;//网页标题

@end

@implementation CYWebViewController

#pragma mark - Initialize
- (id)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self)
    {
        _url = [self cleanURL:url];
        [self setup];
    }
    return self;
}

- (id)initWithURLString:(NSString *)urlString
{
    self = [super init];
    if (self)
    {
        _url = [self cleanURL:[NSURL URLWithString:urlString]];
        [self setup];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
        [self setup];
    
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
        [self setup];
    
    return self;
}

#pragma mark - set&get
- (void)setUrl:(NSURL *)url
{
    if (self.url == url)
    {
        return;
    }
    _url = [self cleanURL:url];
    
    
}

- (void)setUrlString:(NSString *)urlString
{
    _urlString = urlString;
    _url = [self cleanURL:[NSURL URLWithString:urlString]];
    
}


- (void)setBgcolor:(NSString *)bgcolor
{
    _bgcolor = bgcolor;
    
    [self.view setBackgroundColor:[UIColor colorFromHexString:self.bgcolor]];
    if (self.webView)
    {
        [self.webView setBackgroundColor:[UIColor colorFromHexString:self.bgcolor]];
    }
    
}

- (void)setLoadingBarTintColor:(UIColor *)loadingBarTintColor
{
    if (loadingBarTintColor == _loadingBarTintColor)
    {
        return;
    }
    
    _loadingBarTintColor = loadingBarTintColor;
    
    if (self.progressView)
    {
        NSLog(@"__progressView%@",[self.progressView superview]);
        self.progressView.progressBarView.backgroundColor = _loadingBarTintColor;
    }
}

#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
     self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.webView setBackgroundColor:[UIColor colorFromHexString:self.bgcolor]];
    
    
    CGFloat progressBarHeight = 3.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, 0,navigationBarBounds.size.width, progressBarHeight);
    self.progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    self.loadingBarTintColor = [UIColor blueColor];
    if (self.loadingBarTintColor)
    {
        self.progressView.progressBarView.backgroundColor = self.loadingBarTintColor;
    }
    
    [self.view addSubview:self.webView];
    self.webView.delegate = self.progressProxy;
    
    

    [self loadURL];
    
    //remove the shadow that lines the bottom of the webview
    if (MINIMAL_UI == NO)
    {
        for (UIView *view in self.webView.scrollView.subviews)
        {
            if ([view isKindOfClass:[UIImageView class]] && CGRectGetWidth(view.frame) == CGRectGetWidth(self.view.frame) && CGRectGetMinY(view.frame) > 0.0f + FLT_EPSILON)
                [view removeFromSuperview];
        }
    }
    
    
    //游戏返回按钮（叉叉）
    if (_controllerType == TLGame)
    {
        _gameBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _gameBackBtn.tag = 100;
        _gameBackBtn.frame = CGRectMake(5, 100,47, 47);
        [_gameBackBtn setImage:KIMG(@"djq") forState:UIControlStateNormal];
        [self.view addSubview:_gameBackBtn];
        
        //拖动
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(changeLocation:)];
        pan.delaysTouchesBegan = YES;
        [_gameBackBtn addGestureRecognizer:pan];
        
        //点击
        [_gameBackBtn addTarget:self action:@selector(backGameBtnClick) forControlEvents:UIControlEventTouchUpInside];

    //常用返回按钮
    }else
    {
        _commonBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.webView.width-40-8, 20,40, 40)];
//        [_commonBackBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -60)];
        [self.view addSubview:_commonBackBtn];
        [self.view bringSubviewToFront:_commonBackBtn];
        [_commonBackBtn addTarget:self action:@selector(backCommBtnClick) forControlEvents:UIControlEventTouchUpInside];

        if(_controllerType == TLCommon)
        {
            [_commonBackBtn setImage:KIMG(@"best_close") forState:UIControlStateNormal];
            _commonBackBtn.hidden = NO;
        }else
        {
            _commonBackBtn.hidden = YES;
        }

    }
}

//拖动按钮
- (void)changeLocation:(UIPanGestureRecognizer*)p{
    CGPoint panPoint = [p locationInView:self.view];
    NSLog(@"%@",NSStringFromCGPoint(panPoint));
    
    //位置
    if(p.state == UIGestureRecognizerStateChanged)
    {
        _gameBackBtn.center = CGPointMake(panPoint.x, panPoint.y);
    }else if(p.state == UIGestureRecognizerStateEnded)
    {
        CGFloat left = fabs(panPoint.x);
        CGFloat right = fabs(self.view.bounds.size.width - left);
        CGFloat minSpace = MIN(left, right);
        CGPoint newCenter;
        CGFloat targetY = 0;
        
        //校正Y
        if (panPoint.y < _gameBackBtn.bounds.size.height/2+20) {
            targetY = _gameBackBtn.bounds.size.height/2+20;
        }else if (panPoint.y > (kMainHeight - _gameBackBtn.bounds.size.height/2)) {
            targetY = kMainHeight - _gameBackBtn.bounds.size.width/2;
        }else{
            targetY = panPoint.y;
        }
        
        //矫正X
        if (minSpace == left) {
            newCenter = CGPointMake(0+_gameBackBtn.bounds.size.width/2, targetY);
        }else if (minSpace == right) {
            newCenter = CGPointMake(kMainWidth-_gameBackBtn.bounds.size.width/2, targetY);
        }
        [UIView animateWithDuration:.25 animations:^{
            _gameBackBtn.center = newCenter;
        }];
    }
    
}


/**
 更新返回按钮的frame
 */
-(void)updateBtnFrame{
    if (_gameBackBtn.centerX>kMainWidth/2) {
        [UIView animateWithDuration:.25 animations:^{
            _gameBackBtn.center = CGPointMake(kMainWidth - _gameBackBtn.width/2, _gameBackBtn.centerY);
        }];
    }
    
}


//常用点击返回
- (void)backCommBtnClick
{
    if(_controllerType == TLCommon)
    {
        if(self.isGotoLogin)
        {
            NSMutableArray *VCs = [NSMutableArray array];
            [VCs addObjectsFromArray:self.navigationController.viewControllers];
            NSArray *newVCs = [[VCs reverseObjectEnumerator] allObjects];
           
            BOOL isFindBackVC = NO;
            for (UIViewController *vc in newVCs)
            {
//                if([vc isKindOfClass:[TLSearchWebController class]] ||
//                   [vc isKindOfClass:[TLAllCommonController class]] ||
//                   [vc isKindOfClass:[TLCommonlyViewController class]])
//                {
//                    isFindBackVC = YES;
//                    [self.navigationController popToViewController:vc animated:YES];
//                    break;
//                }
            }
            if(!isFindBackVC)
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        }else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else
    {
        NSLog(@"分享");
    }
}

//游戏点击返回
-(void)backGameBtnClick{
    if (_gameBackBtn.tag == 100) {
        _gameBackBtn.tag = 101;
        _gameBackBtn.width = 93;
        [_gameBackBtn setImage:KIMG(@"djh") forState:UIControlStateNormal];
        [self updateBtnFrame];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _gameBackBtn.tag = 100;
        _gameBackBtn.width = 47;
        [_gameBackBtn setImage:KIMG(@"djq") forState:UIControlStateNormal];
        [self updateBtnFrame];
    });
}

#pragma mark - Setup
- (void)setup
{
    _progressProxy = [NJKWebViewProgress shaareNJKWebViewProgress];
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    _bgcolor = nil;
    _bgcolor = @"f4f4f4";
    
    _showWebPageTitle = YES;
    _showURLWhileLoading = NO;
    _showActionButton = YES;
    _showDoneButton = YES;
    
    _webMode = CYWebViewControlWechatMode;
    
    
    _backIcon = [UIImage cy_backButtonIcon:[UIColor whiteColor]];
    
    self.urlRequest = [[NSMutableURLRequest alloc] init];
}

- (NSURL *)cleanURL:(NSURL *)url{
    //If no URL scheme was supplied, defer back to HTTP.
    if (url.scheme.length == 0) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[url absoluteString]]];
    }
    return url;
}



#pragma mark - method
- (void)showLoadingTitle{
    //显示URL在加载的时候
    if (self.url && self.showWebPageTitle && self.showURLWhileLoading) {
        NSString *url = [_url absoluteString];
        url = [url stringByReplacingOccurrencesOfString:@"http://" withString:@""];
        url = [url stringByReplacingOccurrencesOfString:@"https://" withString:@""];
        self.title = url;
    }else if (self.showWebPageTitle){
        self.title = @"加载中..";
    }
}

-(void)loadURL
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.urlRequest setURL:self.url];
        [self.webView loadRequest:self.urlRequest];
        [self showLoadingTitle];
    });
}

#pragma mark- NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [self.progressView setProgress:progress animated:YES];
    
    if (self.showWebPageTitle)
    {
        if(self.isShowNewDetails)
        {
            self.documentTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
            KSaveStandDate(self.documentTitle, NSStringFromSelector(@selector(setIsShowNewDetails:)));
          //[self setNavTitle: self.documentTitle];
        }
    }
    [self refreshButtonsStatus];
}

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)pushURL:(NSURL *)url
{
    CYWebViewController *webViewController = [[CYWebViewController alloc] init];
    webViewController.url = url;
    webViewController.controllerType = TLXZDeatil;
    webViewController.isShowNavBar = NO;
    webViewController.isShowToolBar = YES;
    webViewController.isShowNewDetails = YES;
    [webViewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark- 微信模式 点击事件
-(void)clickedbackBtn:(UIButton*)btn
{
    if (self.webView.canGoBack)
    {
        [self setupLeftNavigationBarBtn];
        [self.webView goBack];
    }else{
        
        if(self.isGotoLogin)
        {
            NSMutableArray *VCs = [NSMutableArray array];
            [VCs addObjectsFromArray:self.navigationController.viewControllers];
            NSArray *newVCs = [[VCs reverseObjectEnumerator] allObjects];
            
            BOOL isFindBackVC = NO;
            for (UIViewController *vc in newVCs)
            {
//                if([vc isKindOfClass:[TLSearchWebController class]] ||
//                   [vc isKindOfClass:[TLAllCommonController class]] ||
//                   [vc isKindOfClass:[TLCommonlyViewController class]])
//                {
//                    isFindBackVC = YES;
//                    [self.navigationController popToViewController:vc animated:YES];
//                    break;
//                }
            }
            if(!isFindBackVC)
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        }else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)clickedcloseBtn:(UIButton*)btn
{
    NSLog(@"navbarViewcontrllers Index0:%@",self.navigationController.viewControllers[0]);
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)checkBePresentedModally
{
    if (self.navigationController && self.navigationController.presentingViewController)
    {
         return ([self.navigationController.viewControllers indexOfObject:self] == 0);
    }
    else
    {
         return ([self presentingViewController] != nil);
    }
    return NO;
}

- (BOOL)onTopOfNavigationControllerStack
{
    if (self.navigationController == nil)
    {
         return NO;
    }
    
    if ([self.navigationController.viewControllers count] &&
        [self.navigationController.viewControllers indexOfObject:self] > 0)
    {
         return YES;
    }
    
    return NO;
}


#pragma mark - Hidden bottom toolbars (微信浏览器模式)
-(void)setupLeftNavigationBarBtn{
    
    UIView * customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 88, 44)];
    
    UIButton *backBtn = [UIButton buttonBackWithImage:_backIcon buttontitle:@"返回" target:self action:@selector(clickedbackBtn:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [customView addSubview:backBtn];
    
    
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [closeBtn addTarget:self action:@selector(clickedcloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.frame = CGRectMake(38, 0, 44, 44);
    [closeBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [customView addSubview:closeBtn];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    
}

#pragma mark Safari mode

- (void)setNavigationButtons
{
    if (self.backButton == nil)
    {
        self.backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage cy_backButtonIcon:nil] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClicked:)];
    }
    if (self.forwardButton == nil)
    {
        self.forwardButton = [[UIBarButtonItem alloc] initWithImage:[UIImage cy_forwardButtonIcon] style:UIBarButtonItemStylePlain target:self action:@selector(forwardBtnClicked:)];
    }
    if (self.reloadStopButton == nil)
    {
        self.reloadImg = [UIImage cy_refreshButtonIcon];
        self.stopImg = [UIImage cy_stopButtonIcon];
        
        
        self.reloadStopButton = [[UIBarButtonItem alloc] initWithImage:self.reloadImg style:UIBarButtonItemStylePlain target:self action:@selector(reloadAndStopBtnClicked:)];
    }
    
    if(self.shareButton == nil)
    {
        self.shareButton = [[UIBarButtonItem alloc] initWithImage:KIMG(@"fenxiang") style:UIBarButtonItemStylePlain target:self action:@selector(shareBtnClicked:)];
    }
    
    if(self.homeButton == nil)
    {
        
        self.homeButton = [[UIBarButtonItem alloc] initWithImage:KIMG(@"home") style:UIBarButtonItemStylePlain target:self action:@selector(homeBtnClicked:)];
    }
    
    
    
    if (self.actionButton == nil && self.showActionButton)
    {
        self.actionButton = [[UIBarButtonItem alloc] initWithImage:[UIImage cy_actionButtonIcon] style:UIBarButtonItemStylePlain target:self action:@selector(actionBtnClicked:)];
        if (MINIMAL_UI) {
            CGFloat topInset = -2.0f;
            self.actionButton.imageInsets = UIEdgeInsetsMake(topInset, 0.0f, -topInset, 0.0f);
        }
    }
    
    
    //创建完成按钮，对于Presented Modally
    if (self.showDoneButton && [self checkBePresentedModally] && ![self onTopOfNavigationControllerStack])
    {
        if (self.doneBtnTitle)
        {
            self.doneButton = [[UIBarButtonItem alloc] initWithTitle:self.doneBtnTitle style:UIBarButtonItemStyleDone target:self action:@selector(doneBtnClicked:)];
        }else{
            self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtnClicked:)];
        }
    }
}


- (void)layoutBottomNavigationToolbars
{
    if (self.isShowToolBar)
    {
        [self.navigationController setToolbarHidden:NO animated:NO];
        //init
        self.toolbarItems = nil;
        self.navigationItem.leftBarButtonItems = nil;
        self.navigationItem.rightBarButtonItems = nil;
        self.navigationItem.leftItemsSupplementBackButton = NO;
        
        // Set up the Done button if presented modally
        if (self.doneButton)
        {
            self.navigationItem.rightBarButtonItem = self.doneButton;
        }
        
        //Set up array of buttons
        NSMutableArray *items = [NSMutableArray array];
        
        if (self.backButton)
        {
            [items addObject:self.backButton];
        }
        if (self.forwardButton)
        {
            [items addObject:self.forwardButton];
        }
        
        if(self.homeButton)
        {
            [items addObject:self.homeButton];
        }
        
//        if (self.actionButton){
//            [items addObject:self.actionButton];
//        }
        if (self.reloadStopButton)
        {
            [items addObject:self.reloadStopButton];
        }
        
        if(self.shareButton)
        {
            [items addObject:self.shareButton];
        }
        
        
        UIBarButtonItem *(^flexibleSpace)() = ^
        {
            return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        };
        
        BOOL lessThanFiveItems = items.count < 5;
        
        NSInteger index = 1;
        NSInteger itemsCount = items.count-1;
        for (NSInteger i = 0; i < itemsCount; i++) {
            [items insertObject:flexibleSpace() atIndex:index];
            index += 2;
        }
        
        if (lessThanFiveItems) {
            [items insertObject:flexibleSpace() atIndex:0];
            [items addObject:flexibleSpace()];
        }
        
        self.toolbarItems = items;
        
        [self refreshButtonsStatus ];
        
        return;
        
    }
}
#pragma mark - toolbar button status
- (void)refreshButtonsStatus{
    //[self.webView canGoBack] ? [self.backButton setEnabled:YES]:[self.backButton setEnabled:NO];
    NSLog(@"self.webView canGoForward:%@",@([self.webView canGoForward]));
    [self.webView canGoForward] ? [self.forwardButton setEnabled:YES]:[self.forwardButton setEnabled:NO];
    BOOL loaded = (self.progressProxy.progress >= 1.0f - FLT_EPSILON);
    
    loaded ? [self.reloadStopButton setImage:self.reloadImg]:[self.reloadStopButton setImage:self.stopImg];
}


#pragma mark - Button action
- (void)backBtnClicked:(id)sender
{
    if([self.webView canGoBack])
    {
        [self.webView goBack];
        [self refreshButtonsStatus];
    }else
    {
        [self.navigationController setToolbarHidden:YES animated:YES];
        [self leftClick];
    }
    
//    [self.webView goBack];
//    [self refreshButtonsStatus];
}
- (void)forwardBtnClicked:(id)sender
{
    [self.webView goForward];
    [self refreshButtonsStatus];
}
- (void)reloadAndStopBtnClicked:(id)sender
{
    BOOL loaded = (self.progressProxy.progress >= 1.0f - FLT_EPSILON);
    
    //regardless of reloading, or stopping, halt the webview
    [self.webView stopLoading];
    
    if (loaded)
    {
        //In certain cases, if the connection drops out preload or midload,
        //it nullifies webView.request, which causes [webView reload] to stop working.
        //This checks to see if the webView request URL is nullified, and if so, tries to load
        //off our stored self.url property instead
        if (self.webView.request.URL.absoluteString.length == 0 && self.url)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                  [self.webView loadRequest:self.urlRequest];
            });
        }
        else {
            [self.webView reload];
        }
    }
    
    //refresh the buttons
    [self refreshButtonsStatus];
}


- (void)shareBtnClicked:(id)sender
{
    //分享
}

- (void)homeBtnClicked:(id)sender
{
    //回到首页
    NSLog(@"回到首页");
    [self.navigationController setToolbarHidden:YES animated:NO];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)actionBtnClicked:(id)sender
{
    //Do nothing if there is no url for action
    if (!self.url)
    {
        return;
    }
    if (NSClassFromString(@"UIPresentationController"))
    {
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.url] applicationActivities:nil];
        activityViewController.modalPresentationStyle = UIModalPresentationPopover;
        activityViewController.popoverPresentationController.barButtonItem = self.actionButton;
        [self presentViewController:activityViewController animated:YES completion:nil];
    }
    else if (NSClassFromString(@"UIActivityViewController"))
    {
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.url] applicationActivities:nil];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            //If we're on an iPhone, we can just present it modally
            [self presentViewController:activityViewController animated:YES completion:nil];
        }
        else
        {
            //UIPopoverController requires we retain our own instance of it.
            //So if we somehow have a prior instance, clean it out
            if (self.sharingPopoverController)
            {
                [self.sharingPopoverController dismissPopoverAnimated:NO];
                self.sharingPopoverController = nil;
            }
     //忽略UIPopoverController 已经deprecated
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
            
            //Create the sharing popover controller
            self.sharingPopoverController = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
            self.sharingPopoverController.delegate = self;
            [self.sharingPopoverController presentPopoverFromBarButtonItem:self.actionButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            
#pragma GCC diagnostic pop
        }
    }
    
}
- (void)doneBtnClicked:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//忽略UIPopoverController 已经deprecated
#pragma clang diagnostic pop

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    //Once the popover controller is dismissed, we can release our own reference to it
    self.sharingPopoverController = nil;
}


#pragma mark - webview
- (UIWebView *)webView
{
    if (!_webView)
    {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, (self.isShowNavBar?KNavBarHeight:0), kMainWidth, kMainHeight- (self.isShowNavBar?KNavBarHeight:0)-(self.isShowToolBar?40:0))];
        
        _webView.scrollView.bounces = NO;
        _webView.delegate =self;
        _webView.scalesPageToFit = YES;
        //_webView.scrollView.delegate = self;
        _webView.allowsInlineMediaPlayback = YES;
        _webView.tag = self.webViewTag;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleWidth|
        UIViewAutoresizingFlexibleTopMargin;
        _webView.contentMode = UIViewContentModeRedraw;
        _webView.opaque = YES;
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    return _webView;
}

#pragma mark-scrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if(velocity.y>0)
    {
        [UIView animateWithDuration:0.4 animations:^
        {
            if(self.isShowToolBar)
            {
                _webView.height = kMainHeight-(self.isShowNavBar?KNavBarHeight:0);
              [self.navigationController setToolbarHidden:YES animated:YES];
            }
        }];
    }else
    {
        [UIView animateWithDuration:0.4 animations:^
        {
            if(self.isShowToolBar)
            {
                 _webView.height = kMainHeight-(self.isShowNavBar?KNavBarHeight:0)-(self.isShowToolBar?40:0);
                [self.navigationController setToolbarHidden:NO animated:YES];
            }
        }];
    }
}


#pragma mark - 是否显示导航栏

- (void)setControllerType:(TLControllerType)controllerType
{
    _controllerType = controllerType;
    if(self.controllerType == TLXZDeatil)
    {
        self.webView.frame = CGRectMake(0,(_isShowNavBar?KNavBarHeight:20), kMainWidth, kMainHeight-(_isShowNavBar?KNavBarHeight:20)-40);
        self.view.backgroundColor = [UIColor whiteColor];
        
    }else if(self.controllerType == TLBDDeatil)
    {
        self.webView.frame = CGRectMake(0,(_isShowNavBar?KNavBarHeight:0), kMainWidth, kMainHeight-(_isShowNavBar?KNavBarHeight:0)-40);
    }else
    {
        self.webView.frame = CGRectMake(0,(_isShowNavBar?KNavBarHeight:0), kMainWidth, kMainHeight-(_isShowNavBar?KNavBarHeight:0));
    }
}


- (void)setIsShowNavBar:(BOOL)isShowNavBar
{
    _isShowNavBar = isShowNavBar;
   
    //改变进度条位置
    if(_isShowNavBar)
    {
        self.progressView.top = KNavBarHeight-3;
        self.loadingBarTintColor = [UIColor colorWithPatternImage:KIMG(@"progress")];
        
    }else
    {
        self.progressView.top = 0;
    }
}

#pragma mark- 是否显示工具栏
- (void)setIsShowToolBar:(BOOL)isShowToolBar
{
    _isShowToolBar = isShowToolBar;
    [self updateToolState];
}

- (void)updateToolState
{
    if(self.isShowToolBar)
    {
        [self setNavigationButtons];
        [UIView performWithoutAnimation:^
         {
             [self layoutBottomNavigationToolbars];
         }];
    }
}

#pragma mark-  viewWillAppear or viewDidDisappear
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.controllerType == TLGame || self.controllerType == TLCommon)
    {
       [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else
    {
       [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    [self.navigationController setToolbarHidden:YES animated:NO];
    [self setup];
    
    [self updateToolState];
    [self.view addSubview:self.progressView];

    //设置Title
    if(self.isShowNewDetails)
    {
        //[self setNavTitle:KOutStandDate(NSStringFromSelector(@selector(setIsShowNewDetails:)))];
    }else
    {
        
    }
    
    if(self.controllerType == TLXZDeatil ||
       self.controllerType == TLBDDeatil)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    }else
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    [self.navigationController setToolbarHidden:YES animated:NO];
    if(self.progressView && [self.progressView superview])
    {
        [self.progressView removeFromSuperview];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
     NSLog(@"WebViewController viewDidDisappear: %@",NSStringFromClass([self class]));
    //[self webRelease];
}

- (void)dealloc
{
    NSLog(@"WebViewController dealloc: %@",NSStringFromClass([self class]));

    [self webRelease];
}

- (void)webRelease
{
    [_webView reload];//停止声音
    _progressView = nil;
    _progressProxy = nil;
    _webView = nil;
    _webView.delegate = nil;
}

- (void)leftClick
{
    [self.navigationController setToolbarHidden:YES animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
