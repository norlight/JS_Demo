//
//  XEJCircleView.h
//  JS_Demo
//
//  Created by X on 15/11/8.
//  Copyright (c) 2015年 ej. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XEJQuickLoginViewDelegate;


@interface XEJQuickLoginView : UIView

@property (nonatomic, weak) id <XEJQuickLoginViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName;

@end


@protocol XEJQuickLoginViewDelegate <NSObject>

@optional
- (void)buttonClicked:(XEJQuickLoginView *)quickLoginViewButton;

@end
