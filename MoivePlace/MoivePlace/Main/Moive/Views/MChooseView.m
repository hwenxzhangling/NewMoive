//
//  MChooseView.m
//  MoivePlace
//
//  Created by yanglin on 2017/2/14.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import "MChooseView.h"
#import "UIView+Category.h"
#import "Common.h"
#import "MHeaderView.h"
#import "Masonry.h"

//---------Cell------------------------------------
@interface MChooseCell ()
@property (strong, nonatomic) UIButton *btn;

@end


@implementation MChooseCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = self.bounds;
    _btn.userInteractionEnabled = NO;
    _btn.titleLabel.font = KFONT(14);
    [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [self.contentView addSubview:_btn];
}

- (void)configCellWithTitle:(NSString *)title selected:(BOOL)selected{
    [_btn setTitle:title forState:UIControlStateNormal];
    _btn.selected = selected;
}

@end


//---------选择集数视图------------------------------------
@interface MChooseView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) MHeaderView *headerView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) MovieDetail *movieDetail;

@end


@implementation MChooseView

static NSString *_ID = @"MChooseCell";

const NSInteger _col = 5;
const CGFloat _itemH = 30;
const CGFloat _margin = 2;
const CGFloat _maxH = 1000;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self chooseIndex:0];
    }
    return self;
}

-(void)setupViews{
    self.backgroundColor = [UIColor clearColor];
    
    _headerView = [[MHeaderView alloc] init];
    _headerView.clipsToBounds = YES;
    _headerView.tipTitle.text = @"选集";
    [self addSubview:_headerView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[MChooseCell class] forCellWithReuseIdentifier:_ID];
    [self addSubview:_collectionView];
    
    [self setupContraints];
}

- (void)setupContraints{
    __weak __typeof(self) ws = self;
    
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(ws);
        make.height.mas_equalTo(0);
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(ws);
        make.top.equalTo(_headerView.mas_bottom);
    }];

}

- (CGFloat)configChooseViewWithMovieDetail:(MovieDetail *)movieDetail{
    _movieDetail = movieDetail;
    
    [_collectionView reloadData];
    
    CGFloat headerViewH = 0;
    switch (movieDetail.movieType) {
        case MMovieType_Unknown:{
            return 0;
        }
            break;
        case MMovieType_Movie:{
            return 0;
        }
            break;
        case MMovieType_MTV:{
            headerViewH = KMHeaderViewNoAdHeight;
        }
            break;
        case MMovieType_Variety:{
            headerViewH = KMHeaderViewNoAdHeight;
        }
            break;
        case MMovieType_CTV:{
            headerViewH = KMHeaderViewNoAdHeight;
        }
            break;
        case MMovieType_HTV:{
            headerViewH = KMHeaderViewNoAdHeight;
        }
            break;
        case MMovieType_JTV:{
            headerViewH = KMHeaderViewNoAdHeight;
        }
            break;
        case MMovieType_ETV:{
            headerViewH = KMHeaderViewNoAdHeight;
        }
            break;
        default:
            break;
    }
    [_headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(headerViewH);
    }];
    
    NSInteger row = (movieDetail.d_playurl.count + _col - 1)/_col;
    if (row) {
        //
        CGFloat h = _itemH * row + _margin * (row - 1) + headerViewH;
        h = h > _maxH ? _maxH : h;
        return h;
    }else{
        return 0;
    }
}

//点击了某集
- (void)chooseIndex:(NSInteger)index{
    _selectedIndex = index;
    if (self.chooseBlock) {
        self.chooseBlock(index);
    }
    PlaySource *playSource = _movieDetail.d_playurl[index];
    _headerView.subTitleLabel.text = [NSString stringWithFormat:@"正在播放第%@集",playSource.title==nil?@"01":playSource.title];
    [_collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _movieDetail.d_playurl.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MChooseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[MChooseCell alloc] init];
    }
    PlaySource *playSource = _movieDetail.d_playurl[indexPath.item];
    [cell configCellWithTitle:playSource.title selected:indexPath.item == _selectedIndex];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((self.width - (_col - 1) * _margin)/_col, _itemH);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self chooseIndex:indexPath.item];
}



@end
