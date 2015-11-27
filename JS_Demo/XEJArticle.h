//
//  XEJArticle.h
//  JS_Demo
//
//  Created by X on 15/11/19.
//  Copyright (c) 2015年 ej. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XEJArticle : NSObject

@property (nonatomic, copy) NSString *imageURLString;  //图片地址
@property (nonatomic, copy) NSString *articleURLString;  //文章地址
@property (nonatomic, copy) NSString *author;  //作者
@property (nonatomic, copy) NSString *time;  //发布时间
@property (nonatomic, copy) NSString *title;  //标题
@property (nonatomic, copy) NSString *readNum;  //阅读数
@property (nonatomic, copy) NSString *commentsNum;  //评论数
@property (nonatomic, copy) NSString *likeNum;  //喜欢（数）


@end
