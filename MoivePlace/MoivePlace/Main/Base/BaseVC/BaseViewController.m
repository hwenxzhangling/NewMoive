//
//  BaseViewController.m
//  MoivePlace
//
//  Created by TNP on 17/2/10.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import "BaseViewController.h"
#import "TNPTool.h"
#import "MMovieSearchViewController.h"
#import "MMovieDetailViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "MTVPlayViewController.h"

@interface BaseViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,TLSearchBarDelegate>

@end

@implementation BaseViewController
-(NSMutableArray *)m_dataArray
{
    if (!_m_dataArray) {
        _m_dataArray = [NSMutableArray array];
    }
    return _m_dataArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;

    [self createCollectionView];
}

-(void)createCollectionView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _m_layout = [[UICollectionViewFlowLayout alloc]init];
    _m_layout.sectionInset = UIEdgeInsetsMake(0, 5, 5, 5);
    _m_layout.itemSize = CGSizeMake((TScreenWidth-20)/3, (TScreenHeight)/3);
    _m_layout.minimumInteritemSpacing = 0;
    _m_layout.headerReferenceSize = CGSizeMake(TScreenWidth, KMHeaderViewHeight);
    
    
    _m_CollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, TNavBarHeight, TScreenWidth, TScreenHeight-TTabBarHeight-TNavBarHeight) collectionViewLayout:_m_layout];
    _m_CollectionView.backgroundColor = [UIColor whiteColor];
    _m_CollectionView.delegate = self;
    _m_CollectionView.dataSource = self;
    _m_CollectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_m_CollectionView];
    [_m_CollectionView registerClass:[MovieCollectionViewCell class] forCellWithReuseIdentifier:@"movieCell"];
    [_m_CollectionView registerClass:[MHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    self.searchBar.delegate = self;
}

#pragma mark ======UICollectionViewDataSource====
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
   if(self.m_dataSource && [self.m_dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)])
   {
      return [self.m_dataSource numberOfSectionsInCollectionView:collectionView];
   }
   return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(self.m_dataSource && [self.m_dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)])
    {
        return [self.m_dataSource collectionView:collectionView numberOfItemsInSection:section];
    }
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"movieCell" forIndexPath:indexPath];
     if(self.m_cellDataSource && [self.m_cellDataSource respondsToSelector:@selector(moiveCell:indexPath:)])
     {
         [self.m_cellDataSource moiveCell:cell indexPath:indexPath];
     }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.m_delegate && [self.m_delegate respondsToSelector:@selector(collectionView:didSelectItemAtIndexPath:)])
    {
        [self.m_delegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    MHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    if(indexPath.section == 0)
    {
        if(self.isAdShow)
        {
            headerView.adShow = YES;
            _m_layout.headerReferenceSize = CGSizeMake(TScreenWidth, KMHeaderViewHeight);
        }else
        {
            headerView.adShow = NO;
            _m_layout.headerReferenceSize = CGSizeMake(TScreenWidth, KMHeaderViewNoAdHeight);
        }
        
    }else
    {
        headerView.adShow = NO;
        _m_layout.headerReferenceSize = CGSizeMake(TScreenWidth, KMHeaderViewNoAdHeight);
    }
    
    if(self.m_cellDataSource && [self.m_cellDataSource respondsToSelector:@selector(moiveHeaderView:indexPath:)])
    {
        [self.m_cellDataSource moiveHeaderView:headerView indexPath:indexPath];
    }
    return headerView;
}

#pragma mark-TLSearchBarDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSLog(@"self class:%@",[self class]);
    if(!kStringIsEmpty(textField.text))
    {
        if(![self isKindOfClass:[MMovieSearchViewController class]])
        {
            MMovieSearchViewController *movieSearchVC = [[MMovieSearchViewController alloc] init];
            movieSearchVC.movieSearchValue = textField.text;
            [self.navigationController pushViewController:movieSearchVC animated:YES];
        }else
        {
            if(self.m_searchDelegate && [self.m_searchDelegate respondsToSelector:@selector(movieSearchValue:)])
            {
                [self.m_searchDelegate movieSearchValue:textField.text];
            }
        }
    }else
    {
        NSLog(@"输入搜索内容为空");
    }
    return YES;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
