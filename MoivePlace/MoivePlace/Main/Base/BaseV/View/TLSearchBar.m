//
//  TLSearchBar.m
//  1122Tool
//
//  Created by yanglin on 16/10/13.
//  Copyright © 2016年 wapushidai. All rights reserved.
//

#import "TLSearchBar.h"
#import "UIImage+TBCityIconFont.h"
#import "MacrosPublicHeader.h"
#import "UIColor+Extension.h"


@interface TLSearchBar ()
@property (strong, nonatomic) UIImageView *leftIV;
@property (strong, nonatomic) UIImageView *rightIV;

@end

@implementation TLSearchBar

-(instancetype)initWithTarget:(id)target{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@"搜索你想看的电影、电视" attributes:@{NSForegroundColorAttributeName : [UIColor grayColor]}];
        self.attributedPlaceholder = attr;
        self.textColor = [UIColor grayColor];
        self.tintColor = [UIColor grayColor];
        self.textAlignment = NSTextAlignmentLeft;
        self.font = [UIFont systemFontOfSize:12];
        self.returnKeyType = UIReturnKeySearch;
        self.delegate = target;
        self.searchBarDelegate = target;
        [self addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
        
        TBCityIconInfo *info = [TBCityIconInfo iconInfoWithText:KTLFont_Search_iconUnicode size:40 color:[UIColor colorWithHexString:KBaseOrangeColorHexString]];
        UIImage *leftImg = [UIImage iconWithInfo:info];
        _leftIV = [[UIImageView alloc] initWithImage:leftImg];
        _leftIV.contentMode = UIViewContentModeScaleAspectFit;
        self.leftView = _leftIV;
        //_leftIV.backgroundColor = [UIColor redColor];
        self.leftViewMode = UITextFieldViewModeAlways;
        
        _rightIV = [[UIImageView alloc] initWithImage:KIMG(@"delete")];
        _rightIV.contentMode = UIViewContentModeScaleAspectFit;
        //_rightIV.backgroundColor = [UIColor redColor];
        _rightIV.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightViewClick:)];
        [_rightIV addGestureRecognizer:tap];
        
        self.rightView = _rightIV;
        self.rightViewMode = UITextFieldViewModeWhileEditing;
    }
    return self;
}

-(void)editingChanged:(id)sender{
    if (_searchBarDelegate && [_searchBarDelegate respondsToSelector:@selector(searchBarValueChange:)]) {
        [self.searchBarDelegate searchBarValueChange:self];
    }
}

- (void)rightViewClick:(UIButton *) textField{
    
    [self resignFirstResponder];
    self.text = @"";
    if (_searchBarDelegate && [_searchBarDelegate respondsToSelector:@selector(searchBarValueChange:)]) {
        [self.searchBarDelegate searchBarValueChange:self];
    }
}

-(CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGFloat h = bounds.size.height*0.9;
    CGFloat w = bounds.size.height*1.2;
    CGFloat y = (bounds.size.height - h)/2;
    CGFloat x = 0;
    return CGRectMake(x, y, w, h);
}

-(CGRect)rightViewRectForBounds:(CGRect)bounds{
    CGFloat h = bounds.size.height*0.55;
    CGFloat w = bounds.size.height*1.2;
    CGFloat y = (bounds.size.height - h)/2;
    CGFloat x = bounds.size.width - w;
    return CGRectMake(x, y, w, h);
}

-(CGRect)textRectForBounds:(CGRect)bounds{
    CGFloat x = bounds.size.height*1.2;
    CGFloat y = 0;
    CGFloat h = bounds.size.height;
    CGFloat w = bounds.size.width - 2*x;
    return CGRectMake(x, y, w, h);
}


- (void)reset;
{
    [self resignFirstResponder];
    self.text = @"";
}

@end
