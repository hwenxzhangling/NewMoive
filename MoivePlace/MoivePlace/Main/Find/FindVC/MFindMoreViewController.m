//
//  MFindMoreViewController.m
//  MoivePlace
//
//  Created by hewenxue on 17/2/15.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import "MFindMoreViewController.h"
#import "UIView+Category.h"
#import "CYWebViewController.h"
@interface MFindMoreViewController ()<MMoiveDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@end

@implementation MFindMoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"更多";
    self.searchShow = NO;
    self.m_cellDataSource = self;
    
    self.m_CollectionView.height += KTabBarHeight;
    [self.m_CollectionView reloadData];
}

- (void)setGroupModel:(MFAppGroupModel *)groupModel
{
    if(_groupModel == groupModel)
        return;
    _groupModel = groupModel;
     [self.m_CollectionView reloadData];
}

#pragma mark-UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.groupModel.list.count;
}

#pragma mark -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *appModels = self.groupModel.list;
    MFAppModel *model = appModels[indexPath.row];;
    
    if([model.url_open_type integerValue] != TLInJump)
    {
        CYWebViewController *webViewController = [[CYWebViewController alloc] init];
        webViewController.url = [NSURL URLWithString:model.android_url];
        webViewController.controllerType = [model.url_open_type integerValue];
        webViewController.isShowNavBar = NO;
        webViewController.isShowToolBar = NO;
        webViewController.isShowNewDetails = NO;
        [self.navigationController pushViewController:webViewController animated:YES];
    }else
    {
        NSLog(@"内部跳转");
    }
}

#pragma mark- MMoiveDataSource
- (void)moiveCell:(MovieCollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    NSArray *appModels = self.groupModel.list;
    if(self.cellType == MFindCellType_LinT)
    {
        if([cell isKindOfClass:[MFind_N_CollectionViewCell class]])
        {
            MFind_N_CollectionViewCell *cell_N = (MFind_N_CollectionViewCell *)cell;
            cell_N.model = appModels[indexPath.row];
        }
    }else
    {
        if([cell isKindOfClass:[MFind_T_CollectionViewCell class]])
        {
            MFind_T_CollectionViewCell *cell_T = (MFind_T_CollectionViewCell *)cell;
            cell_T.model = appModels[indexPath.row];
        }
    }
}

- (void)moiveHeaderView:(MHeaderView *)headerView indexPath:(NSIndexPath *)indexPath
{
    if([headerView isKindOfClass:[MFindHeadView class]])
    {
        MFindHeadView *fheaderView = (MFindHeadView *)headerView;
        fheaderView.moreLable.hidden = YES;
        fheaderView.tipTitle.text = self.groupModel.title;
        //fheaderView.model = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
