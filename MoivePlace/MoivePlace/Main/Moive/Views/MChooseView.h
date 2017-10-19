//
//  MChooseView.h
//  MoivePlace
//
//  Created by yanglin on 2017/2/14.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieModel.h"

typedef void(^ChooseBlock)(NSInteger index);

//---------Cell------------------------------------
@interface MChooseCell : UICollectionViewCell
- (void)configCellWithTitle:(NSString *)title selected:(BOOL)selected;

@end

//---------选择集数视图------------------------------------
@interface MChooseView : UIView
@property (copy, nonatomic) ChooseBlock chooseBlock;
@property (assign, nonatomic) NSInteger selectedIndex;
- (CGFloat)configChooseViewWithMovieDetail:(MovieDetail *)movieDetail;   //计算视图高度

@end
