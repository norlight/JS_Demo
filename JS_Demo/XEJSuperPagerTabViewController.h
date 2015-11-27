//
//  XEJSuperPagerTabViewController.h
//  JS_Demo
//
//  Created by X on 15/11/11.
//  Copyright (c) 2015年 ej. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMPagerTabView.h"

@interface XEJSuperPagerTabViewController : UIViewController<SMPagerTabViewDelegate>

- (instancetype)initWithViewControllers:(NSArray *)childVCs;


@end
