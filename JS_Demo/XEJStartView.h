//
//  XEJStartView.h
//  JS_Demo
//
//  Created by X on 15/11/3.
//  Copyright (c) 2015年 ej. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XEJStartView : UIView

/*
 *启动页面的渐变效果
 */


- (instancetype)init;
- (instancetype)initWithLaunchImage:(UIImage *)launchImage;

- (void)startAnimationWithCompletionBlock:(void (^)(XEJStartView *startView))completionBlock;


@end
