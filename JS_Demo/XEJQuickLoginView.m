//
//  XEJCircleView.m
//  JS_Demo
//
//  Created by X on 15/11/8.
//  Copyright (c) 2015年 ej. All rights reserved.
//

#import "XEJQuickLoginView.h"
#import "Masonry.h"

@implementation XEJQuickLoginView


#pragma mark - Life cycle

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
    //创建一个贝塞尔路径，准备绘制圆
    UIBezierPath *circlePath = [UIBezierPath new];
    
    circlePath.lineWidth = 0.5;  //线条宽度
    //圆半径为长、高里面较小的那个，避免绘制的圆在视图外
    //但是由于存在线宽，所以还是存在一半线宽绘制在视图外，这点得处理下
    float radius = (MIN(self.bounds.size.width, self.bounds.size.height) / 2) - (circlePath.lineWidth / 2);
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);

    [circlePath addArcWithCenter:center
                          radius:radius
                      startAngle:0
                        endAngle:M_PI * 2.0
                       clockwise:YES];
    
    [[UIColor lightGrayColor] setStroke];  //绘制颜色
    
    //绘制路径
    [circlePath stroke];

}


- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
        [self addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.equalTo(self).with.multipliedBy(0.5);
        }];

    }
    
    return self;
}

#pragma mark - Touch event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(buttonClicked:)]) {
        [self.delegate buttonClicked:self];
    }
}


@end
