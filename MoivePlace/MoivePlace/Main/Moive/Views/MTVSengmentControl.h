//
//  MTVSengmentControl.h
//  MoivePlace
//
//  Created by hewenxue on 17/4/1.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieModel.h"

#define KMTVSengmentControlHeight 45

typedef void(^MTVSengmentControlBlock)(NSInteger index);
@interface MTVSengmentControl : UIView
//电视剧类别
@property (nonatomic,strong)NSArray *MTVCataryArray;
@property (nonatomic,copy)MTVSengmentControlBlock sengmentControlBlock;
- (void)setSelectIndex:(NSInteger)index;
@end
