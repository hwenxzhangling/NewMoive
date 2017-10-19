//
//  WebViewController.h
//  MoivePlace
//
//  Created by hewenxue on 17/2/13.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieModel.h"

@interface WebViewController : UIViewController
//广告模型
@property (nonatomic,strong)BannerModel *banber;
@property (nonatomic,strong)NSString    *playUrl;
@end
