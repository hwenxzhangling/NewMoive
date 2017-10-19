//
//  UpDataVersionView.m
//  Jest
//
//  Created by TNP on 16/9/18.
//  Copyright © 2016年 TNP. All rights reserved.
//

#import "UpDataVersionView.h"
#import "Common.h"
#import "Image_h.h"
#import "UIView+Category.h"
#import "MacrosPublicHeader.h"
#import "UIColor+Extension.h"

@interface UpDataVersionView()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *_view;
    NSArray *_titleArray;
}
@end
@implementation UpDataVersionView
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
        //_titleArray = @[@"1、投稿支持gif图上传",@"2、修复iOS10字体显示不全",@"3、优化界面",@"4、修复大量的Bug"];
        self.bounds = CGRectMake(0, 0, kMainWidth, kMainHeight);
        _view = [[UIView alloc]initWithFrame:CGRectMake((kMainWidth-234)/2, (kMainHeight-303)/2, 468/2, 606/2)];
        _view.backgroundColor = [UIColor whiteColor];
        [self addSubview:_view];
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        UIImageView *iconImg = [[UIImageView alloc]init];
        iconImg.frame = CGRectMake((_view.frame.size.width-80)/2, 20, 80, 80);
        iconImg.image = [KIMG(@"calendar_update_img_download")tintColorWithColor:[UIColor colorWithHexString:KBaseOrangeColorHexString]];
        iconImg.left = (_view.width-iconImg.image.size.width)/2.0f;
        iconImg.height = iconImg.image.size.height;
        iconImg.width = iconImg.image.size.width;
        
        [_view addSubview:iconImg];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iconImg.frame)+15, _view.frame.size.width, 17)];
        title.text = @"软件更新提示";
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont systemFontOfSize:17];
        [_view addSubview:title];
        
        UITableView *content = [[UITableView alloc]initWithFrame:CGRectMake((234-170)/2, CGRectGetMaxY(title.frame)+15, 170, 110) style:UITableViewStylePlain];
        content.dataSource = self;
        content.delegate = self;
        content.separatorStyle = NO;
        [_view addSubview:content];
        
        NSArray *tit = @[@"取消",@"下载更新"];
        for (int i = 0; i<2; i++)
        {
            UIButton *yesOrNoBtn = [[UIButton alloc]initWithFrame:CGRectMake((234-196)/3+(96+((234-196)/3))*i, CGRectGetMaxY(content.frame)+10, 98, 32)];
            [yesOrNoBtn setTitle:tit[i] forState:UIControlStateNormal];
            yesOrNoBtn.tag = 100+i;
            [yesOrNoBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
            yesOrNoBtn.backgroundColor = i==0?[UIColor whiteColor]:[UIColor colorWithHexString:KBaseOrangeColorHexString];
            yesOrNoBtn.clipsToBounds = YES;
            yesOrNoBtn.layer.cornerRadius = 2;
            yesOrNoBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [yesOrNoBtn setTitleColor:i==0?[UIColor blackColor]:[UIColor whiteColor] forState:(UIControlStateNormal)];
            if (i==0)
            {
                [yesOrNoBtn.layer setBorderWidth:0.5];
                [yesOrNoBtn.layer setBorderColor:[[UIColor blackColor] CGColor]];
            }
            [_view addSubview:yesOrNoBtn];
        }
    }
        return self;
}
-(void)setUpStr:(NSString *)upStr
{
    _upStr = upStr;
    if (_upStr.length)
    {
        _titleArray = [_upStr componentsSeparatedByString:@"\n"];
    }
}
-(void)btnClick:(UIButton *)sender
{
    if (sender.tag == 100)
    {
        [self removeFromSuperview];
    }
    else
    {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:nil]];

    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getRectWithStr:_titleArray[indexPath.row]]+5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UILabel *content = [[UILabel alloc]init];
        content.lineBreakMode = NSLineBreakByTruncatingHead;
        content.tag = 1000;
        content.textAlignment = NSTextAlignmentLeft;
        content.textColor = [UIColor colorWithHexString:KBaseOrangeColorHexString];
        content.numberOfLines = 0;
       
        [cell.contentView addSubview:content];
    }
    UILabel *content = (UILabel *)[cell viewWithTag:1000];
    content.frame = CGRectMake(0, 0, 170, [self getRectWithStr:_titleArray[indexPath.row]]);
    content.attributedText = [self getAttributedWithStr:_titleArray[indexPath.row]];
    
    cell.selectionStyle = NO;
    return cell;
}
-(NSMutableAttributedString *)getAttributedWithStr:(NSString *)str
{
    NSMutableAttributedString *contentText = [[NSMutableAttributedString alloc] initWithString:(str.length == 0)?@"":str];
    [contentText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, contentText.length)];
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:6];
    [paragraphStyle1 setLineBreakMode:NSLineBreakByWordWrapping];
    [contentText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, contentText.length)];
    return contentText;
}
-(CGFloat)getRectWithStr:(NSString *)str
{
    CGFloat maxContentWidth = 170;
    CGRect contentRect = [[self getAttributedWithStr:str] boundingRectWithSize:CGSizeMake(maxContentWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return contentRect.size.height;
}
@end
