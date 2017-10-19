//
//  MainTarbarViewController.h
//  MoivePlace
//
//  Created by TNP on 17/2/10.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabBar;
@interface MainTarbarViewController : UITabBarController
/**
 *  自定义的tabbar
 */
@property (nonatomic, weak) TabBar *customTabBar;
@end
