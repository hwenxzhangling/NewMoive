//
//  MFindViewViewController.m
//  MoivePlace
//
//  Created by hewenxue on 17/2/15.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import "MFindViewController.h"
#import "MFindSearchView.h"
#import "MNetworkManager.h"
#import "TLSearchWebController.h"

#import <Small/Small.h>

@interface MFindViewController ()<MMoiveDataSource,UICollectionViewDelegate,UICollectionViewDataSource,MFindHeadViewDelegate>
@property (nonatomic,strong)MFindSearchView *searchView;
@property (nonatomic,strong)NSArray *appGroupModels;

@end

@implementation MFindViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"福利中心";
    self.view.backgroundColor = [UIColor whiteColor];
    self.searchShow = NO;
    self.m_cellDataSource = self;
    self.findHeadViewDelegate = self;
    
    _searchView = [MFindSearchView findSearchView];
    _searchView.m_delegate = self;
    [self.view addSubview:_searchView];
    
    self.m_CollectionView.frame = CGRectMake(0, _searchView.bottom, kMainWidth, kMainHeight-_searchView.bottom);
    
    [self performSelector:@selector(loadApp) withObject:nil afterDelay:0.001];
}

#pragma mark-loadApp 
- (void)loadApp
{
    __weak typeof(self) weakSelf = self;
    [MNetworkManager getFindAppSuccess:^(NSArray<MFAppGroupModel *> *appModel)
     {
         weakSelf.appGroupModels = appModel;
         if(weakSelf.appGroupModels.count)
         {
             MFAppGroupModel *groupModel = [self.appGroupModels objectAtIndex:0];
              weakSelf.cellType = [groupModel.showtype integerValue];
             [weakSelf.m_CollectionView reloadData];
         }
     } failure:^(NSError *error)
    {
       
        NSLog(@"----error:%@",[error description]);
    }];
}

#pragma mark-UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.appGroupModels.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    MFAppGroupModel *groupModel = [self.appGroupModels objectAtIndex:section];
    NSArray *appModels = groupModel.list;
    if(appModels.count<=8)
    {
        return appModels.count;
    }else
    return 8; //最多显示8条数据  大于8条数据在查看更多里面显示，小于8条隐藏更多按钮
}

#pragma mark -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MFAppGroupModel *groupModel = [self.appGroupModels objectAtIndex:indexPath.section];
    NSArray *appModels = groupModel.list;
    MFAppModel *model = appModels[indexPath.row];;
    
    
    if([model.url_open_type integerValue] != TLInJump)
    {
        CYWebViewController *webViewController = [[CYWebViewController alloc] init];
        webViewController.url = [NSURL URLWithString:model.android_url];
        webViewController.controllerType = [model.url_open_type integerValue];
        webViewController.isShowNavBar = NO;
        webViewController.isShowToolBar = NO;
        webViewController.isShowNewDetails = NO;
        [webViewController setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
    else
    {
        UIViewController *vc = [Small controllerForUri:@"video"];
        NSLog(@"----------:%@",vc);
        NSLog(@"内部:%@",[Small allBundles]);
    }
}

#pragma mark- MMoiveDataSource
- (void)moiveCell:(MovieCollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    MFAppGroupModel *groupModel = [self.appGroupModels objectAtIndex:indexPath.section];
    NSArray *appModels = groupModel.list;
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
        MFAppGroupModel *groupModel = [self.appGroupModels objectAtIndex:indexPath.section];
        fheaderView.model = groupModel;
        NSArray *appModels = groupModel.list;
        if(appModels.count<=8)
        {
            //fheaderView.moreLable.hidden = YES;
        }else
        {
            fheaderView.moreLable.hidden = NO;
        }
        fheaderView.tipTitle.text = groupModel.title;
    }
}

#pragma mark-MFindHeadViewDelegate
- (void)MFindHeadViewMoreClick:(MFAppGroupModel *)model
{
    MFindMoreViewController *moreVC = [[MFindMoreViewController alloc] init];
    moreVC.cellType = [model.showtype integerValue];
    moreVC.groupModel = model;
    [self.navigationController pushViewController:moreVC animated:YES];
}

- (void)MFindHeadViewSearchValue:(NSString *)value
{
    NSLog(@"___搜索关键字:%@",value);
    if(!kStringIsEmpty(value))
    {
        TLSearchWebController *webVC = [[TLSearchWebController alloc] init];
        webVC.keyWords = value;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
