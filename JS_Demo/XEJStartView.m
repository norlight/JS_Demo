//
//  XEJStartView.m
//  JS_Demo
//
//  Created by X on 15/11/3.
//  Copyright (c) 2015年 ej. All rights reserved.
//

#import "XEJStartView.h"


@interface XEJStartView ()

@property (nonatomic, strong)UIImageView *launchImageView;

@end

@implementation XEJStartView


- (instancetype)init
{
    XEJStartView *startView = [self initWithLaunchImage:[UIImage imageNamed:@"Introduction0.jpeg"]];
    
    return startView;
}
- (instancetype)initWithLaunchImage:(UIImage *)launchImage
{
    CGRect frame = [UIScreen mainScreen].bounds;
    if (self == [super initWithFrame:frame]) {
        self.launchImageView = [[UIImageView alloc] initWithFrame:frame];
        self.launchImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.launchImageView.image = launchImage;
        [self addSubview:self.launchImageView];
    }
    
    return self;
}


//imageView的淡入动画
- (void)startAnimationWithCompletionBlock:(void (^)(XEJStartView *))completionBlock
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    [keyWindow addSubview:self];
    //将imageView带到屏幕窗口最前面，窗口会把子视图数组内最新加入的视图提到最前面显示，借此暂时覆盖RootVC
    [keyWindow bringSubviewToFront:self];
    self.launchImageView.alpha = 0.0;
    
    //添加一个基础动画，让imageView的alpha值从0变为1，实现淡入效果
    [UIView animateWithDuration:3.0
                     animations:^{
                         self.launchImageView.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         //淡入效果结束后再添加动画，通过改变imageView的frame让它“嗖”一下向左划出
                         [UIView animateWithDuration:0.5
                                          animations:^{
                                              CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                                              CGRect frame = self.frame;
                                              frame.origin.x = -screenWidth;
                                              self.frame = frame;
                                          }
                                          completion:^(BOOL finished) {
                                              //划出后当然别忘了从父视图从移除，恢复RootVC的显示
                                              [self removeFromSuperview];
                                              
                                              //如果有block传进来，接着执行掉便是
                                              if (completionBlock) {
                                                  completionBlock(self);
                                              }
                                          }];
                     }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
