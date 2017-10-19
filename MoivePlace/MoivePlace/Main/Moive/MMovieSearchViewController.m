//
//  MMovieSearchViewController.m
//  MoivePlace
//
//  Created by hewenxue on 17/2/14.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import "MMovieSearchViewController.h"
#import "TNPTool.h"
#import "NetworkPublicHeader.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "UIView+Category.h"

@interface MMovieSearchViewController ()<MMoiveDataSource,UICollectionViewDelegate,UICollectionViewDataSource,MMovieSearchDelegate>
@property (strong, nonatomic) NSMutableArray *movies;
@property (assign, nonatomic) NSInteger moviePage;//数据请求页码

@end

@implementation MMovieSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.m_CollectionView.height += KTabBarHeight;
    self.leftBtnHidden = NO;
    
    self.movies = [NSMutableArray array];
    self.moviePage = 1;
    
    self.m_searchDelegate = self;
    self.view.backgroundColor = [UIColor greenColor];
    self.m_cellDataSource = self;
    
    __weak __typeof(self) ws = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws refreshData];
    }];
    header.stateLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.m_CollectionView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [ws loadMoreMovieData];
    }];
    footer.stateLabel.hidden = YES;
    footer.refreshingTitleHidden = YES;
    self.m_CollectionView.mj_footer = footer;
    
    [self.m_CollectionView.mj_header beginRefreshing];
}

#pragma mark - 下拉刷新
- (void)refreshData{
    self.moviePage = 1;
    [self.movies removeAllObjects];
    [self loadMovies];
}

#pragma mark - 上拉加载
- (void)loadMoreMovieData
{
    self.moviePage ++;
    [self performSelector:@selector(loadMovies) withObject:nil afterDelay:0.01];
}

#pragma mark - 请求数据
- (void)loadMovies
{
    __weak __typeof(self) ws = self;
    [MNetworkManager getIndexWithID:nil
                          recommend:nil
                            keyword:_movieSearchValue
                               page:[NSString stringWithFormat:@"%@",@(self.moviePage)] limit:nil
                            success:^(NSArray<MovieModel *> *movies)
     {
         [ws.movies addObjectsFromArray:movies];
         [ws.m_CollectionView reloadData];
         [ws.m_CollectionView.mj_header endRefreshing];
         [ws.m_CollectionView.mj_footer endRefreshing];
     } failure:^(NSError *error)
     {
         if(self.moviePage>1)
         {
             self.moviePage --;
         }
         [ws.m_CollectionView.mj_header endRefreshing];
         [ws.m_CollectionView.mj_footer endRefreshing];
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.movies.count;
}

#pragma mark -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MovieModel *movieModel = self.movies[indexPath.row];
    MMovieDetailViewController *detailVC = [[MMovieDetailViewController alloc] init];
    detailVC.model = movieModel;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark- MMoiveDataSource
- (void)moiveCell:(MovieCollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    MovieModel *movie = _movies[indexPath.item];
    cell.m_model = movie;
}

- (void)moiveHeaderView:(MHeaderView *)headerView indexPath:(NSIndexPath *)indexPath
{
    headerView.L.hidden = YES;
    headerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    headerView.tipTitle.text = @"搜索结果";
    headerView.tipTitle.font = KFONT(15);
}

#pragma mark - MMovieSearchDelegate
- (void)movieSearchValue:(NSString *)value{
    _movieSearchValue = value;
    [self.m_CollectionView.mj_header beginRefreshing];
}


@end
