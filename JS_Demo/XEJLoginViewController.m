//
//  XEJLoginViewController.m
//  JS_Demo
//
//  Created by X on 15/11/6.
//  Copyright (c) 2015年 ej. All rights reserved.
//

#import "XEJLoginViewController.h"
#import "XEJLoginView.h"
#import "XEJMainTabBarController.h"
#import "PopoverView.h"
#import <SVProgressHUD.h>


@interface XEJLoginViewController ()<UITextFieldDelegate, XEJQuickLoginViewDelegate, UITabBarControllerDelegate, UIAlertViewDelegate, PopoverViewDelegate>

@property (nonatomic, strong) XEJLoginView *loginView;

@end

@implementation XEJLoginViewController


- (void)loadView
{
    XEJLoginView *loginView = [XEJLoginView new];
    self.loginView = loginView;
    self.view = loginView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.loginView.closeButton addTarget:self
                                   action:@selector(actionUndefinedd)
                         forControlEvents:UIControlEventTouchUpInside];
    
    [self.loginView.loginButton addTarget:self
                                   action:@selector(actionUndefinedd)
                         forControlEvents:UIControlEventTouchUpInside];
    
    [self.loginView.browseButton addTarget:self
                                    action:@selector(enterMainView)
                          forControlEvents:UIControlEventTouchUpInside];
    
    [self.loginView.registerButton addTarget:self
                                    action:@selector(actionUndefinedd)
                          forControlEvents:UIControlEventTouchUpInside];
    
    self.loginView.quickLoginDouban.delegate = self;
    self.loginView.quickLoginSina.delegate = self;
    self.loginView.quickLoginQQ.delegate = self;
    
    self.loginView.userNameTextField.delegate = self;
    self.loginView.passwordTextField.delegate = self;
    
    
    
    
    
}

- (void)enterMainView
{
    XEJMainTabBarController *mainView = [XEJMainTabBarController new];
    //delegate最好像这样创建了顺便就赋值self，在其他地方有时会有一些强引用问题出现
    mainView.delegate = self;
    //self.view.window.rootViewController = mainView;
    [self presentViewController:mainView
                       animated:YES
                     completion:nil];
}

- (void)actionUndefinedd
{
    NSLog(@"Button clicked.");
    [SVProgressHUD showInfoWithStatus:@"功能暂未实现"];
}


#pragma mark - UITabBarControllerDelegate
/*
 - (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
 {
 return NO;
 }
 */

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"点击了第%lu个标签。", (unsigned long)tabBarController.selectedIndex);
    if (tabBarController.selectedIndex == 1 || tabBarController.selectedIndex == 2) {
        tabBarController.selectedViewController = tabBarController.viewControllers[0];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录"
                                                            message:@"登录后才能操作"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"登录", nil];
        [alertView show];
    }
    
    if (tabBarController.selectedIndex == 3) {
        tabBarController.selectedViewController = tabBarController.viewControllers[0];
        
        CGFloat barWidth = tabBarController.tabBar.frame.size.width;
        CGFloat barHeight = tabBarController.tabBar.frame.size.height;
        CGFloat popWidth = barWidth - barWidth / 5 / 2;
        //删除了源文件的箭头
        //高度想把它翻转过来没成功，只能减去表格高（rowheight36 * 4），加一点空白
        CGFloat popHeight = self.view.frame.size.height - barHeight - 144 - 13;
        //CGFloat popHeight = barHeight;

        CGPoint popOrigin = CGPointMake(popWidth, popHeight);
        
        NSArray *titles = @[@"登录和注册", @"夜间模式", @"系统设置", @"简书发钱啦"];
        NSArray *imageNames = @[@"tabMore_avatar", @"tabMore_night", @"tabMore_setting", @"tabMore_money"];
        
        PopoverView *popMore = [[PopoverView alloc] initWithPoint:popOrigin
                                                           titles:titles
                                                       imageNames:imageNames];
        popMore.delegate = self;
        [popMore show];
    }
}

#pragma mark - PopoverViewDelegate
- (void)didSelectedRowAtIndex:(NSInteger)index
{
    [SVProgressHUD showInfoWithStatus:@"功能暂未实现"];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSLog(@"点击了登录按钮。");
        [self dismissViewControllerAnimated:YES
                                                          completion:nil];
    }
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self actionUndefinedd];
    textField.text = @"";
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - XEJQuickLoginViewDelegate
- (void) buttonClicked:(XEJQuickLoginView *)quickLoginViewButton
{
    [self actionUndefinedd];
}

#pragma mark

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
