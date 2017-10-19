//
//  TLBaseSeachController.h
//  1122Tool
//
//  Created by yanglin on 16/10/15.
//  Copyright © 2016年 wapushidai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TLSearchBar.h"

@interface TLBaseSearchController : UIViewController
@property (strong, nonatomic) UIView *navBar;
@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) TLSearchBar *searchBar;
@property (assign, nonatomic) BOOL leftBtnHidden;   //返回按钮是否隐藏，默认显示
@property (assign, nonatomic) CGFloat navBarHeight; //导航栏高，默认64

@property (assign, nonatomic)BOOL isHiddenSearchBar; //YES 隐藏
-(void)leftClick;
@end
