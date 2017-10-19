//
//  MdetailHeadView.m
//  MoivePlace
//
//  Created by TNP on 17/2/16.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import "MdetailHeadView.h"
#import "Common.h"
#import "TNPTool.h"
#define KTipTitleFont   15
@implementation MdetailHeadView
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        
 
        _chooseV = [[MChooseView alloc]initWithFrame:CGRectZero];
        
        [self addSubview:_chooseV];
        
        
        _L = [[UILabel alloc] init];
        _L.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.6];
        [self addSubview:_L];
        
        self.tipTitle = [[UILabel alloc] init];
        self.tipTitle.font = KFONT(KTipTitleFont);
        self.tipTitle.text = @"大家都在看";
        self.tipTitle.textAlignment = NSTextAlignmentLeft;
        self.tipTitle.textColor = [UIColor blackColor];
        [self addSubview:self.tipTitle];
        
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = KFONT(12);
        _subTitleLabel.textAlignment = NSTextAlignmentRight;
        _subTitleLabel.textColor = [UIColor grayColor];
        [self addSubview:_subTitleLabel];
        
        
    }
    return self;
}
-(void)setDetailModel:(MovieDetail *)detailModel
{
    _detailModel = detailModel;
    [self layoutSubviews];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _L.frame = CGRectMake(10, self.bounds.size.height-30, 2.5, 25);
    self.tipTitle.frame = CGRectMake(20, self.bounds.size.height - KTipTitleFont - 10, TScreenWidth-100, KTipTitleFont);
    _subTitleLabel.frame = CGRectMake(100, self.bounds.size.height - KTipTitleFont - 8, TScreenWidth - 100 - 10 , 12);
    if (_detailModel)
    {
        _chooseV.frame = CGRectMake(0, 0, TScreenWidth, [_chooseV configChooseViewWithMovieDetail:_detailModel]);
    }
}

@end
