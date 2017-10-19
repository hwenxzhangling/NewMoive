//
//  MHeaderView.h
//  MoivePlace
//
//  Created by TNP on 17/2/10.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import "MovieModel.h"
#define KMHeaderViewHeight (kMainHeight/4) //显示广告高度
#define KMHeaderViewNoAdHeight 35          //去掉广告高度
@class MChooseView;
@protocol MHeaderViewDelegate;
@interface MHeaderView : UICollectionReusableView
@property (nonatomic,weak)id<MHeaderViewDelegate>m_delegate;
//是否显示广告 YES 显示广告 NO不显示广告 默认YES
@property (nonatomic,assign)BOOL adShow;
//电影分组标题
@property (nonatomic,strong)UILabel *tipTitle;
//副标题(正在播放第2集）
@property (strong, nonatomic) UILabel *subTitleLabel;
//广告数据
@property (nonatomic,strong)NSArray *bannerArrays;

@property (strong, nonatomic) UILabel *L;
@end


@protocol MHeaderViewDelegate <NSObject>

@optional
- (void)mheaderViewadSelectEventIndex:(NSInteger)index;

@end
