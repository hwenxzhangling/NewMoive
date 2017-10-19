//
//  MovieCollectionViewCell.h
//  MoivePlace
//
//  Created by TNP on 17/2/10.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MovieModel;
@interface MovieCollectionViewCell : UICollectionViewCell

/**电影数据模型*/
@property(nonatomic,strong)MovieModel *m_model;
/**封面图片*/
@property(nonatomic,strong)UIImageView *m_placeImg;
/**电影标题*/
@property(nonatomic,strong)UILabel *m_title;
/**时间日期*/
@property(nonatomic,strong)UILabel *m_data;
/**电影类型*/
@property(nonatomic,strong)UILabel *m_tpyes;
@end
