//
//  TLSearchWebController.h
//  1122Tool
//
//  Created by yanglin on 16/10/15.
//  Copyright © 2016年 wapushidai. All rights reserved.
//

#import "TLBaseSearchController.h"
#import "TLTool.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import "CYWebViewController.h"
#import "CYWebViewController.h"


@interface TLSearchWebController : TLBaseSearchController
@property (copy, nonatomic) NSString *keyWords;
@property (assign, nonatomic) TLControllerType type;


@end
