//
//  MFindSearchView.h
//  MoivePlace
//
//  Created by hewenxue on 17/2/15.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFindHeadView.h"

#define KFineSearchViewHeight 85

@interface MFindSearchView : UIView

+(MFindSearchView *)findSearchView;
@property (nonatomic,weak)id<MFindHeadViewDelegate>m_delegate;
@end
