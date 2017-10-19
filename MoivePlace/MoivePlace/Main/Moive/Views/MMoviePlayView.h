//
//  MMoviePlayView.h
//  MoivePlace
//
//  Created by hewenxue on 17/2/14.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KMMoviePlayViewHeight 230
#import "MovieModel.h"

@protocol  MMoviePlayViewDelegate <NSObject>

@optional
- (void)MMoviePlayViewButtonPlay;

@end

@interface MMoviePlayView : UIView
@property (nonatomic, strong) UIView        *backView;//主背景View
@property (nonatomic,strong)MovieDetail     *detailModel;
@property (nonatomic,strong)UIImageView     *moviePicImv;//封面
@property (nonatomic, strong) UIButton      *pauseOrPlayBtn;//播放暂停按钮
@property (strong, nonatomic) UILabel       *titleLabel;//title
@property (weak, nonatomic) id<MMoviePlayViewDelegate> delegate;//
+ (MMoviePlayView *)playView;
@end
