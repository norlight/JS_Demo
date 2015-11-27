//
//  XEJWriteButton.m
//  JS_Demo
//
//  Created by X on 15/11/10.
//  Copyright (c) 2015年 ej. All rights reserved.
//

#import "XEJWriteButton.h"

@implementation XEJWriteButton

#pragma mark - Life Cycle

+(void)load
{
    [super registerSubclass];
}

+(instancetype)plusButton
{
    UIImage *buttonImage = [UIImage imageNamed:@"write.png"];

    XEJWriteButton *writeButton = [XEJWriteButton new];
    writeButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    writeButton.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [writeButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    //注意这里的target，如果是self，由于此时的self是一个类，所以发送的消息得是类方法（+）
    //如果想用普通方法（-），此处要为对象（writeButton）
    [writeButton addTarget:writeButton
                    action:@selector(buttonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    
    return writeButton;
                                   
}

//直接一个sender参数就可以把按钮传进来，好用！
- (void)buttonClicked:(UIButton *)sender
{
    //NSLog(@"点击了写作按钮。");
    
    //UITabBarController *tabBarVC = (UITabBarController *)self.window.rootViewController;
    //UIViewController *vc = tabBarVC.viewControllers[0];
    UIViewController *vc = self.window.rootViewController;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录"
                                                        message:@"登录后才能操作"
                                                       delegate:vc
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"登录", nil];
    [alertView show];
     
    /*
    //UIView如果有控制器控制着，则其nextResponder指向该控制器，没有的话就指向其父类
    //控制器的nextResponder指向其view的父视图
    //最终祖视图为UIWindow，再到最最终的UIApplication
    //响应链可用来想这样查找view上层的控制器或父视图等，好用
    for (UIView *view = sender; view; view = view.superview) {
        UIResponder *responder = [view nextResponder];
        if ([responder isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tbvc = (UITabBarController *)responder;
            UIViewController *vc = tbvc.viewControllers[0];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录"
                                                                message:@"登录后才能操作"
                                                               delegate:vc
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"登录", nil];
            [alertView show];
            
        }
    }
     */
    
    
}

@end
