//
//  YSNavigationController.m
//  Health
//
//  Created by wpsd on 2017/1/16.
//  Copyright © 2017年 wpsd. All rights reserved.
//

#import "YSNavigationController.h"

static NSString * const KBaseHexColor = @"5DB959";//@"2db7ff";
@interface YSNavigationController ()

@end

@implementation YSNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationBar *appearance = [UINavigationBar appearance];
    [appearance setShadowImage:[UIImage new]];//隐藏阴影
    [appearance setTintColor:[UIColor whiteColor]];//字体颜色
    [appearance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]}];//标题文字属性
    [appearance setTranslucent:NO];
    // 更换导航栏下面的描边颜色
    UIImageView *navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationBar];
    navBarHairlineImageView.image = nil;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"download_btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewControllerAnimated:)];
        leftItem.imageInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        viewController.navigationItem.leftBarButtonItem = leftItem;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - 寻找导航栏下面的描边
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
