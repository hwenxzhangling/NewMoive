//
//  MFind_T_CollectionViewCell.h
//  MoivePlace
//
//  Created by hewenxue on 17/2/15.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "MFAppModel.h"

#define KMFind_T_CollectionViewCellHeight 100
/*显示类型为1    图片上面，文字下面*/
@interface MFind_T_CollectionViewCell : UICollectionViewCell
@property (nonatomic,strong)UIImageView *picImv; //图片
@property (nonatomic,strong)UILabel     *titleLable;//标题
@property (nonatomic,strong)MFAppModel  *model;

@end
