//
//  MFindViewController.m
//  MoivePlace
//
//  Created by hewenxue on 17/2/13.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import "MFindBaseViewController.h"


@interface MFindBaseViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,MFindHeadViewDelegate>
@property (nonatomic,strong) UICollectionViewFlowLayout *m_layout;
@end

@implementation MFindBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"发现";
    [self createCollectionView];
}

- (void)updateLayoutitemSize
{
    if(self.cellType == MFindCellType_LinT)
    {
        _m_layout.itemSize = CGSizeMake(kMainWidth/2, KMFind_N_CollectionViewCellHeight);
    }else
    {
        _m_layout.itemSize = CGSizeMake(kMainWidth/4, KMFind_T_CollectionViewCellHeight);
    }
}

- (void)setCellType:(MFindCellType)cellType
{
   if(_cellType == cellType)
       return;
    _cellType = cellType;
    [self updateLayoutitemSize];
}

-(void)createCollectionView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _m_layout = [[UICollectionViewFlowLayout alloc]init];
    [self updateLayoutitemSize];
    _m_layout.minimumInteritemSpacing = 0;
    _m_layout.minimumLineSpacing = 0;
    _m_layout.sectionInset = UIEdgeInsetsZero;
    _m_layout.footerReferenceSize = CGSizeMake(kMainWidth, 20);
    _m_layout.headerReferenceSize = CGSizeMake(kMainWidth, KMFindHeaderViewHeight);
    
    
    _m_CollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kMainWidth, kMainHeight-KNavBarHeight-KTabBarHeight) collectionViewLayout:_m_layout];
    _m_CollectionView.backgroundColor = KColor(247, 247, 247);
    _m_CollectionView.delegate = self;
    _m_CollectionView.dataSource = self;
    _m_CollectionView.showsVerticalScrollIndicator = NO;
    
    
    [_m_CollectionView registerClass:[MFind_N_CollectionViewCell class] forCellWithReuseIdentifier:@"MFind_N_CollectionViewCell"];
    [_m_CollectionView registerClass:[MFind_T_CollectionViewCell class] forCellWithReuseIdentifier:@"MFind_T_CollectionViewCell"];
   
    [_m_CollectionView registerClass:[MFindHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    [self.view addSubview:_m_CollectionView];
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
    if(self.cellType == MFindCellType_LinT)
    {
        MFind_N_CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MFind_N_CollectionViewCell" forIndexPath:indexPath];
        if(self.m_cellDataSource && [self.m_cellDataSource respondsToSelector:@selector(moiveCell:indexPath:)])
        {
            [self.m_cellDataSource moiveCell:cell indexPath:indexPath];
        }
        return cell;
    }else
    {
        MFind_T_CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MFind_T_CollectionViewCell" forIndexPath:indexPath];
        if(self.m_cellDataSource && [self.m_cellDataSource respondsToSelector:@selector(moiveCell:indexPath:)])
        {
            [self.m_cellDataSource moiveCell:cell indexPath:indexPath];
        }
        return cell;
    }
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
    MFindHeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    headerView.m_delegate = self;
    if(indexPath.section == 0)
    {
        if(self.searchShow)
        {
            headerView.searchShow = YES;
            _m_layout.headerReferenceSize = CGSizeMake(kMainWidth, KMFindHeaderViewHeight);
        }else
        {
            headerView.searchShow = NO;
            _m_layout.headerReferenceSize = CGSizeMake(kMainWidth, KMFindHeaderViewNoAdHeight);
        }
    }else
    {
        headerView.searchShow = NO;
        _m_layout.headerReferenceSize = CGSizeMake(kMainWidth, KMFindHeaderViewNoAdHeight);
    }
    
    if(self.m_cellDataSource && [self.m_cellDataSource respondsToSelector:@selector(moiveHeaderView:indexPath:)])
    {
        [self.m_cellDataSource moiveHeaderView:headerView indexPath:indexPath];
    }
    return headerView;
}

#pragma mark-MFindHeadViewDelegate
- (void)MFindHeadViewMoreClick:(MFAppGroupModel *)model
{
    if(self.findHeadViewDelegate && [self.findHeadViewDelegate respondsToSelector:@selector(MFindHeadViewMoreClick:)])
    {
        [self.findHeadViewDelegate MFindHeadViewMoreClick:model];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
