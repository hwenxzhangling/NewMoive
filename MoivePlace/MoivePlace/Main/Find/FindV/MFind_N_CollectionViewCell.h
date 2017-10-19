//
//  MFind_N_CollectionViewCell.h
//  MoivePlace
//
//  Created by hewenxue on 17/2/15.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "MFAppModel.h"

#define KMFind_N_CollectionViewCellHeight 80
/*显示类型为0    图片左边，文字右边*/
@interface MFind_N_CollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)UIImageView *picImv; //图片
@property (nonatomic,strong)UILabel     *titleLable;//标题
@property (nonatomic,strong)MFAppModel  *model;
@end
