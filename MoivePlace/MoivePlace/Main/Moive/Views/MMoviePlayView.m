//
//  MMoviePlayView.m
//  MoivePlace
//
//  Created by hewenxue on 17/2/14.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import "MMoviePlayView.h"
#import "MacrosPublicHeader.h"
#import "UIView+Category.h"
#import "UIImageView+WebCache.h"
#import "UIColor+Extension.h"
@implementation MMoviePlayView

+ (MMoviePlayView *)playView
{
    MMoviePlayView *v = [[self alloc] initWithFrame:CGRectMake(0, 0, kMainWidth, KMMoviePlayViewHeight)];
    return v;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {

        _backView = [[UIView alloc]init];
        _backView.userInteractionEnabled = YES;
        _backView.frame = CGRectMake(0, 0, self.width, self.height-40);
        _backView.backgroundColor = [UIColor blackColor];
        [self addSubview:_backView];
        
        self.moviePicImv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-40)];
        self.moviePicImv.contentMode = UIViewContentModeScaleAspectFit;
        self.moviePicImv.userInteractionEnabled = YES;
        self.moviePicImv.backgroundColor = [UIColor blackColor];
        [_backView addSubview:self.moviePicImv];
        
        _pauseOrPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseOrPlayBtn setBackgroundImage:[UIImage imageNamed:@"zanting"] forState:UIControlStateNormal];
        _pauseOrPlayBtn.clipsToBounds = YES;
        _pauseOrPlayBtn.layer.cornerRadius = 30;
        _pauseOrPlayBtn.frame = CGRectMake((self.bounds.size.width-60)/2, (self.bounds.size.height-60-40)/2, 60, 60);
        [_pauseOrPlayBtn addTarget:self action:@selector(pauseOrPlayBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_pauseOrPlayBtn];
        _pauseOrPlayBtn.hidden = YES;
        
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(10, self.height-35, kMainWidth-70,30);
        _titleLabel.font = KFONT(17);
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
        
        self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
        
    }
    return self;
}


- (void)setDetailModel:(MovieDetail *)detailModel
{
     _detailModel = detailModel;
     _titleLabel.text = [NSString stringWithFormat:@"来源于优酷:  %@",_detailModel.d_name];
    NSLog(@"--------:%@",_detailModel.d_name);
    
    [_moviePicImv sd_setImageWithURL:[NSURL URLWithString:_detailModel.d_picthumb]];
     _pauseOrPlayBtn.hidden = NO;
}

#pragma mark-pauseOrPlayBtnAction
- (void)pauseOrPlayBtnAction
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(MMoviePlayViewButtonPlay)])
    {
        [self.delegate MMoviePlayViewButtonPlay];
    }
}

@end
