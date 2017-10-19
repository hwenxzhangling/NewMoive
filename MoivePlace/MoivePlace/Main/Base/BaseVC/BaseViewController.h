//
//  BaseViewController.h
//  MoivePlace
//
//  Created by TNP on 17/2/10.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLBaseSearchController.h"
#import "MovieCollectionViewCell.h"
#import "MHeaderView.h"
#import "MacrosPublicHeader.h"

@protocol MMoiveDataSource <NSObject>
@optional
/*设置cell 值*/
- (void)moiveCell:(MovieCollectionViewCell *)cell
        indexPath:(NSIndexPath *)indexPath;
/*设置title 值*/
- (void)moiveHeaderView:(MHeaderView *)headerView
              indexPath:(NSIndexPath *)indexPath;
@end

@protocol MMovieSearchDelegate <NSObject>

@optional
- (void)movieSearchValue:(NSString *)value;
@end

@interface BaseViewController : TLBaseSearchController
@property (nonatomic,strong) UICollectionViewFlowLayout *m_layout;
@property(nonatomic,strong)UICollectionView *m_CollectionView;
/**数据*/
@property(nonatomic,strong)NSMutableArray *m_dataArray;
/*继承 
 numberOfSectionsInCollectionView
 numberOfItemsInSection 函数*/
@property (nonatomic,weak)id<UICollectionViewDataSource> m_dataSource;
/* 继承
 didSelectItemAtIndexPath 函数
 */
@property (nonatomic,weak)id<UICollectionViewDelegate> m_delegate;
@property (nonatomic,weak)id<MMoiveDataSource> m_cellDataSource;
@property (nonatomic,weak)id<MMovieSearchDelegate> m_searchDelegate;
@property (nonatomic,assign)BOOL isAdShow; //是否显示广告 默认NO不显示

@end
