//
//  MovieCollectionViewCell.m
//  MoivePlace
//
//  Created by TNP on 17/2/10.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import "MovieCollectionViewCell.h"
#import "MovieModel.h"
#import "TNPTool.h"
#import "UIImageView+WebCache.h"
#import "Common.h"
#import "ConstantPublicHeader.h"

@implementation MovieCollectionViewCell
#pragma mark - 初始化cell
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        //背景
        UIView *bgV = [[UIView alloc]init];
        bgV.frame = self.bounds;
        bgV.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        [self.contentView addSubview:bgV];
        
        //封面图片
        _m_placeImg = [[UIImageView alloc]init];
        _m_placeImg.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-60);
        _m_placeImg.userInteractionEnabled = YES;
        [self.contentView addSubview:_m_placeImg];
        
        //标题
        _m_title = [[UILabel alloc]init];
        _m_title.frame = CGRectMake(0, CGRectGetMaxY(_m_placeImg.frame), self.bounds.size.width, 40);
        _m_title.textAlignment = NSTextAlignmentCenter;
        _m_title.font = TFont(17);
        _m_title.text = @"功夫瑜伽";
        [bgV addSubview:_m_title];
        
        //时间
        _m_data = [[UILabel alloc]init];
        _m_data.frame = CGRectMake(5, CGRectGetMaxY(_m_title.frame)-5, self.bounds.size.width/2-20, 20);
        _m_data.textColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1];
        _m_data.textAlignment = NSTextAlignmentLeft;
        _m_data.font = TFont(12);
        _m_data.text = @"02-06";
        [bgV addSubview:_m_data];
        
        //类型
        _m_tpyes = [[UILabel alloc]init];
        _m_tpyes.frame = CGRectMake(self.bounds.size.width/2-20, CGRectGetMaxY(_m_title.frame)-5, self.bounds.size.width/2+15, 20);
        _m_tpyes.textColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1];
        _m_tpyes.textAlignment = NSTextAlignmentRight;
        _m_tpyes.font = TFont(12);
        _m_tpyes.text = @"抢先版";
        [bgV addSubview:_m_tpyes];
    }
    return self;
}

//=============
-(void)setM_model:(MovieModel *)m_model
{
    if(m_model == _m_model)
    {
        return;
    }
    
    _m_model = m_model;
    _m_title.text = _m_model.d_name;
    _m_tpyes.text = _m_model.d_remarks;
    
    NSString *time = [NSString stringWithFormat:@"%@",_m_model.d_time];
    if(time.length>=5)
    {
        NSRange timeRang;
        timeRang.length = 5;
        timeRang.location = time.length-5;
        _m_data.text = [time substringWithRange:timeRang];;
    }else
    {
        _m_data.text = _m_model.d_time;
    }
    [[SDWebImageManager sharedManager].imageDownloader setValue:KOutStandDate(kDefaultIndexUrl) forHTTPHeaderField:@"Referer"];
    [_m_placeImg sd_setImageWithURL:[NSURL URLWithString:_m_model.d_picthumb]];
}

@end
