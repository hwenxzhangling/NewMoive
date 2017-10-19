//
//  TLBaseSeachController.m
//  1122Tool
//
//  Created by yanglin on 16/10/15.
//  Copyright © 2016年 wapushidai. All rights reserved.
//

#import "TLBaseSearchController.h"
#import "TLTool.h"
#import "Common.h"
#import "UIColor+Extension.h"
#import "MacrosPublicHeader.h"

@interface TLBaseSearchController ()

@end

@implementation TLBaseSearchController

- (void)setIsHiddenSearchBar:(BOOL)isHiddenSearchBar
{
    _isHiddenSearchBar = isHiddenSearchBar;
    _searchBar.hidden = isHiddenSearchBar;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setupviews];
    [self updateFrames];
    [self setLeftBtnHidden:YES];
}

-(void)setupviews{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _navBar = [[UIView alloc] init];
    _navBar.backgroundColor = [UIColor colorWithHexString:KBaseOrangeColorHexString];
    [self.view addSubview:_navBar];
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.titleLabel.font= [UIFont systemFontOfSize:15];
    _leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    _leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [_leftBtn setImage:KIMG(@"BACK") forState:(UIControlStateNormal)];
    [_leftBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_leftBtn addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_navBar addSubview:_leftBtn];
    
    _searchBar = [[TLSearchBar alloc] initWithTarget:self];
    _searchBar.backgroundColor = [UIColor whiteColor];
    [_navBar addSubview:_searchBar];
}

-(void)updateFrames{
    CGFloat statusBarH = 20;
    CGFloat margin = 15;
    
    _navBarHeight = _navBarHeight==0 ? 64 : _navBarHeight;
    _navBar.frame = CGRectMake(0, 0, kMainWidth, _navBarHeight);
    
    CGFloat btnW = 44;
    CGFloat btnY = statusBarH+(_navBarHeight-statusBarH-btnW)/2;
    _leftBtn.frame = CGRectMake(0, btnY, btnW, btnW);
    _leftBtn.hidden = _leftBtnHidden;
    
    CGFloat searchH = _leftBtnHidden? 36: 32;
    CGFloat searchX = _leftBtnHidden? margin: btnW;
    CGFloat searchY = statusBarH+(_navBarHeight-20-searchH)/2;
    CGFloat searchW = _leftBtnHidden? kMainWidth-margin*2: kMainWidth-btnW-margin;
    
    _searchBar.frame = CGRectMake(searchX, searchY, searchW, searchH);
    [TLTool setRoundCornerWithView:_searchBar];
}

-(void)leftClick{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setLeftBtnHidden:(BOOL)leftBtnHidden{
    _leftBtnHidden = leftBtnHidden;
    [self updateFrames];
}

-(void)setNavBarHeight:(CGFloat)navBarHeight{
    _navBarHeight = navBarHeight;
    [self updateFrames];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

@end
