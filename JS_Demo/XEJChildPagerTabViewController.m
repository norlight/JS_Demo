//
//  XEJChildPagerTabViewController.m
//  JS_Demo
//
//  Created by X on 15/11/11.
//  Copyright (c) 2015年 ej. All rights reserved.
//

#import "XEJChildPagerTabViewController.h"
#import "XEJArticleListController.h"
#import <DLScrollTabbarView.h>
#import <DLLRUCache.h>

@interface XEJChildPagerTabViewController ()<DLCustomSlideViewDelegate>

//@property (nonatomic, strong) NSMutableArray *childVCs;
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) NSDictionary *articleCategories;
@property (nonatomic, strong) NSArray *articleCategoryTitles;
//@property (nonatomic, strong) NSArray *articleCategoryURLStrings;


@end

@implementation XEJChildPagerTabViewController


#pragma mark - Life cycle
- (instancetype) init
{
    self = [super init];
    self.articleCategories = @{@"热门" : @"",
                               @"七日热门" : @"trending/weekly",
                               @"三十日热门" : @"trending/monthly",
                               @"最新" : @"recommendations/notes?category_id=56",
                               @"生活家" : @"recommendations/notes?category_id=4",
                               @"世间事" : @"recommendations/notes?category_id=10",
                               @"@IT" : @"recommendations/notes?category_id=8",
                               @"视频" : @"recommendations/notes?category_id=59",
                               @"七嘴八舌" : @"recommendations/notes?category_id=57",
                               @"电影" : @"recommendations/notes?category_id=25",
                               @"经典" : @"recommendations/notes?category_id=52",
                               @"连载" : @"recommendations/notes?category_id=43",
                               @"读图" : @"recommendations/notes?category_id=45",
                               @"市集" : @"recommendations/notes?category_id=51",
                               };
    //self.articleCategoryTitles = [self.articleCategories allKeys];
    //self.articleCategoryURLStrings = [self.articleCategories allValues];
    self.articleCategoryTitles = @[@"热门",
                                    @"周热门",
                                    @"月热门",
                                    @"最新",
                                    @"生活家",
                                    @"世间事",
                                    @"@IT",
                                    @"视频",
                                    @"七嘴八舌",
                                    @"电影",
                                    @"经典",
                                    @"连载",
                                    @"读图",
                                    @"市集",
                                    ];

    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO; //禁用内边界自适应，YES的话tabbarVC会自动调整ScrollView的inset
    DLCustomSlideView *slideView = [[DLCustomSlideView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:slideView];
    self.slideView = slideView;
    self.slideView.delegate = self;
    
    DLLRUCache *cache = [[DLLRUCache alloc] initWithCount:6];  //每一屏内要放的标签数
    DLScrollTabbarView *tabbar = [[DLScrollTabbarView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 34)];
    tabbar.tabItemNormalColor = [UIColor grayColor];
    tabbar.tabItemSelectedColor = XEJJSColor;
    tabbar.tabItemNormalFontSize = 14.0f;
    tabbar.trackColor = [UIColor colorWithRed:243 / 255.0f green:243 / 255.0f blue:243 / 255.0f alpha:1];
    tabbar.backgroundColor = [UIColor colorWithRed:243 / 255.0f green:243 / 255.0f blue:243 / 255.0f alpha:1];
    
    self.itemArray = [NSMutableArray array];
    /*
    //遍历字典，将key作为标签标题
    for (id key in self.articleCategories) {
        
        DLScrollTabbarItem *item = [DLScrollTabbarItem new];
        CGFloat width = self.view.frame.size.width;
        item = [DLScrollTabbarItem itemWithTitle:[NSString stringWithString:key]
                                           width:width / 6];
        [self.itemArray addObject:item];
    }
     */
    
    for (int i = 0; i < [self.articleCategoryTitles count]; i++) {
        DLScrollTabbarItem *item = [DLScrollTabbarItem new];
        CGFloat width = self.view.frame.size.width;
        item = [DLScrollTabbarItem itemWithTitle:[NSString stringWithString:self.articleCategoryTitles[i]]
                                           width:width / 6];
        [self.itemArray addObject:item];    }
    
    tabbar.tabbarItems = self.itemArray;
    
    self.slideView.tabbar = tabbar;
    self.slideView.cache = cache;
    self.slideView.tabbarBottomSpacing = 0;
    self.slideView.baseViewController = self;
    [self.slideView setup];
    self.slideView.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfTabsInDLCustomSlideView:(DLCustomSlideView *)sender{
    return self.itemArray.count;
}

- (UIViewController *)DLCustomSlideView:(DLCustomSlideView *)sender controllerAt:(NSInteger)index{
    
    /*
    UIViewController *vc = [UIViewController new];
    vc.view.backgroundColor = [UIColor colorWithHue:arc4random_uniform(255) / 255.0f
                                         saturation:arc4random_uniform(255) / 255.0f
                                         brightness:arc4random_uniform(255) / 255.0f
                                              alpha:0.5];
    
    return vc;
     */
    
    //XEJArticleListController *vc = [XEJArticleListController new];
    NSString *title = self.articleCategoryTitles[index];
    NSString *URLString = self.articleCategories[title];
    
    XEJArticleListController *vc = [[XEJArticleListController alloc] initWithURLString:URLString];
    
    return vc;

}




@end
