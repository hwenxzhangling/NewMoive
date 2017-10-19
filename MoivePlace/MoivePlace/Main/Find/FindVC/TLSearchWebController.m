//
//  TLSearchWebController.m
//  1122Tool
//
//  Created by yanglin on 16/10/15.
//  Copyright © 2016年 wapushidai. All rights reserved.
//

#import "TLSearchWebController.h"
#import "CYWebViewController.h"
#import "TLTool.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "UIView+Category.h"
#import "MacrosPublicHeader.h"
#import "UIColor+Extension.h"
#import "ConstantPublicHeader.h"


@interface TLSearchWebController ()<UITextFieldDelegate, UIWebViewDelegate, NJKWebViewProgressDelegate>
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NJKWebViewProgressView *progressView;//进度条
@property (strong, nonatomic) NJKWebViewProgress *progressProxy;//进度代理

@end

@implementation TLSearchWebController
static NSString *ID = @"ID";

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupProgress];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.view addSubview:_progressView];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [_progressView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setLeftBtnHidden:NO];
    
    [self setupView];
    [self loadData];

}

- (void)setupProgress
{
    _progressProxy = [NJKWebViewProgress shaareNJKWebViewProgress];
    _progressProxy.hideHUD = YES;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    _webView.delegate = _progressProxy;
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:CGRectMake(0, self.navBar.height, kMainWidth, 3)];
    _progressView.progressBarView.backgroundColor = [UIColor colorWithPatternImage:KIMG(@"progress")];
    _progressView.backgroundColor = [UIColor colorWithHexString:KBaseOrangeColorHexString];
}


-(void)setupView{
    self.searchBar.text = _keyWords;
    _webView = [[UIWebView alloc] init];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.tag = KBDSearchWebViewTag;
    _webView.frame = CGRectMake(0, KNavBarHeight, kMainWidth, kMainHeight-KNavBarHeight);
    _webView.delegate = self;
    [self.view addSubview:_webView];
}


-(void)loadData{
    if (_webView)
     {
        NSString *ID = KOutStandDate(kBaidu_From);
        NSString *cuid = [TLTool stringWithUUID];
        NSString *str = [NSString stringWithFormat:@"http://m.baidu.com/s?from=%@&pu=%@&word=%@",ID,cuid,_keyWords];
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:str];
        NSString *utf8str = [str stringByAddingPercentEncodingWithAllowedCharacters:set];
        NSURL *url = [NSURL URLWithString:utf8str];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
    }
    
}

-(void)setKeyWords:(NSString *)keyWords{
    _keyWords = keyWords;
    [self.searchBar resignFirstResponder];
    if (keyWords.length) {
        [self loadData];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIWebView Delegate Methods
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //获取到webview的高度
    CGFloat height = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    if (!height)
    {
        height = kMainHeight-self.navBar.height-35;
    }
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress{
    [_progressView setProgress:progress animated:YES];
}


- (void)pushURL:(NSURL *)url
{
    CYWebViewController *webViewController = [[CYWebViewController alloc] init];
    webViewController.url = url;
    webViewController.controllerType = TLBDDeatil;
    webViewController.isShowNavBar = NO;
    webViewController.isShowToolBar = YES;
    webViewController.isShowNewDetails = YES;
    [webViewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.keyWords = textField.text;
    return YES;
}

#pragma mark - UIScorllViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}

@end
