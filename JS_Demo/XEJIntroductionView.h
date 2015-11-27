//
//  XEJIntroductionView.h
//  JS_Demo
//
//  Created by X on 15/11/4.
//  Copyright (c) 2015年 ej. All rights reserved.
//

#import <UIKit/UIKit.h>

//协议先声明下，以免下边的delegate属性找不到
@protocol XEJIntroductionViewDelegate;

@interface XEJIntroductionView : UIView

@property (nonatomic, weak) id<XEJIntroductionViewDelegate> delegate;


- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame
                       images:(NSArray *)images;

@end


//协议放在@interface下面以免下面参数找不到类型
@protocol XEJIntroductionViewDelegate <NSObject>

@optional
- (void)enterButtonClicked:(XEJIntroductionView *)introductionView;

@end


/*
 协议总结
 两边（声明的和遵守的）一一对应共要注意3处：
 协议的声明（头文件中，委托协议的方法一般都设为可选）————遵守协议；
 delegate属性的声明（内存管理语义要为weak，类型自然为id，别忘了要尖括号内遵守协议）————delegate属性的赋值；
 协议方法的调用（可选方法要先判断是否响应）————协议方法的实现；
*/