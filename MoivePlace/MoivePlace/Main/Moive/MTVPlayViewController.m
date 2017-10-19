//
//  MGifViewController.m
//  MoivePlace
//
//  Created by TNP on 17/2/10.
//  Copyright © 2017年 cxmx. All rights reserved.
//==========电视剧==========

#import "MTVPlayViewController.h"
#import "TNPTool.h"
#import "NetworkPublicHeader.h"
#import "MJRefresh.h"
#import "MMovieDetailViewController.h"
#import "UIView+Category.h"

@interface MTVPlayViewController ()
<MMoiveDataSource,UICollectionViewDelegate,UICollectionViewDataSource,TLSearchBarDelegate>
@property (strong, nonatomic) NSMutableArray *movies;
@property (assign, nonatomic) NSInteger moviePage;//数据请求页码

@end

@implementation MTVPlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navBar removeFromSuperview];
  
    self.movies = [NSMutableArray array];
    self.moviePage = 1;
    
    self.view.backgroundColor = [UIColor greenColor];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 5, 5);
    layout.itemSize = CGSizeMake((TScreenWidth-20)/3, (TScreenHeight)/3);
    layout.minimumInteritemSpacing = 0;
    [self.m_CollectionView setCollectionViewLayout:layout];
    self.m_cellDataSource = self;
    self.searchBar.searchBarDelegate = self;
    self.m_CollectionView.top = 0;
    [self performSelector:@selector(loadMovies) withObject:nil afterDelay:0.01];
    
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

- (void)loadMovies
{
    __weak __typeof(self) ws = self;
    [MNetworkManager getIndexWithID:[NSString stringWithFormat:@"%@",self.mtvCatary]
                          recommend:@"1"
                            keyword:nil
                               page:[NSString stringWithFormat:@"%@",@(self.moviePage)] limit:nil
                            success:^(NSArray<MovieModel *> *movies)
     {
         [ws.movies addObjectsFromArray:movies];
         [ws.m_CollectionView reloadData];
         [ws.m_CollectionView.mj_header endRefreshing];
         [ws.m_CollectionView.mj_footer endRefreshing];     } failure:^(NSError *error)
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
    if(_movies)
    {
        MovieModel *movie = _movies[indexPath.item];
        cell.m_model = movie;
    }
}





@end
