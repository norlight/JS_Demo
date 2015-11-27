//
//  XEJSuperPagerTabViewController.m
//  JS_Demo
//
//  Created by X on 15/11/11.
//  Copyright (c) 2015年 ej. All rights reserved.
//

#import "XEJSuperPagerTabViewController.h"
#import "XEJChildPagerTabViewController.h"
#import "XEJLoginViewController.h"

@interface XEJSuperPagerTabViewController ()

@property (nonatomic, strong) NSArray *childVCs;
@property (nonatomic, strong) SMPagerTabView *pagerTabView;

@end

@implementation XEJSuperPagerTabViewController


#pragma mark - LifeCycle
- (instancetype)initWithViewControllers:(NSArray *)childVCs
{
    self = [super init];
    if (self) {
        self.childVCs = childVCs;
    };
    
    return self;
    
}
- (instancetype)init
{
    NSMutableArray *childVCs = [NSMutableArray new];
    XEJChildPagerTabViewController *one = [XEJChildPagerTabViewController new];
    one.title = @"文章";
    [childVCs addObject:one];

    XEJChildPagerTabViewController *two = [XEJChildPagerTabViewController new];
    two.title = @"专题";
    [childVCs addObject:two];
    


    
    self = [self initWithViewControllers:childVCs];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    SMPagerTabView *pagerTabView = [[SMPagerTabView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20 )];
    self.pagerTabView = pagerTabView;
    [self.view addSubview:pagerTabView];
    pagerTabView.delegate = self;
    
    pagerTabView.tabButtonFontSize = 16;  //标签字体大小
    pagerTabView.tabButtonTitleColorForNormal = [UIColor lightGrayColor];  //标签默认颜色
    //标签高亮颜色——源文件把UIColor声明为了assign，出了点莫名问题。原作者的podspec文件还少了个逗号，貌似没法用。。真是个考眼神的库。。。
    pagerTabView.tabButtonTitleColorForSelected = XEJJSColor;
    pagerTabView.tabMargin = self.view.frame.size.width * 0.1;  //标签距离屏幕边缘的空白
    pagerTabView.selectedLineWidth = (self.view.frame.size.width / [self.childVCs count]) - pagerTabView.tabMargin;  //下划线长度
    pagerTabView.selectedLineHeight = 4;  //下划线粗细
    pagerTabView.selectedLineColor = XEJJSColor;
    
    [pagerTabView buildUI];

    [pagerTabView selectTabWithIndex:0 animate:NO];  //起始标签

    
    
    
    
}

#pragma mark - SMPagerTabViewDelegate
- (NSUInteger)numberOfPagers:(SMPagerTabView *)view
{
    return [self.childVCs count];
}
- (UIViewController *)pagerViewOfPagers:(SMPagerTabView *)view indexOfPagers:(NSUInteger)number
{
    return _childVCs[number];
}






@end
