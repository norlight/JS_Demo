//
//  XEJIntroductionViewController.m
//  JS_Demo
//
//  Created by X on 15/11/5.
//  Copyright (c) 2015年 ej. All rights reserved.
//

#import "XEJIntroductionViewController.h"
#import "XEJIntroductionView.h"
#import "XEJLoginViewController.h"

@interface XEJIntroductionViewController ()<XEJIntroductionViewDelegate>

@end

@implementation XEJIntroductionViewController

- (void)loadView
{
    XEJIntroductionView *view = [[XEJIntroductionView alloc] init];
    view.delegate = self;
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self.view addSubview:[[XEJIntroductionView alloc] init]];
}

- (void)enterButtonClicked:(XEJIntroductionView *)introductionView
{
    NSLog(@"enterButton Clicked");
    self.view.window.rootViewController = [XEJLoginViewController new];
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
