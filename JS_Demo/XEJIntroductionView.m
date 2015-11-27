//
//  XEJIntroductionView.m
//  JS_Demo
//
//  Created by X on 15/11/4.
//  Copyright (c) 2015年 ej. All rights reserved.
//

#import "XEJIntroductionView.h"



@interface XEJIntroductionView ()<UIScrollViewDelegate>

@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIPageControl *pageControl;


@end

@implementation XEJIntroductionView

#pragma mark - lifeCycle
- (instancetype)init
{
    XEJIntroductionView *iView = [[XEJIntroductionView alloc] initWithFrame:[UIScreen mainScreen].bounds
                                                                    images:@[@"Introduction1.jpeg", @"Introduction2.jpeg", @"Introduction3.jpeg", @"Introduction4.jpeg"]];
    
    return iView;
}

//指定初始化方法
- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addScrollViewWithImages:images];  //添加一个无滚动条、可分页的ScrollView
        [self addPageControlWithImages:images];   //添加一个PageControl（小圆点）
    }
    
    return self;
}


#pragma mark - ScrollView, PageControl
- (void)addScrollViewWithImages:(NSArray *)images
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    scrollView.pagingEnabled = YES;  //启用分页，系统默认是粘连
    scrollView.showsHorizontalScrollIndicator = NO;  //不显示滚动条，系统默认YES
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;  //代理，需要它实现页面滑动小圆点跟着滑动
    
    self.scrollView = scrollView;
    [self addImagesForScrollView:images];  //把images数组中的图像加到ScrollView中
    
    [self addSubview:self.scrollView];
}

- (void)addImagesForScrollView:(NSArray *)images
{
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * (images.count), self.frame.size.height);  //取景大小为所有图像总和，系统默认CGSizeZero
    
    for (int i = 0; i < images.count; i++) {
        CGRect currentImageFrame = CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height);
        UIImageView *currentImageView = [[UIImageView alloc] initWithFrame:currentImageFrame];
        currentImageView.contentMode = UIViewContentModeScaleAspectFill;
        currentImageView.clipsToBounds = YES;
        currentImageView.image = [UIImage imageNamed:images[i]];
        
        //划到最后一页时，为页面添加一个进入按钮
        if (i == images.count - 1) {
            [self addEnterButton:currentImageView];
        }
        
        [self.scrollView addSubview:currentImageView];
    }
}

- (void)addEnterButton:(UIImageView *)imageView
{
    //需先开启用户交互，ImageView才能接收动作（默认为NO）。此值继承于UIView（默认YES），类似的UILabel也有这个值（默认NO）。
    imageView.userInteractionEnabled = YES;
    UIButton *enterButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 55, self.frame.size.height / 2 - 24, 30, 48)];
    [enterButton setImage:[UIImage imageNamed:@"enterButton"] forState:UIControlStateNormal];
    [enterButton addTarget:self action:@selector(enterButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:enterButton];
}

- (void)enterButtonClicked:(UIButton *)button
{
    //enter app
    //NSLog(@"enterButton Clicked");
    if ([self.delegate respondsToSelector:@selector(enterButtonClicked:)]) {
        [self.delegate enterButtonClicked:self];
    }
}


- (void)addPageControlWithImages:(NSArray *)images
{
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 20)];
    pageControl.numberOfPages = [images count];
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];  //小圆点默认颜色
    pageControl.currentPageIndicatorTintColor = XEJJSColor;  //当前小圆点颜色
    
    self.pageControl = pageControl;
    [self addSubview:pageControl];
}


#pragma mark - UIScrollViewDelegate
//滚动停止时触发此方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //contentOffset表示contentView原点相对于ScrollView原点的偏移量，比如向左滑动了一页，此时的Offset就是一个width，初始为CGPointZero
    //借此可以算出偏移了多少页，当前是哪一页
    //NSLog(@"%f", scrollView.contentOffset.x);
    self.pageControl.currentPage = scrollView.contentOffset.x / self.frame.size.width;
    
}
@end
