//
//  MFind_N_CollectionViewCell.m
//  MoivePlace
//
//  Created by hewenxue on 17/2/15.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import "MFind_N_CollectionViewCell.h"
#import "UIView+Category.h"
#import "MacrosPublicHeader.h"

@implementation MFind_N_CollectionViewCell
#pragma mark - 初始化cell
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //背景
        UIView *bgV = [[UIView alloc]init];
        bgV.backgroundColor = [UIColor whiteColor];
        bgV.frame = self.bounds;
        [self.contentView addSubview:bgV];
        
        //封面图片
        _picImv = [[UIImageView alloc]init];
        _picImv.frame = CGRectMake(15, (self.height-40)/2.0, 40, 40);
        _picImv.userInteractionEnabled = YES;
        _picImv.image = KIMG(@"ico_动图");
        [bgV addSubview:_picImv];
        
        
        //标题
        _titleLable = [[UILabel alloc]init];
        _titleLable.frame = CGRectMake(_picImv.right+25, (self.height-40)/2.0, self.width-30, 40);
        _titleLable.textAlignment = NSTextAlignmentLeft;
        _titleLable.font = [UIFont systemFontOfSize:15];
        _titleLable.text = @"福利视频";
        [bgV addSubview:_titleLable];
        
        self.backgroundColor = KColor(247, 247, 247);
        bgV.frame = UIEdgeInsetsInsetRect(bgV.frame, UIEdgeInsetsMake(0, 1, 1, 0));
    }
    return self;
}

- (void)setModel:(MFAppModel *)model
{
    if(_model == model)
        return;
    _model = model;
    
    [_picImv sd_setImageWithURL:[NSURL URLWithString:model.logo_url]];
    _titleLable.text = model.name;
}

@end
