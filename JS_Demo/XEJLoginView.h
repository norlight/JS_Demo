//
//  XEJLoginView.h
//  JS_Demo
//
//  Created by X on 15/11/7.
//  Copyright (c) 2015年 ej. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XEJQuickLoginView.h"


@interface XEJLoginView : UIView


@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UITextField *userNameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
//@property (nonatomic, strong) UIButton *forgetPWButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) XEJQuickLoginView *quickLoginSina;
@property (nonatomic, strong) XEJQuickLoginView *quickLoginQQ;
@property (nonatomic, strong) XEJQuickLoginView *quickLoginDouban;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UIButton *browseButton;


@end
