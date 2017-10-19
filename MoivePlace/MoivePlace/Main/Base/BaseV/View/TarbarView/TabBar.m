//
//  TabBar.m
//  Jest
//
//  Created by 段振伟 on 16/4/7.
//  Copyright © 2016年 段振伟. All rights reserved.
//

#import "TabBar.h"
#import "TabBarButton.h"
#define KIPhone5Width 320

@interface TabBar()


@property (nonatomic, weak) TabBarButton *selectedButton;
@property (nonatomic,strong)UIView *lineView;
@end
@implementation TabBar
- (NSMutableArray *)tabBarButtons
{
    if (_tabBarButtons == nil) {
        _tabBarButtons = [NSMutableArray array];
    }
    return _tabBarButtons;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _lineView = [[UIView alloc] init];
        [self addSubview:_lineView];
    }
    return self;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)addTabBarButtonWithItem:(UITabBarItem *)item
{
    // 1.创建按钮
    TabBarButton *button = [[TabBarButton alloc] init];
    [self addSubview:button];
    // 添加按钮到数组中
    [self.tabBarButtons addObject:button];
    
    // 2.设置数据
    button.item = item;
    
    // 3.监听按钮点击
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    // 4.默认选中第0个按钮
    
    if (self.tabBarButtons.count == 1) {
        [self buttonClick:button];
    }
}

/**
 *  监听按钮点击
 */
- (void)buttonClick:(TabBarButton *)button
{
    // 1.通知代理
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]) {
        [self.delegate tabBar:self didSelectedButtonFrom:self.selectedButton.tag to:button.tag];
    }
    // 2.设置按钮的状态
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整加号按钮的位置
    CGFloat h = self.frame.size.height;
    CGFloat w = self.frame.size.width;
   
    
    // 按钮的frame数据
    CGFloat buttonY = 0;
    CGFloat buttonH = h;
    CGFloat buttonW = w / (self.tabBarButtons.count);
    
     for (int index = 0; index<self.tabBarButtons.count; index++) {
        // 1.取出按钮
        TabBarButton *button = self.tabBarButtons[index];
        // 2.设置按钮的frame
        CGFloat buttonX = index * buttonW;
        
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        // 3.绑定tag
        button.tag = index;
    }
}

@end
