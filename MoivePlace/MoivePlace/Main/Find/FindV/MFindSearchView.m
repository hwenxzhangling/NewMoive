//
//  MFindSearchView.m
//  MoivePlace
//
//  Created by hewenxue on 17/2/15.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import "MFindSearchView.h"
#import "MacrosPublicHeader.h"
#import "UIView+Category.h"

@interface MFindSearchView()<UITextFieldDelegate>
{
    UIImageView     *_bgSearchView;
    UITextField     *_searchTextFiled;
}
@end

@implementation MFindSearchView
+(MFindSearchView *)findSearchView
{
    MFindSearchView *searchView = [[self alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, KFineSearchViewHeight)];
    return searchView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
        UIImage *bgImg = KIMG(@"sousuo_bg");
        self.backgroundColor = KColor(247, 247, 247);
        _bgSearchView = [[UIImageView alloc] init];
        _bgSearchView.frame = CGRectMake(10, 20, kMainWidth-20, 50);
        _bgSearchView.image = KIMG(@"sousuo_bg");
        _bgSearchView.tag = 100;
        _bgSearchView.userInteractionEnabled = YES;
        [self addSubview:_bgSearchView];
        
        
        _searchTextFiled = [[UITextField alloc] init];
        _searchTextFiled.placeholder = @"百度搜索";
        _searchTextFiled.font = [UIFont systemFontOfSize:14];
        _searchTextFiled.frame = CGRectMake(15, 0, _bgSearchView.width-30, _bgSearchView.height-5);
        _searchTextFiled.rightViewMode = UITextFieldViewModeWhileEditing;
        _searchTextFiled.returnKeyType = UIReturnKeySearch;
        _searchTextFiled.tag = 101;
        _searchTextFiled.delegate = self;
        _searchTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_bgSearchView addSubview:_searchTextFiled];
    }
    return self;
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
