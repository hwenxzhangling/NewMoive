//
//  MMainPageViewController.m
//  MoivePlace
//
//  Created by TNP on 17/2/10.
//  Copyright © 2017年 cxmx. All rights reserved.
//==========推荐==========

#import "MMainPageViewController.h"
#import "WebViewController.h"
#import "Common.h"
#import "NetworkPublicHeader.h"
#import "MMovieDetailViewController.h"

@interface MMainPageViewController ()<MMoiveDataSource,UICollectionViewDelegate,UICollectionViewDataSource,MHeaderViewDelegate>
@property (nonatomic,strong)NSArray *movieGroupArray;
@property (nonatomic,strong)NSArray *bannerArray;
@end

@implementation MMainPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.m_cellDataSource = self;
    self.isAdShow = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self performSelector:@selector(loadRecommendAdData) withObject:nil afterDelay:0.01];
    [self performSelector:@selector(loadRecommendData) withObject:nil afterDelay:0.03];
}

- (void)loadRecommendAdData
{
    __weak typeof(self) weakSelf = self;
    [MNetworkManager getBannersSuccess:^(NSArray<BannerModel *> *banners)
    {
        weakSelf.bannerArray = banners;
        if(!weakSelf.bannerArray.count)
        {
            weakSelf.isAdShow = NO;
        }else
        {
            weakSelf.isAdShow = YES;
        }
        [weakSelf.m_CollectionView reloadData];
    } failure:^(NSError *error)
    {
        NSLog(@"error:%@",[error description]);
    }];
}

- (void)loadRecommendData
{
    __weak typeof(self) weakSelf = self;
    [MNetworkManager getRecommendSuccess:^(NSArray<MovieGroup *> *groups)
    {
        weakSelf.movieGroupArray = groups;
        [weakSelf.m_CollectionView reloadData];
        NSLog(@"goursp");
    } failure:^(NSError *error)
     {
        NSLog(@"sdf");
    }];
}

#pragma mark-UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.movieGroupArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    MovieGroup *group = self.movieGroupArray[section];
    return group.datas.count;
}

#pragma mark -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MovieGroup *group = self.movieGroupArray[indexPath.section];
    MovieModel *movieModel = group.datas[indexPath.row];
    MMovieDetailViewController *detailVC = [[MMovieDetailViewController alloc] init];
    detailVC.model = movieModel;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark- MMoiveDataSource
- (void)moiveCell:(MovieCollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    MovieGroup *group = self.movieGroupArray[indexPath.section];
    MovieModel *movieModel = group.datas[indexPath.row];
    cell.m_model = movieModel;
}

- (void)moiveHeaderView:(MHeaderView *)headerView indexPath:(NSIndexPath *)indexPath
{
    headerView.m_delegate = self;
    MovieGroup *group = self.movieGroupArray[indexPath.section];
    headerView.bannerArrays = self.bannerArray;
    headerView.tipTitle.text = group.title;
}

#pragma mark- MHeaderViewDelegate
- (void)mheaderViewadSelectEventIndex:(NSInteger)index
{
    BannerModel *model = self.bannerArray[index];
    if([model isKindOfClass:[BannerModel class]])
    {
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.banber = model;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
