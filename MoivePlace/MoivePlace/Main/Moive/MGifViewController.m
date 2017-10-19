//
//  MGifViewController.m
//  MoivePlace
//
//  Created by TNP on 17/2/10.
//  Copyright © 2017年 cxmx. All rights reserved.
//==========电影==========

#import "MGifViewController.h"
#import "TNPTool.h"
#import "NetworkPublicHeader.h"


@interface MGifViewController ()<MMoiveDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@end

@implementation MGifViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 5, 5);
    layout.itemSize = CGSizeMake((TScreenWidth-20)/3, (TScreenHeight)/3);
    layout.minimumInteritemSpacing = 0;
    [self.m_CollectionView setCollectionViewLayout:layout];
    
    [self performSelector:@selector(loadDataMovie) withObject:nil afterDelay:0.02];
}

- (void)loadDataMovie
{
    __weak typeof(self) weakSelf = self;
    [MNetworkManager getRecommendSuccess:^(NSArray<MovieGroup *> *groups)
    {
    
         [self.m_CollectionView reloadData];
         NSLog(@"goursp");
     } failure:^(NSError *error)
     {
         NSLog(@"sdf");
     }];
}

#pragma mark-UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 30;
}

#pragma mark -UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark- MMoiveDataSource
- (void)moiveCell:(MovieCollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
