//
//  MFindHeadView.m
//  MoivePlace
//
//  Created by hewenxue on 17/2/15.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import "MFindHeadView.h"
#import "TNPTool.h"
#import "BHInfiniteScrollView.h"
#import "UIColor+Extension.h"
#import "MacrosPublicHeader.h"
#import "UIView+Category.h"

#define KTipTitleFont     15
@interface MFindHeadView()<UITextFieldDelegate>
{
    UIView          *_gourpView;
    UIImageView     *_bgSearchView;
}
@end

@implementation MFindHeadView
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = KColor(247, 247, 247);
        _bgSearchView = [[UIImageView alloc] init];
        _bgSearchView.frame = CGRectMake(10, 20, kMainWidth-20, 50);
        _bgSearchView.image = KIMG(@"sousuo_bg");
        _bgSearchView.tag = 100;
        _bgSearchView.hidden = YES;
        _bgSearchView.userInteractionEnabled = YES;
        [self addSubview:_bgSearchView];
        
        
        UITextField *_searchTextFiled = [[UITextField alloc] init];
        _searchTextFiled.placeholder = @"百度搜索";
        _searchTextFiled.font = [UIFont systemFontOfSize:14];
        _searchTextFiled.frame = CGRectMake(15, 0, _bgSearchView.width-30, 50);
        _searchTextFiled.rightViewMode = UITextFieldViewModeWhileEditing;
        _searchTextFiled.returnKeyType = UIReturnKeySearch;
        _searchTextFiled.tag = 101;
        _searchTextFiled.delegate = self;
        _searchTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_bgSearchView addSubview:_searchTextFiled];
        
        
        _gourpView = [[UIView alloc] init];
        _gourpView.userInteractionEnabled = YES;
        _gourpView.backgroundColor = [UIColor  whiteColor];
        [self addSubview:_gourpView];
        
        
        self.tipTitle = [[UILabel alloc] init];
        self.tipTitle.font = TFont(KTipTitleFont);
        self.tipTitle.text = @"生活服务";
        self.tipTitle.textAlignment = NSTextAlignmentLeft;
        self.tipTitle.textColor = [UIColor blackColor];
        self.tipTitle.backgroundColor = [UIColor clearColor];
        [_gourpView addSubview:self.tipTitle];
        
        
        _moreLable = [[UILabel alloc] init];
        _moreLable.font = TFont(KTipTitleFont);
        _moreLable.text = @"更多";
        _moreLable.backgroundColor = [UIColor whiteColor];
        _moreLable.textAlignment = NSTextAlignmentRight;
        _moreLable.textColor = [UIColor blackColor];
        _moreLable.userInteractionEnabled = YES;
        [_gourpView addSubview:_moreLable];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreAction)];
        [_moreLable addGestureRecognizer:tap];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _bgSearchView.frame = CGRectMake(10, 20, kMainWidth-20, 50);
    
    _gourpView.frame = CGRectMake(0, self.height-40, kMainWidth, 40);
    _gourpView.frame = UIEdgeInsetsInsetRect(_gourpView.frame, UIEdgeInsetsMake(0, 0, 1, 0));
    
    self.tipTitle.frame = CGRectMake(15, 1, TScreenWidth-100, 40-2);
    _moreLable.frame = CGRectMake(kMainWidth-80, 1, 70, 40-2);
}

- (void)setSearchShow:(BOOL)searchShow
{
    _searchShow = searchShow;
    UIImageView *bgSearchView = [self viewWithTag:100];
    bgSearchView.hidden = !searchShow;
    [self setNeedsLayout];
}

- (void)moreAction
{
    if(self.m_delegate && [self.m_delegate respondsToSelector:@selector(MFindHeadViewMoreClick:)])
    {
        [self.m_delegate MFindHeadViewMoreClick:self.model];
    }
}

#pragma mark-UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(self.m_delegate && [self.m_delegate respondsToSelector:@selector(MFindHeadViewSearchValue:)])
    {
            [self.m_delegate MFindHeadViewSearchValue:textField.text];
    }
    [textField resignFirstResponder];
    return self;
}

@end
