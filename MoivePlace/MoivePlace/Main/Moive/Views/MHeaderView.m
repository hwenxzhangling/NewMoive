//
//  MHeaderView.m
//  MoivePlace
//
//  Created by TNP on 17/2/10.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import "MHeaderView.h"
#import "TNPTool.h"
#import "BHInfiniteScrollView.h"
#import "UIColor+Extension.h"
#import "MacrosPublicHeader.h"
#import "UIView+Category.h"
#import "MChooseView.h"
#define KAdScrollViewTag  100
#define KTipTitleFont     15
@interface MHeaderView()<BHInfiniteScrollViewDelegate>
@end
@implementation MHeaderView
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.adShow = YES;
        [self createADVView:nil];
        

        _L = [[UILabel alloc] init];
        _L.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.6];
        [self addSubview:_L];
        
        self.tipTitle = [[UILabel alloc] init];
        self.tipTitle.font = TFont(KTipTitleFont);
        self.tipTitle.text = @"大家都在看";
        self.tipTitle.textAlignment = NSTextAlignmentLeft;
        self.tipTitle.textColor = [UIColor blackColor];
        [self addSubview:self.tipTitle];
        
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = KFONT(12);
        _subTitleLabel.textAlignment = NSTextAlignmentRight;
        _subTitleLabel.textColor = [UIColor grayColor];
        [self addSubview:_subTitleLabel];
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    
    _L.frame = CGRectMake(10, self.bounds.size.height-30, 2.5, 25);
    self.tipTitle.frame = CGRectMake(20, self.bounds.size.height - KTipTitleFont - 10, TScreenWidth-100, KTipTitleFont);
    _subTitleLabel.frame = CGRectMake(100, self.bounds.size.height - KTipTitleFont - 8, TScreenWidth - 100 - 10 , 12);
}

- (void)setAdShow:(BOOL)adShow
{
    _adShow = adShow;
    BHInfiniteScrollView *infinitePageView2 = [self viewWithTag:KAdScrollViewTag];
    infinitePageView2.hidden = !_adShow;
    [self setNeedsLayout];
}

-(void)createADVView:(NSArray *)array
{
    CGFloat viewHeight = KMHeaderViewHeight - 40;
    NSMutableArray *urlsArray = [NSMutableArray array];
    NSMutableArray *titlesArray = [NSMutableArray array];
    
    for (int  i= 0; i<array.count; i++)
    {
        BannerModel *model = array[i];
        if([model isKindOfClass:[BannerModel class]])
        {
            if(!kStringIsEmpty(model.ad_img))
            {
                [urlsArray addObject:model.ad_img];
            }
            if(!kStringIsEmpty(model.ad_title))
            {
                [titlesArray addObject:model.ad_title];
            }
        }
    }
    
    BHInfiniteScrollView* infinitePageView2 = [BHInfiniteScrollView
                                               infiniteScrollViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), viewHeight) Delegate:self ImagesArray:urlsArray];
    infinitePageView2.titlesArray = titlesArray;
    infinitePageView2.dotSize = 10;
    infinitePageView2.titleView.textColor = [UIColor redColor];
    infinitePageView2.pageControlAlignmentOffset = CGSizeMake(30,10);
    infinitePageView2.scrollTimeInterval = 5;
    infinitePageView2.dotColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    infinitePageView2.selectedDotColor = [UIColor colorWithHexString:KBaseOrangeColorHexString];
    infinitePageView2.autoScrollToNextPage = YES;
    infinitePageView2.scrollDirection = BHInfiniteScrollViewScrollDirectionHorizontal;
    infinitePageView2.pageControlAlignmentH = BHInfiniteScrollViewPageControlAlignHorizontalLeft;
    infinitePageView2.pageControlAlignmentV = BHInfiniteScrollViewPageControlAlignVerticalButtom;
    infinitePageView2.reverseDirection = NO;
    infinitePageView2.tag = KAdScrollViewTag;
    [self addSubview:infinitePageView2];
    
}

- (void)setBannerArrays:(NSArray *)bannerArrays
{
    if(_bannerArrays == bannerArrays)return;
    _bannerArrays = bannerArrays;
    
    if(!_bannerArrays.count) return;
    
    BHInfiniteScrollView *infinitePageView2 = [self viewWithTag:KAdScrollViewTag];
    [infinitePageView2 removeFromSuperview];
    [self createADVView:_bannerArrays];
    [self setNeedsLayout];
}
#pragma mark BHInfiniteScrollViewDelegate
- (void)infiniteScrollView:(BHInfiniteScrollView *)infiniteScrollView didScrollToIndex:(NSInteger)index
{
    //NSLog(@"did scroll to index %ld", index);
}

- (void)infiniteScrollView:(BHInfiniteScrollView *)infiniteScrollView didSelectItemAtIndex:(NSInteger)index
{
    if(self.m_delegate && [self.m_delegate respondsToSelector:@selector(mheaderViewadSelectEventIndex:)])
    {
        [self.m_delegate mheaderViewadSelectEventIndex:index];
    }
    
}

@end
