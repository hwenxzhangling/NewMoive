//
//  TabBar.h
//  Jest
//
//  Created by 段振伟 on 16/4/7.
//  Copyright © 2016年 段振伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarButton.h"
@class TabBar;

@protocol TabBarDelegate <NSObject>

@optional

- (void)tabBar:(TabBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to;

- (void)tabBarDidClickedPlusButton:(TabBar *)tabBar;
@end

@interface TabBar : UIView
- (void)addTabBarButtonWithItem:(UITabBarItem *)item;
@property (nonatomic, weak) id<TabBarDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *tabBarButtons;
- (void)buttonClick:(TabBarButton *)button;
@end
