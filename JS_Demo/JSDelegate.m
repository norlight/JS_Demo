//
//  AppDelegate.m
//  JS_Demo
//
//  Created by X on 15/11/3.
//  Copyright (c) 2015年 ej. All rights reserved.
//

#import "JSDelegate.h"
#import "XEJStartView.h"
#import "XEJIntroductionViewController.h"
#import "XEJLoginViewController.h"
#import "XEJMainTabBarController.h"
#import "XEJSuperPagerTabViewController.h"
#import "XEJChildPagerTabViewController.h"
#import "XEJArticleListController.h"
#import "XEJArticleWebViewController.h"

@interface JSDelegate ()

@end

@implementation JSDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    /*
    //在UserDefaults中存一键值对用来表来程序是否第一次运行，是则显示引导介绍页，否则直接进入程序主界面
    //为了演示用，这里暂时注释掉
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults objectForKey:@"isFirstLaunch"]) {
        //引导页控制器前还有一页淡入页面
        XEJStartView *startView = [[XEJStartView alloc] init];
        [startView startAnimationWithCompletionBlock:^(XEJStartView *startView) {
            self.window.rootViewController = [XEJIntroductionViewController new];
        }];
        //运行过一次了就在userDefaults创造一键值对，下次运行检测到值存在就可以跳过了
        [userDefaults setObject:[NSNumber numberWithBool:YES] forKey:@"isFirstLaunch"];
        //此时对UserDefaults的修改还仅存在内存中，所以最好立即同步保存至沙盒
        [userDefaults synchronize];
    } else {
        self.window.rootViewController = [XEJMainTabBarController new];
    }
    */
    
    
    XEJStartView *startView = [[XEJStartView alloc] init];
    [startView startAnimationWithCompletionBlock:^(XEJStartView *startView) {
        self.window.rootViewController = [XEJIntroductionViewController new];
    }];
     
    
    
    //self.window.rootViewController = [XEJIntroductionViewController new];
    //self.window.rootViewController = [XEJLoginViewController new];
    //self.window.rootViewController = [XEJMainTabBarController new];
    //self.window.rootViewController = [XEJSuperPagerTabViewController new];
    //self.window.rootViewController = [XEJChildPagerTabViewController new];
    //self.window.rootViewController = [XEJArticleListController new];
    //self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[XEJArticleWebViewController new]];
    
    

    

    return YES;
}






#pragma mark
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
