//
//  MdetailHeadView.h
//  MoivePlace
//
//  Created by TNP on 17/2/16.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MChooseView.h"
@interface MdetailHeadView : UICollectionReusableView
//选集View
@property (nonatomic,strong)MChooseView *chooseV;
//选集View detailModel
@property (nonatomic,strong)MovieDetail *detailModel;
@property (strong, nonatomic) UILabel *L;
//电影分组标题
@property (nonatomic,strong)UILabel *tipTitle;
//副标题(正在播放第2集）
@property (strong, nonatomic) UILabel *subTitleLabel;
@end
