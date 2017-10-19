//
//  MainTarbarViewController.m
//  MoivePlace
//
//  Created by TNP on 17/2/10.
//  Copyright © 2017年 cxmx. All rights reserved.
//

#import "MainTarbarViewController.h"
#import "AllHeader.h"
#import "YSNavigationController.h"
#import "MacrosPublicHeader.h"
#import "UIColor+Extension.h"
#import "MTVViewController.h"

@interface MainTarbarViewController ()<TabBarDelegate>

@end

@implementation MainTarbarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置状态栏白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    // 初始化tabbar
    [self setupTabbar];
    self.tabBar.translucent = NO;
    [self setupAllChildViewControllers];
}
/**
 *  初始化tabbar
 */
- (void)setupTabbar
{
    TabBar *customTabBar = [[TabBar alloc] init];
    
    customTabBar.frame = self.tabBar.bounds;
    customTabBar.delegate = self;
    [self.tabBar addSubview:customTabBar];
    self.customTabBar = customTabBar;
    //[self.tabBar setBackgroundImage:[[UIImage alloc] init]];
    //[self.tabBar setShadowImage:[[UIImage alloc] init]];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 删除系统自动生成的UITabBarButton
    for (UIView *child in self.tabBar.subviews)
    {
        if ([child isKindOfClass:[UIControl class]])
        {
            [child removeFromSuperview];
        }
    }
}
- (void)setupAllChildViewControllers
{
    
    /** 推荐 */
    MMainPageViewController *MainPageVC = [[MMainPageViewController alloc] init];
    [self setupChildViewController:MainPageVC title:@"推荐" imageName:@"tuijian_nobut" selectedImageName:@"tuijian_but"];
    /** 电影 */
    MMovieViewController *movieVC = [[MMovieViewController alloc] init];
    [self setupChildViewController:movieVC title:@"电影" imageName:@"dianying_nobut" selectedImageName:@"dianying_but"];
    
    /** 电视剧 */
    MTVViewController *TVVC = [[MTVViewController alloc] init];
    [self setupChildViewController:TVVC title:@"电视剧" imageName:@"dianshiju_nobut" selectedImageName:@"dianshiju_but"];

    
    /** 发现 */
    MFindViewController *FindVC = [[MFindViewController alloc] init];
    [self setupChildViewController:FindVC title:@"福利" imageName:@"faxian_nobut" selectedImageName:@"faxian_but"];
}

- (void)tabBar:(TabBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to
{
    self.selectedIndex = to;
}

- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 1.设置控制器的属性
    childVc.title = title;
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 2.包装一个导航控制器
    YSNavigationController *nav = [[YSNavigationController alloc] initWithRootViewController:childVc];
    nav.navigationBar.barTintColor = [UIColor colorWithHexString:KBaseOrangeColorHexString];
    nav.navigationBarHidden = YES;
    [self addChildViewController:nav];
    // 3.添加tabbar内部的按钮
    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
