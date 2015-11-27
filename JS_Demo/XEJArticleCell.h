//
//  XEJArticleCell.h
//  JS_Demo
//
//  Created by X on 15/11/15.
//  Copyright (c) 2015年 ej. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XEJArticleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *readNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeNumLabel;

@end
