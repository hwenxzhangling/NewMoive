//
//  MUserCenterViewController.m
//  MoivePlace
//
//  Created by TNP on 17/2/10.
//  Copyright © 2017年 cxmx. All rights reserved.
//==========电视剧==========

#import "MUserCenterViewController.h"
#import "TNPTool.h"
@interface MUserCenterViewController ()

@end

@implementation MUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 5, 5);
    layout.itemSize = CGSizeMake((TScreenWidth-20)/3, (TScreenHeight)/3);
    layout.minimumInteritemSpacing = 0;
    [self.m_CollectionView setCollectionViewLayout:layout];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
