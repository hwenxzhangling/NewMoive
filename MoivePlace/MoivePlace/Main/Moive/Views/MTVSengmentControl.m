//
//  MTVSengmentControl.m
//  MoivePlace
//
//  Created by hewenxue on 17/4/1.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import "MTVSengmentControl.h"
#import "UIView+Category.h"
#import "Common.h"
#import "UIColor+Extension.h"
#import "MacrosPublicHeader.h"

#define KAreaWidth (kMainWidth/5)
#define KCataryBtnTag 100

@interface MTVSengmentControl()
@property (nonatomic,strong)UIScrollView *bgScrollView;
@property (nonatomic,strong)UIView       *sliderView;
@property (nonatomic,strong)UIButton     *tempBtn;
@end

@implementation MTVSengmentControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.height = KMTVSengmentControlHeight;
    if(self)
    {
        _bgScrollView = [[UIScrollView alloc] init];
        _bgScrollView.bounces = NO;
        [self addSubview:_bgScrollView];
        
        _sliderView = [[UIView alloc] init];
        _sliderView.backgroundColor = [UIColor redColor];
        [_bgScrollView addSubview:_sliderView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _bgScrollView.frame = CGRectMake(0, 0, self.width, self.height);
    _sliderView.frame = CGRectMake(0, self.height-3, KAreaWidth, 3);
}

- (void)setMTVCataryArray:(NSArray *)MTVCataryArray
{
    if(MTVCataryArray == _MTVCataryArray)
    {
        return;
    }
    _MTVCataryArray = MTVCataryArray;
    _bgScrollView.contentSize = CGSizeMake(KAreaWidth*_MTVCataryArray.count, 0);
    [self createMTVCatarysubViews];
}

- (void)createMTVCatarysubViews
{
    CGFloat x = 0;
    int  i = 0;
    for (id obj in _MTVCataryArray)
    {
        UIButton *catarybutton = [[UIButton alloc] init];
        catarybutton.frame = CGRectMake(x, 0, KAreaWidth , self.height-3);
        catarybutton.titleLabel.font = [UIFont systemFontOfSize:15];
        catarybutton.tag = (KCataryBtnTag+i);
        x += KAreaWidth;
        if(i == 0)
        {
            [catarybutton setTitleColor:[UIColor colorWithHexString:KBaseOrangeColorHexString] forState:UIControlStateNormal];
        }else
        {
            [catarybutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        if([obj isKindOfClass:[MovieCategory class]])
        {
            MovieCategory *mCategory = (MovieCategory *)obj;
            [catarybutton setTitle:mCategory.t_name forState:UIControlStateNormal];
        }
       
        [catarybutton addTarget:self action:@selector(catarybuttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_bgScrollView addSubview:catarybutton];
        i++;
    }
}

- (void)catarybuttonAction:(UIButton *)btn
{
    if(btn == _tempBtn) return;
    
    if(_tempBtn)
        [_tempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [btn setTitleColor:[UIColor colorWithHexString:KBaseOrangeColorHexString]
              forState:UIControlStateNormal];
    _tempBtn = btn;
    
    if(self.sengmentControlBlock) 
    {
        self.sengmentControlBlock((btn.tag-KCataryBtnTag));
    }
}

- (void)setSelectIndex:(NSInteger)index;
{
    if(_tempBtn)
        [_tempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIButton *btn = [_bgScrollView viewWithTag:(KCataryBtnTag+index)];
    [btn setTitleColor:[UIColor colorWithHexString:KBaseOrangeColorHexString]
              forState:UIControlStateNormal];
    _tempBtn = btn;
    
    [_bgScrollView setContentOffset:CGPointMake(kMainWidth*(index/5), 0) animated:YES];
    [UIView animateWithDuration:0.2 animations:^{
        _sliderView.left = KAreaWidth*index;
    }];
}


@end
