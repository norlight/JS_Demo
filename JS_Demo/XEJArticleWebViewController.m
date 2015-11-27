//
//  XEJArticleWebViewController.m
//  JS_Demo
//
//  Created by X on 15/11/23.
//  Copyright (c) 2015年 ej. All rights reserved.
//

#import "XEJArticleWebViewController.h"
#import <SVProgressHUD.h>
#import <AMScrollingNavbar.h>
#import <MJRefresh.h>


@interface XEJArticleWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) NSString *htmlString;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation XEJArticleWebViewController

#pragma mark - Life cycle

- (instancetype)initWithHTMLString:(NSString *)htmlString
{
    self = [super init];
    if (self) {
        self.htmlString = htmlString;
        UIImage *back = [[UIImage imageNamed:@"NavBarIcon_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        //返回一个新的不会被渲染的UIImage，这样图片就不会被系统染为蓝色
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:back
                                                                           style:UIBarButtonItemStyleBordered
                                                                          target:self
                                                                          action:@selector(back)];
        self.navigationItem.leftBarButtonItem = backButtonItem;
        
        //模态显示的显示风格，默认从下划入，此处FlipHorizontal为翻转
        self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        

    }
    
    return self;
}

- (void)loadView
{
    UIWebView *webView = [UIWebView new];
    //缩放以适应页面？当然这里加不加一样，估计用于那些有固定大框架，不对其重新排版而整体缩小？
    webView.scalesPageToFit = YES;
    //如果页面有引用了本地资源，baseURL指定其起始位置
    [webView loadHTMLString:self.htmlString
                    baseURL:nil];
    
    webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [webView loadHTMLString:self.htmlString
                        baseURL:nil];
    }];
    
    //手势识别（默认识别右划），可按需要的方向设置其direction属性
    //估计是其因含ScrollView，一般的触摸事件想必都已经被定义了，无效，用手势能优先识别
    UIGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(back)];
    [webView addGestureRecognizer:swipeRight];
    
    webView.delegate = self;
    
    //单独拿一个属性来放webView，类型不同，万一有啥特定发给webView消息需要它响应呢，此后的view当然也能响应，不过少了IDE提示啊
    self.webView = webView;
    self.view = webView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //注意有关view的操作要放在这里，比如把下边这些代码放在init处并不会起效果，原因是彼时view还未加载，毛视图元素都没有
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.barTintColor= [UIColor whiteColor];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //滚动时隐藏导航条
    self.navigationController.navigationBar.translucent = NO;
    [self followScrollView:self.webView
                 withDelay:50.0f];
}

- (void)back
{
    //取消模态显示
    //presentingViewController返回自己“正在被谁显示着”
    //注意，返回的不一定是self的上一级控制器，可能是上一级的上一级的上一级……是族系最根部的那个容器控制器。
    //所以如果根部是一个导航，那么可以看到导航条被模态控制器给覆盖了
    //completion可以放取消模态返回后的需要一些操作，比如重新载入列表数据之类
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}


#pragma mark - UIWebViewDelegate
//开始加载
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //等待时弹个菊花免得突兀
    [SVProgressHUD show];
}

//加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
    [self.webView.scrollView.mj_header endRefreshing];
}

//加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"加载失败。Error:%@", error);
    [SVProgressHUD showErrorWithStatus:@"加载失败。"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //万一没加载完要返回呢，不能还在菊花在那转啊
    [SVProgressHUD dismiss];
}


#pragma mark - Touch event
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self back];
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
