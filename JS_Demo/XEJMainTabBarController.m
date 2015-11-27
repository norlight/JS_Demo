//
//  XEJMainTabBarController.m
//  JS_Demo
//
//  Created by X on 15/11/10.
//  Copyright (c) 2015年 ej. All rights reserved.
//

#import "XEJMainTabBarController.h"
#import "XEJSuperPagerTabViewController.h"

@interface XEJMainTabBarController ()

@end

@implementation XEJMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setUpTabBarItemsAttributes]; 
    [self setUpViewControllers];
    [self customizeTabBarAppearance];
    
    
}

- (void)setUpTabBarItemsAttributes
{
    NSDictionary *dict1 = @{
                            CYLTabBarItemTitle : @"发现",
                            CYLTabBarItemImage : @"discover_normal.png",
                            CYLTabBarItemSelectedImage : @"discover_selected.png"
                            };
    NSDictionary *dict2 = @{
                            CYLTabBarItemTitle : @"关注",
                            CYLTabBarItemImage : @"guanzhu_normal.png",
                            CYLTabBarItemSelectedImage : @"guanzhu_selected.png"
                            };
    NSDictionary *dict3 = @{
                            CYLTabBarItemTitle : @"简友圈",
                            CYLTabBarItemImage : @"jianyouquan_normal.png",
                            CYLTabBarItemSelectedImage : @"jianyouquan_selected.png"
                            };
    NSDictionary *dict4 = @{
                            CYLTabBarItemTitle : @"更多",
                            CYLTabBarItemImage : @"more_normal.png",
                            CYLTabBarItemSelectedImage : @"more_selected.png"
                            };
    NSArray *tabBarItemsAttributes = @[
                                       dict1,
                                       dict2,
                                       dict3,
                                       dict4,
                                       ];
    self.tabBarItemsAttributes = tabBarItemsAttributes;
}


- (void)setUpViewControllers
{
    UIViewController *vc1 = [XEJSuperPagerTabViewController new];
    UIViewController *vc2 = [UIViewController new];
    UIViewController *vc3 = [UIViewController new];
    UIViewController *vc4 = [UIViewController new];
    NSArray *viewControllers = @[vc1,
                                 vc2,
                                 vc3,
                                 vc4
                                 ];
    self.viewControllers = viewControllers;
    
    //self.delegate = vc1;

}

- (void)customizeTabBarAppearance
{
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = XEJJSColor;
    
    //UIAppearrance协议可以定制程序全局的控件外观属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
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
