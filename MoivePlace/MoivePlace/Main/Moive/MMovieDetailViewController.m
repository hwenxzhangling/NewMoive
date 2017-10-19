//
//  MMovieDetailViewController.m
//  MoivePlace
//
//  Created by hewenxue on 17/2/14.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import "MMovieDetailViewController.h"
#import "NetworkPublicHeader.h"
#import "MMoviePlayView.h"
#import "WebViewController.h"
#import "MacrosPublicHeader.h"
#import "UIView+Category.h"
#import "MChooseView.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "TNPTool.h"
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MdetailHeadView.h"

@interface MMovieDetailViewController ()<MMoviePlayViewDelegate,UIWebViewDelegate,MMoiveDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger _choosePlayIndex;//选中的集数
}
@property (nonatomic, strong) MMoviePlayView    *playView;  //背景
@property (nonatomic, strong) UIWebView         *playWebView;//web播放器
@property (strong, nonatomic) MChooseView       *chooseView;//选择集数视图
@property (nonatomic, strong) NSArray           *movieDetailArray;

@property (nonatomic, strong)NSMutableArray     *recommendArray;//推荐数据
@property (assign, nonatomic) NSInteger         moviePage;//数据请求页码
@end

@implementation MMovieDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak __typeof(self) ws = self;
    _choosePlayIndex = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNotification];
    
    _playView = [MMoviePlayView playView];
    _playView.delegate = self;
    [self.view addSubview:_playView];
    
    [self performSelector:@selector(loadDataMovieDetail) withObject:nil afterDelay:0.01];
    
    _playWebView = [[UIWebView alloc] init];
    _playWebView.hidden = YES;
    _playWebView.delegate = self;
    [self.view addSubview:_playWebView];
    
//    _chooseView = [[MChooseView alloc] init];
//    _chooseView.chooseBlock = ^(NSInteger index) {
//        NSLog(@"选择了 = %@", @(index));
//        _choosePlayIndex = index;
//        [ws MMoviePlayViewButtonPlay];
//    };
//    [self.view addSubview:_chooseView];
    
    self.recommendArray = [NSMutableArray array];
    
    
    self.m_CollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [ws loadMoreMovieData];
    }];
    [self.m_CollectionView registerClass:[MdetailHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerD"];
    self.m_cellDataSource = self;
    self.moviePage = 1;
    [self setupConstraints];
}

- (void)setupConstraints{
    __weak __typeof(self) ws = self;
    
    [_playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(ws.view);
        make.height.mas_equalTo(KMMoviePlayViewHeight);
    }];
    
    [_playWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(ws.view);
        make.height.mas_equalTo(KMMoviePlayViewHeight - 40);
    }];
    
    self.m_CollectionView.frame = CGRectMake(0, KMMoviePlayViewHeight, TScreenWidth, TScreenHeight-KMMoviePlayViewHeight-44);
}

#pragma mark - 请求数据
- (void)loadMovies
{
    if(self.movieDetailArray.count)
    {
        //配置播放器地址
        MovieDetail *detailModel = [self.movieDetailArray firstObject];
        __weak __typeof(self) ws = self;
        [MNetworkManager getIndexWithID:detailModel.d_type
                              recommend:@"1"
                                keyword:nil
                                   page:[NSString stringWithFormat:@"%ld",(long)_moviePage] limit:nil
                                success:^(NSArray<MovieModel *> *movies)
         {
             [ws.recommendArray addObjectsFromArray:movies];
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
}

#pragma mark - 上拉加载
- (void)loadMoreMovieData
{
    self.moviePage ++;
    [self performSelector:@selector(loadMovies) withObject:nil afterDelay:0.01];
}

- (void)loadDataMovieDetail
{
    __weak typeof(self) ws = self;
    [MNetworkManager getDetailWithID:self.model.d_id Success:^(NSArray<MovieDetail *> *details)
    {
        ws.movieDetailArray = details;
        
        if(ws.movieDetailArray.count)
        {
            //配置播放器地址
            MovieDetail *detailModel = [ws.movieDetailArray firstObject];
            ws.playView.detailModel = detailModel;
            [ws MMoviePlayViewButtonPlay];
            
            //配置选择集数视图
            CGFloat chooseViewH = [ws.chooseView configChooseViewWithMovieDetail:detailModel];
            
            self.m_layout.headerReferenceSize = CGSizeMake(TScreenWidth, chooseViewH+40);
            [ws.m_CollectionView reloadData];
            [ws.view updateConstraintsIfNeeded];
            [UIView animateWithDuration:0.3 animations:^{
                [self.view layoutIfNeeded];
            }];
           [self performSelector:@selector(loadMovies) withObject:nil afterDelay:0.01];
        }
        
    } failure:^(NSError *error)
    {
        NSLog(@"loadDataMovieDetail error:%@", [error description]);
    }];
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.recommendArray.count;
}

#pragma mark -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.model = self.recommendArray[indexPath.row];
    [self.recommendArray removeAllObjects];
    [self.m_CollectionView reloadData];
    [self loadDataMovieDetail];
}

#pragma mark- MMoiveDataSource
- (void)moiveCell:(MovieCollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    MovieModel *movie = self.recommendArray[indexPath.item];
    cell.m_model = movie;
}

#pragma mark-UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    __weak __typeof(self) ws = self;
    MdetailHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerD" forIndexPath:indexPath];
    headerView.detailModel = [self.movieDetailArray firstObject];
    self.chooseView = headerView.chooseV;
    //NSLog(@"===========%@",self.chooseView);
    self.chooseView.chooseBlock = ^(NSInteger index){
        static NSInteger recordCout;
        _choosePlayIndex = index;
        
        if (recordCout == index)
        return;
        
        [ws MMoviePlayViewButtonPlay];
        recordCout = index;
    };
    return headerView;
}


#pragma mark- MMoviePlayViewDelegate
-(void)MMoviePlayViewButtonPlay
{
    NSString *url = @"";//电影播放地址
    if(_playView.detailModel.d_playurl.count)
    {
        PlaySource *playSource = [_playView.detailModel.d_playurl objectAtIndex:_choosePlayIndex];
        if([playSource isKindOfClass:[PlaySource class]])
        {
            url = playSource.src;
        }
    }
    [self play:url];
}

- (void)play:(NSString *)_playUrl
{
    NSURL *url;

    url = [NSURL URLWithString:_playUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_playWebView loadRequest:request];
     _playWebView.hidden = NO;
}

#pragma mark- notication
- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(begainFullScreen) name:UIWindowDidBecomeVisibleNotification object:nil];//进入全屏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:UIWindowDidBecomeHiddenNotification object:nil];//退出全屏
}
// 进入全屏
-(void)begainFullScreen
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = YES;
}
// 退出全屏
-(void)endFullScreen
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = NO;
    //强制归正：
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        [UIApplication sharedApplication].statusBarHidden = NO;
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val =UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
#pragma mark-
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark -释放通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _playWebView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
