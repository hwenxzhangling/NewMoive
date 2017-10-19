//
//  MTVViewController.m
//  MoivePlace
//
//  Created by hewenxue on 17/4/1.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import "MTVViewController.h"
#import "MTVSengmentControl.h"
#import "UIView+Category.h"
#import "NetworkPublicHeader.h"
#import "MTVPlayViewController.h"


#define KMTVCATARYName @"CATARYNames"
/**
 *     返回沙盒路径的宏定义
 */
#define sandBoxPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]

@interface MTVViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView        *MTVScrollView;
@property (nonatomic,strong)MTVSengmentControl  *MTVSControl;
@property (nonatomic,strong)NSMutableArray      *MTVCatarys;
@end



@implementation MTVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.m_CollectionView.hidden = YES;
    //类别
    _MTVSControl = [[MTVSengmentControl alloc] initWithFrame:CGRectMake(0, KNavBarHeight, kMainHeight, 100)];
    _MTVSControl.hidden = YES;
    [self.view addSubview:_MTVSControl];
    
    __weak typeof(self) ws = self;
    _MTVSControl.sengmentControlBlock = ^(NSInteger index)
    {
        [ws.MTVScrollView setContentOffset:CGPointMake(kMainWidth * index, 0) animated:YES];
    };
    
    //翻页
    _MTVScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _MTVSControl.bottom, kMainWidth, kMainHeight-KNavBarHeight-KTabBarHeight)];
    _MTVScrollView.pagingEnabled = YES;
    _MTVScrollView.bounces = NO;
    _MTVScrollView.delegate = self;
    [self.view addSubview:_MTVScrollView];
    
    [self performSelector:@selector(getCatarys) withObject:nil afterDelay:0.01];
}

- (void)setMTVCatarys:(NSMutableArray *)MTVCatarys
{
    if(_MTVCatarys == MTVCatarys)
    {
        return;
    }
    _MTVSControl.hidden = NO;
    _MTVCatarys = MTVCatarys;
    [_MTVSControl setMTVCataryArray:_MTVCatarys];
    
    _MTVScrollView.contentSize = CGSizeMake(kMainWidth*_MTVCatarys.count, 0);
    CGFloat x = 0;
    for (int i = 0; i< _MTVCatarys.count; i++)
    {
       
        MovieCategory *mc = _MTVCatarys[i];
        
        MTVPlayViewController *mtvPlayVC = [[MTVPlayViewController alloc] init];
        mtvPlayVC.mtvCatary = mc.t_id;
        [self addChildViewController:mtvPlayVC];
        
        UIView *v = mtvPlayVC.view;
        v.frame = CGRectMake(x, 0, kMainWidth, self.MTVScrollView.height);
        [self.MTVScrollView addSubview:v];
        x += kMainWidth;
    }
}

- (void)getCatarys
{
    //获取本地数据
    [self loadArchiveList:KMTVCATARYName];
    __weak typeof(self) ws = self;
    [MNetworkManager getCategorySuccess:^(NSArray<MovieCategory *> *categorys)
    {
        for (MovieCategory *mc in categorys )
        {
            if([mc.t_id integerValue] == MMovieType_MTV)
            {
                if(ws.MTVCatarys.count == 0 ||
                   ws.MTVCatarys == nil)
                {
                     ws.MTVCatarys = [NSMutableArray arrayWithArray:mc.child];
                }
                //保存数据到本地
                [ws archiveCurrentList:KMTVCATARYName];
                break;
            }
        }
    } failure:^(NSError *error)
    {
        
        NSLog(@"--------getCategoryNSError:%@",error);
    }];
}

#pragma mark- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.MTVScrollView)
    {
        NSInteger currentPage = scrollView.contentOffset.x/kMainWidth;
        [_MTVSControl setSelectIndex:currentPage];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - archive
- (void)archiveListWithPath:(NSString *)path models:(NSArray *)models
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:models];
    [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
}

- (NSArray *)unArchiveListWithPath:(NSString *)path
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSFileManager defaultManager] contentsAtPath:path]];
}

- (void)archiveCurrentList:(NSString *)categry
{
    [self archiveListWithPath:[sandBoxPath stringByAppendingPathComponent:categry] models:self.MTVCatarys];
}

- (void)loadArchiveList:(NSString *)categry
{
    if (self.MTVCatarys.count == 0)
    {
        NSArray *models = [self unArchiveListWithPath:[sandBoxPath stringByAppendingPathComponent:categry]];
        self.MTVCatarys = [NSMutableArray arrayWithArray:models];
    }
}

@end
