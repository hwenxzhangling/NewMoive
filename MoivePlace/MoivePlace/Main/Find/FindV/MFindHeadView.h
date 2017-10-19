//
//  MFindHeadView.h
//  MoivePlace
//
//  Created by hewenxue on 17/2/15.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFAppModel.h"
#import "Common.h"
#define KMFindHeaderViewHeight     130 //显示搜索高度
#define KMFindHeaderViewNoAdHeight 40  //去掉搜索高度

@protocol MFindHeadViewDelegate;
@interface MFindHeadView : UICollectionReusableView
@property (nonatomic,weak)id<MFindHeadViewDelegate>m_delegate;
@property (nonatomic,strong) UILabel         *moreLable;//点击查看更多按钮
//是否显示搜索栏 YES 显示 NO不显示 默认YES
@property (nonatomic,assign)BOOL searchShow;
//发现分组标题
@property (nonatomic,strong)UILabel *tipTitle;
@property (nonatomic,strong)MFAppGroupModel *model;

@end

@protocol MFindHeadViewDelegate <NSObject>
@optional

- (void)MFindHeadViewMoreClick:(MFAppGroupModel *)model;
- (void)MFindHeadViewSearchValue:(NSString *)value;
@end
