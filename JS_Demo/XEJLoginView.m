//
//  XEJLoginView.m
//  JS_Demo
//
//  Created by X on 15/11/7.
//  Copyright (c) 2015年 ej. All rights reserved.
//

#import "XEJLoginView.h"
#import "Masonry.h"

@interface XEJLoginView ()

@property (nonatomic, strong) UIView *middleView;

@end

@implementation XEJLoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTopView];
        [self addBottomView];
        [self addMiddleView];

    };
    
    return self;
}


- (void)addTopView
{
    UIButton *closeButton = [UIButton new];
    self.closeButton = closeButton;
    [closeButton setImage:[UIImage imageNamed:@"login_close.png"] forState:UIControlStateNormal];
    [self addSubview:closeButton];  //需要先addSubview后才能使用自动布局
    
    //为关闭按钮添加top、right两个布局，让它始终位于右上角
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);  //mas_equalTo用于基本类型、结构等，equalTo则跟着具体对象；iPhone状态栏高度为20
        make.right.mas_equalTo(-20);  //注意坐标轴方向
    }];
}

- (void)addBottomView
{
    UIButton *registerButton = [UIButton new];
    UIButton *browseButton = [UIButton new];
    self.registerButton = registerButton;
    self.browseButton = browseButton;
    
    [registerButton setTitle:@"注册简书帐号" forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [registerButton setTitleColor:XEJJSColor
                         forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [browseButton setTitle:@"随便看看" forState:UIControlStateNormal];
    browseButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
    [browseButton setTitleColor:XEJJSColor
                       forState:UIControlStateHighlighted];
    [browseButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    UIImageView *lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
    //lineImageView.contentMode = UIViewContentModeScaleToFill;
    //lineImageView.frame = CGRectMake(0, 0, 1, 20);

    
    //新创建一个新的视图来放两个按钮，需要使它们成为一个整体居中
    UIView *buttonView = [UIView new];
    [buttonView addSubview:registerButton];
    [buttonView addSubview:browseButton];
    [buttonView addSubview:lineImageView];
    [self addSubview:buttonView];
    
    //block会在内部保留其所捕获的变量，所以最好声明一个弱引用来避免引用循环
    __weak typeof(self) weakSelf = self;
    
    //居中
    [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(buttonView.superview).with.offset(-10);
        make.height.mas_equalTo(25);
        make.width.equalTo(@194);
        make.centerX.equalTo(weakSelf);
    }];
    
    
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.equalTo(lineImageView.mas_left).offset(-15);
    }];
    [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.mas_equalTo(0);
    }];
    [browseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineImageView.mas_right).with.offset(15);
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    
}


- (void)addMiddleView
{
    UIView *middleView = [UIView new];
    self.middleView = middleView;
    [self addSubview:middleView];
    
    __weak typeof(self) weakSelf = self;
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf);
        make.height.equalTo(weakSelf).with.multipliedBy(0.7);
        make.center.equalTo(weakSelf);
    }];
    
    
    //logo部分
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_logo.png"]];
    self.logoImageView = logoImageView;
    [middleView addSubview:logoImageView];
    
    //注意contentMode属性是UIView就有的了！！不过常在ImageView中用到。。ScaleAspectFit、Fill按比例全幅显示、裁剪，ScaleToFill拉伸。
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;

    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.equalTo(logoImageView.superview);
        make.width.equalTo(logoImageView.superview).multipliedBy(0.3);
    }];
    
    
    //普通方式登录部分
    UITextField *userNameTextField = [UITextField new];
    UITextField *passwordTextField = [UITextField new];
    self.userNameTextField = userNameTextField;
    self.passwordTextField = passwordTextField;
    [middleView addSubview:userNameTextField];
    [middleView addSubview:passwordTextField];
    
    userNameTextField.placeholder = @"邮箱";
    userNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    [userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImageView.mas_bottom).with.offset(0);  //logo文字下边留有不少空白？
        make.centerX.equalTo(userNameTextField.superview);
        make.width.equalTo(userNameTextField.superview).with.offset(10);
        make.height.mas_equalTo(50);
    }];
    
    passwordTextField.placeholder = @"密码";
    passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    passwordTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    [passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        //偏移量为0的话两条边重叠在一起，颜色会比其他线深一点，所以反方向覆盖一个像素，相对应高度少一个像素，这样两个框看起来就一毛一样了。。
        make.top.equalTo(userNameTextField.mas_bottom).with.offset(-1);
        make.centerX.equalTo(userNameTextField.superview);
        make.width.equalTo(userNameTextField.superview).with.offset(10);
        make.height.mas_equalTo(49);
    }];
    
    UIImageView *insertRightView = [[UIImageView alloc ] initWithImage:[UIImage imageNamed:@"login_icon_forgetpw.png"]];
    CGRect frame = insertRightView.frame;
    frame.size = CGSizeMake(20, 20);
    insertRightView.frame = frame;  //注意这里Size无法直接赋值，会出现"expression is not assignable"，只得这样提供temp迂回
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [rightView addSubview:insertRightView];  //笨办法嵌套一层视图让RightView看起来不会跟着TextField偏移至屏幕外去
    
    passwordTextField.rightView = rightView;
    passwordTextField.rightViewMode = UITextFieldViewModeAlways;
    
    UIButton *loginButton = [UIButton new];
    self.loginButton = loginButton;
    [middleView addSubview:loginButton];
    
    [loginButton setTitle:@"登录"
                 forState:UIControlStateNormal];
    loginButton.backgroundColor = XEJJSColor;
    loginButton.layer.cornerRadius = 3;  //设置layer层导角半径，之后将按钮超出bounds部分裁剪掉，实现圆角效果
    loginButton.clipsToBounds = YES;
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordTextField.mas_bottom).with.offset(20);
        make.height.mas_equalTo(50);
        make.left.equalTo(loginButton.superview).with.offset(20);  //不知为何相对于middleView无效，只能self
        make.right.equalTo(loginButton.superview).with.offset(-20);

    }];
    
    
    
    //快速登录部分
    UILabel *otherLoginLabel = [UILabel new];
    otherLoginLabel.text = @"使用其他方式登录";
    [middleView addSubview:otherLoginLabel];
    
    otherLoginLabel.textColor = [UIColor lightGrayColor];
    
    [otherLoginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginButton.mas_bottom).with.offset(25);
        make.centerX.equalTo(otherLoginLabel.superview);
    }];
    
    XEJQuickLoginView *quickLoginSina = [[XEJQuickLoginView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)
                                                                       imageName:@"login_icon_sina.png"];
    XEJQuickLoginView *quickLoginQQ = [[XEJQuickLoginView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)
                                                                     imageName:@"login_icon_qq.png"];
    XEJQuickLoginView *quickLoginDouban = [[XEJQuickLoginView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)
                                                                         imageName:@"login_icon_douban.png"];
    
    
    self.quickLoginSina = quickLoginSina;
    self.quickLoginQQ = quickLoginQQ;
    self.quickLoginDouban = quickLoginDouban;

    [middleView addSubview:quickLoginSina];
    [middleView addSubview:quickLoginQQ];
    [middleView addSubview:quickLoginDouban];
    
    [quickLoginQQ mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(quickLoginQQ.superview);
        make.top.equalTo(otherLoginLabel.mas_bottom).with.offset(25);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    [quickLoginSina mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(otherLoginLabel.mas_bottom).with.offset(25);
        make.size.equalTo(quickLoginQQ);
        make.right.equalTo(quickLoginQQ.mas_left).with.offset(-45);
    }];
    [quickLoginDouban mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(otherLoginLabel.mas_bottom).with.offset(25);
        make.size.equalTo(quickLoginQQ);
        make.left.equalTo(quickLoginQQ.mas_right).with.offset(45);
    }];

    

    
    
}


//取消输入状态，隐藏键盘

//UIWindow有一个第一响应者属性，用于处理除触摸事件外（触摸事件由UIView对象处理）的其他事件（摇晃、输入等）
//当聚焦UITextField时，UITextField就会成为第一响应者，而当第一响应者是UITextField对象时，键盘会弹出
//假若视图或其下的子视图是第一响应者，那么当它收到endEditing:消息时，它会取消放弃自己的第一响应者状态
//此外当然也可以手动发送消息成为或放弃第一响应者状态

//这里是刚好VC的View是一个单独的类，假若不是，那么估计没法直接覆盖触摸方法
//这种情况的另一可能行得通的方法是，将UIView进行类型转换为UIControl，然后应该能像UIButton一样添加目标动作对
//VC的view属性可以直接赋值为UIControl
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}


@end
