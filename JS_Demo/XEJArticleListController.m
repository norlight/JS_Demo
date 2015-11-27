//
//  XEJArticleListController.m
//  JS_Demo
//
//  Created by X on 15/11/15.
//  Copyright (c) 2015年 ej. All rights reserved.
//

#import "XEJArticleListController.h"
#import "XEJArticleWebViewController.h"
#import "XEJArticleCell.h"
#import "XEJArticle.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <TFHpple.h>
#import <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import "ZLImageViewDisplayView.h"
#import <RegexKitLite.h>


@interface XEJArticleListController ()

@property (nonatomic, strong) NSMutableArray *articles;  //tableView文章
@property (nonatomic, strong) NSMutableArray *headerArticles;  //顶部轮播视图文章
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSString *URLString;

@end

@implementation XEJArticleListController


#pragma mark - Life cycle

- (instancetype)init
{
    self = [self initWithURLString:@""];
    
    return self;
}

- (instancetype)initWithURLString:(NSString *)URLString
{
    self = [super init];
    
    if (self) {
        
        
        if (!_articles) {
            _articles = [NSMutableArray array];
        }
        
        if (!_headerArticles) {
            _headerArticles = [NSMutableArray array];
        }
        
        self.URLString = URLString;

        [self fetchArticles];

    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //为tableView注册cell（nib文件方式）
    UINib *cellNib = [UINib nibWithNibName:@"XEJArticleCell" bundle:nil];
    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:@"XEJArticleCell"];
    

    
    //首页下拉刷新
    //由于网页获取下一页的参数暂时还看不懂，拉取下一页数据就没做，目前只能看一页。。= =
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(fetchArticles)];
    
    //self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
    [self addArticleHeaderView];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //视图即将消失时也取消转圈圈，避免在那一直转
    [SVProgressHUD dismiss];
}

#pragma mark - HTML parser

- (void)fetchArticles
{
    //如果数据存在就清空，不然下拉刷新后内容会不断附加上去。当然风格不大好，暂时只有第一页数据也就先将就了。。
    if (self.articles) {
        [self.articles removeAllObjects];
    }
    //加载数据等待时的转圈圈
    [SVProgressHUD show];
    
    //发起会话请求
    
    /*
     //登陆
     //没成功，参数为nil请求失败，但随便有个参数却又有页面返回，不过是非登陆状态的，随便一个错误的账号、密码也一样
     //所以是参数并未被起作用？但paw中只需要一个sign_in[name]和sign_in[password]却又能正常登陆返回
     //打印出cookie也没看到token段
     //可能需要webView来模拟浏览器并且手动处理cookie，还没弄懂，先搁置
     NSDictionary *parameters = @{
     @"sign_in[name]" : @"username",
     @"sign_in[password]" : @"password"
     };
     
     [manager POST:@"http://www.jianshu.com/sessions" parameters:parameters
     success:^(NSURLSessionDataTask *task, id responseObject) {
     NSString *HTMLString = [[NSString alloc] initWithData:responseObject
     encoding:NSUTF8StringEncoding];
     NSLog(@"请求成功。 %@", HTMLString);
     
     
     
     } failure:^(NSURLSessionDataTask * task, NSError *error) {
     NSLog(@"请求失败。Error:%@", error);
     
     }];
     */
    
    
    NSURL *baseURL = [[NSURL alloc] initWithString:XEJJSBaseURLString];
    if (!_manager) {
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        _manager = manager;
    }

    
    //默认的responseSerializer属性为AFJSONResponseSerializer类型，会尝试将服务器返回的数据被格式化为JSON然后返回
    //但这里接收到的是HTML，所以改为AFHTTPResponseSerializer，返回NSData
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if (!self.URLString) {
        self.URLString = @"";
    }
    [self.manager GET:self.URLString
      parameters:nil
         success:^(NSURLSessionDataTask * task, id responseObject) {
             
             //NSString *HTMLString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
             //NSLog(@"请求成功。%@", HTMLString);
             
             NSLog(@"文章列表获取成功。");
             //用Hpple对返回的HTML进行解析
             [self parseHTML:responseObject
            xPathQueryString:@"/html/body/div[4]/div/div[2]/div[2]/ul[2]/li"
                 storedArray:self.articles];
             
             //更新完模型后一定要记得重新载入表格数据！！！
             [self.tableView reloadData];
             
             //加载完毕，停止刷新
             [self.tableView.mj_header endRefreshing];
             
             //加载完毕，隐藏菊花
             [SVProgressHUD dismiss];
             
         } failure:^(NSURLSessionDataTask * task, NSError * error) {
             //加载失败，停止刷新
             [self.tableView.mj_header endRefreshing];
             NSLog(@"请求失败。Error:%@", error);
             
             switch (error.code) {
                 case kCFURLErrorNotConnectedToInternet:
                     [SVProgressHUD showErrorWithStatus:@"未连接到互联网，请检查网络设置"];
                     break;
                     
                 case kCFURLErrorTimedOut:
                     [SVProgressHUD showErrorWithStatus:@"请求超时，请稍后重试"];
                     break;
                     
                 default:
                     [SVProgressHUD showErrorWithStatus:@"请求失败"];
                     break;
             }
         }];

}


- (void)parseHTML:(NSData *)data xPathQueryString:(NSString *)xPathQueryString storedArray:(NSMutableArray *)storedArray
{
    /*
     
     取回的节点类似这样：
     
     <li class="have-img">
     <a href="/p/a454335296f5" class="wrap-img"><img alt="300" src="http://upload-images.jianshu.io/upload_images/1081386-31c9dd1002ff44fa.jpg?imageMogr2/auto-orient/strip%7CimageView2/1/w/300/h/300"></a>
     <div>
     <p class="list-top">
     <a href="/users/73fd2e27dd67" target="_blank" class="author-name blue-link">Juno_2015</a>
     <em>·</em>
     <span data-shared-at="2015-11-18T20:26:20+08:00" class="time">大约24小时之前</span>
     </p>
     <h4 class="title"><a href="/p/a454335296f5" target="_blank">《北上广不相信眼泪》：棋逢对手才有看头</a></h4>
     <div class="list-footer">
     <a href="/p/a454335296f5" target="_blank">
     阅读 3909
     </a>        <a href="/p/a454335296f5#comments" target="_blank">
     · 评论 34
     </a>        <span> · 喜欢 101</span>
     
     </div>
     </div>
     </li>
     
     */
    
    
    //加载HTML内容
    TFHpple *htmlParser = [[TFHpple alloc] initWithHTMLData:data];
    //XML Path，[n]:当前节点下同级元素中的第n个，相对于按数查找，按属性值来应该更能防止网页变动而路径失效
    //NSString *articleXPathQueryString = @"/html/body/div[4]/div/div[2]/div[2]/ul[2]/li";
    
    //开始查找，返回的数组存放着所有符合条件的元素
    NSArray *elements = [htmlParser searchWithXPathQuery:xPathQueryString];
    NSLog(@"共有元素%lu个。", (unsigned long)[elements count]);
    
    //开始处理每一篇文章的信息（标题、发表时间、评论数、图片等）
    for (TFHppleElement *element in elements) {

        XEJArticle *article = [XEJArticle new];
        
        //节点包括<a>（图片信息）、<div>（标题、时间等文字信息）两个子元素，没有图片的话就只有一个<div>
        
        
        //<a>标签存在的话，就获取图片地址
        TFHppleElement *a = [element firstChildWithTagName:@"a"];
        if (a) {
            //<a>元素中只有一个<img>元素，其src属性存储的就是图片地址了
            article.imageURLString = [[a firstChildWithTagName:@"img"] objectForKey:@"src"];
            //NSLog(@"图片地址：%@", article.imageURLString);
        }
        
        
        //<div>（标题等）
        TFHppleElement *div = [element firstChildWithTagName:@"div"];
        if (div) {
            //class="list-top"(作者、时间），class="title"（标题，文章地址），class="list-footer"（评论数等）
            
            
            //class="list-top"
            TFHppleElement *listTop = [div firstChildWithClassName:@"list-top"];
            
            //text方法返回第一个文本子元素的内容，等同于firstTextChild.content
            //注意，并非每个元素都有文本内容，大多时候其内容是子元素，当然这时候content是没有东西输出的
            //比如<h3>foo</h3>这里面其实包含了一个h3标签的元素和一个文本子元素
            //不过Myhpple 0.0.3（应是等同Hpple 0.3.0版本，此版在cocoapods仓库内还没有） 可以通过content获得此处内容，Hpple 0.2.0则只能通过第一个firstTextChild
            article.author = [[listTop firstChildWithClassName:@"author-name blue-link"] text];  //作者
            //NSLog(@"作者：%@", article.author);
            
            //<span></span>之间的发表时间是数据到达浏览器后才生成的？简直了！firebug看得到的文本居然获取不到，一直为null还以为是hpple的问题。。。
            NSString *timeString = [[listTop firstChildWithClassName:@"time"] objectForKey:@"data-shared-at"];  //发表时间
            //获得的时间为RFC3339格式，类似这样：2015-11-19T11:37:33+08:00
            //以此格式创建一个NSDateFormatter，来将字符串转化为NSDate对象
            NSDateFormatter *rfc3339DateFormatter = [NSDateFormatter new];
            [rfc3339DateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
            NSDate *time = [rfc3339DateFormatter dateFromString:timeString];
            //和现在的时间差
            NSDate *now = [NSDate date];
            NSTimeInterval timeInterval = [now timeIntervalSinceDate:time];
            //根据时间差的大小不同个性化显示
            if (timeInterval < 60) {
                article.time = @"刚刚";
            } else if (timeInterval < 60 * 60){
                article.time = [NSString stringWithFormat:@"%d分钟前", (int)timeInterval / 60];
            } else if (timeInterval < 60 * 60 * 24){
                article.time = [NSString stringWithFormat:@"大约%d小时之前", (int)timeInterval / (60 * 60)];
            } else {
                article.time = [NSString stringWithFormat:@"%d天之前", (int)timeInterval / (60 * 60 *24)];
            }
            //NSLog(@"发表时间：%@", article.time);
            
            
            //class="title"
            TFHppleElement *title = [div firstChildWithClassName:@"title"];
            
            article.title = [[title firstChild] text];  //标题
            //NSLog(@"标题：%@", article.title);
            
            article.articleURLString = [[title firstChild] objectForKey:@"href"];  //文章链接
            //NSLog(@"文章链接：%@", article.articleURLString);
            
            
            //class="list-footer"
            TFHppleElement *listFooter = [div firstChildWithClassName:@"list-footer"];
            
            //节点下有两个<a>（阅读、评论）和一个<span>，两个<a>没有class，只能一个个判断其内容
            //节点下不止有看到的这三个子元素，还有其他空内容的子元素，所以有时候如果不麻烦的话精确定位每一个需要的元素会更好点
            for (TFHppleElement *child in listFooter.children) {
                NSString *string = [child text];
                
                /*
                NSRange rangeRead = [string rangeOfString:@"·"];
                if (rangeRead.location != NSNotFound) {
                    NSLog(@"发现小圆点。");
                }
                 */

                //清除文字前的那个小圆点
                string = [string stringByReplacingOccurrencesOfString:@"·" withString:@""];
                //清除两边多余空格和换行
                string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                //对处理后的字符串检测其前缀
                if ([string hasPrefix:@"阅读"]) {
                    article.readNum = string;
                    //NSLog(@"%@", article.readNum);
                } else if ([string hasPrefix:@"评论"]) {
                    article.commentsNum = string;
                    //NSLog(@"%@", article.commentsNum);
                } else if ([string hasPrefix:@"喜欢"]) {
                    article.likeNum = string;
                    //NSLog(@"%@", article.likeNum);
                }                
            }
        }
        
        //处理好每一篇文章的信息就把它放入数组
        
        [storedArray addObject:article];
        //NSLog(@"已将%lu个对象放入StoreArray。", (unsigned long)[storedArray count]);

        //return;

    }
    
    //NSLog(@"已将%lu个对象放入StoreArray。", (unsigned long)[storedArray count]);
    
    
}


- (NSString *)parseArticleContent:(NSString *)HTMLString
{
    NSString *regexString;
    NSString *newString;
    
    
    //匹配并获取正文内容，正则表达式：<div class="preview">[\s\S]*?<div class="show-content">[\s\S]*?</div>\s*?</div>\s*?(?=</div>\s*?<div class="visitor_edit">)
    //需要对表达式中所有的引号和反斜杠进行转义后才能用作NSString
    regexString = @"<div class=\"preview\">[\\s\\S]*?<div class=\"show-content\">[\\s\\S]*?</div>\\s*?</div>\\s*?(?=</div>\\s*?<div class=\"visitor_edit\">)";
    newString = [HTMLString stringByMatching:regexString];  //将匹配到的内容保留为新的NSString
    
    //获取的正文只想仅供阅读，所以去除作者链接、添加关注等交互内容
    //复用regexString和newString，如果匹配条件多的话把它们加入数组再遍历
    regexString = @"href=\"/users/[\\s\\S]*?\"";  //作者主页链接，头像和名字共两处
    newString = [newString stringByReplacingOccurrencesOfRegex:regexString
                                                    withString:@""];  //替换匹配到的内容（替换为空，清除）
    regexString = @"<div class=\"btn btn-small btn-success follow\">[\\s\\S]*?</div>";  //“添加关注”按钮
    newString = [newString stringByReplacingOccurrencesOfRegex:regexString
                                                    withString:@""];
    
    if (newString) {
        NSLog(@"正则匹配成功！");
        //NSLog(@"%@", newString);
        NSString *path = [[NSBundle mainBundle] pathForResource:@"template" ofType:@"html"];
        NSString *templateString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSString *contentString = [templateString stringByReplacingOccurrencesOfString:@"{{{content}}}" withString:newString];
        //NSLog(@"%@", contentString);
        
        return contentString;
    } else {
        NSLog(@"匹配失败。");
        return nil;
        
    }
    
}

#pragma mark - View

- (void)addArticleHeaderView
{
    if (!_manager) {
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[[NSURL alloc] initWithString:XEJJSBaseURLString]];
        _manager = manager;
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    }

    //顶部轮播视图放简书包的文章
    //图片比例2：1，取360：720应合适
    //其图片链接类似这样：http://upload-images.jianshu.io/upload_images/676871-3d1e0a32603ed9fb.jpg?imageMogr2/auto-orient/strip|imageView2/1/w/300/h/300
    //最后两个参数可以自己改，返回不同尺寸的图片（棒棒哒）
    //所以在根据URL获取图片那一刻替换下就好了
    [self.manager GET:@"users/2e18e6a834e6/latest_articles"
           parameters:nil
              success:^ void(NSURLSessionDataTask * task, id responseObject) {
                  //NSString *HTMLString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                  //NSLog(@"有数据返回！%@", HTMLString);
                  [self parseHTML:responseObject
                   xPathQueryString:@"/html/body/div[4]/div[2]/div/div/ul/li"
                      storedArray:self.headerArticles];
                  //NSLog(@"已将%lu个对象放入headerArticles。", (unsigned long)[self.headerArticles count]);
                  
                  //同步UI得紧跟着模型完成之后，不然模型在后台进行，UI代码早已经开始跑了
                  [self setUpArticleHeaderView];

              }
              failure:^void(NSURLSessionDataTask * task, NSError * error) {
                  NSLog(@"顶部文章请求失败。Error:%@", error);
              }];
    
}

- (void)setUpArticleHeaderView
{
    CGFloat frameWidth = self.view.frame.size.width;
    CGRect frame = CGRectMake(0, 0, frameWidth, frameWidth / 2);
    
    
    //原库传入的数组存储的是字符串，改了下，现在存放的是UIImageView
    NSMutableArray *imagesArray = [NSMutableArray array];
    
    /*
     for (int i = 0; i < 3 ; i++) {
     UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"0%d.jpg",i + 1]];
     [imagesArray addObject:image];
     }
     */
    
    /*
     for (int i = 0; i < 3; i++) {
     UIImageView *imageView = [UIImageView new];
     //imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"0%d.jpg",i + 1]];
     
     }
     */
    //NSLog(@"顶部图片数：%lu", (unsigned long)[self.headerArticles count]);
    for (int i = 0; i < [self.headerArticles count]; i++) {
        NSString *imageURLString = [[[self.headerArticles objectAtIndex:i] imageURLString] stringByReplacingOccurrencesOfString:@"w/300/h/300" withString:@"w/720/h/360"];
        //NSURL *imageURL = [NSURL URLWithString:[[self.headerArticles objectAtIndex:i] imageURLString]];
        NSURL *imageURL = [NSURL URLWithString:imageURLString];

        UIImageView *imageView = [UIImageView new];
        [imageView sd_setImageWithURL:imageURL];
        [imagesArray addObject:imageView];
        [self.tableView reloadData];
    }
    
    
    /*
     //把字符串数组改为UIImage数组，应该也行
     for (int i = 0; i < [self.headerArticles count]; i++) {
     NSLog(@"图片获取成功！");
     
     NSURL *imageURL = [NSURL URLWithString:[[self.headerArticles objectAtIndex:i] imageURLString]];
     NSLog(@"%@", imageURL);
     //异步获取图片，以免阻塞UI，获取成功后再回到主线程更新
     //  dispatch_async(队列, ^{ 执行内容 });
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     NSData *imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
     NSLog(@"图片获取成功！");
     UIImage *image = [[UIImage alloc] initWithData:imageData];
     if (image) {
     dispatch_async(dispatch_get_main_queue(), ^{
     NSLog(@"图片获取成功！");
     [imagesArray addObject:image];
     });
     }
     });
     
     }
     */
    
    ZLImageViewDisplayView *headerView = [ZLImageViewDisplayView zlImageViewDisplayViewWithFrame:frame
                                                                                      WithImages:imagesArray];
    //轮播时间
    headerView.scrollInterval = 3;
    //动画过渡时间
    headerView.animationInterVale = 0.5;
    
    //设置为tableView的headerView
    self.tableView.tableHeaderView = headerView;
    
    
    /*
     __weak typeof(self) weakself;

    [headerView addTapEventForImageWithBlock:^(NSInteger imageIndex) {
        //NSString *str = [NSString stringWithFormat:@"第%ld张图片", imageIndex];
        
        //NSString *titleString = [weakself.headerArticles[imageIndex - 1] title];
        NSLog(@"%@", weakself.headerArticles);  //输出Null是为毛？！！
        //NSString *string = [NSString stringWithFormat:@"标题：%@", titleString];
        //UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //[alter show];
    }];
     */
     

}



#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //在有数据前该打印输出了两次0，所以猜想该方法并不一定在init之后，可能在[super init]、[viewDidLoad]等多处被异步调用
    //NSLog(@"表格行数：%lu", (unsigned long)[self.articles count]);
    return [self.articles count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //为传进来的tableView以XEJArticleCell为标记从cell池中复用cell（没有的话自动新建）
    XEJArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XEJArticleCell"
                                                           forIndexPath:indexPath];
    
    XEJArticle *article = self.articles[indexPath.row];
    
    //图片
    //[cell.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:article.imageURLString]];
    [cell.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:article.imageURLString]
                               placeholderImage:[UIImage imageNamed:@"image_list.png"]];
    //cell.thumbnailImageView.image = [UIImage imageNamed:@"login_icon_douban.png"];
    
    //其他文字信息
    cell.authorLabel.text = article.author;
    cell.timeLabel.text = article.time;
    cell.titleLabel.text = article.title;
    cell.readNumLabel.text = article.readNum;
    cell.commentsNumLabel.text = article.commentsNum;
    cell.likeNumLabel.text = article.likeNum;
    
    //NSLog(@"测试下顶部是否有图片：%lu", (unsigned long)[self.headerArticles count]);
    
    return cell;

}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", [self.articles[indexPath.row] title]);
    [self.manager GET:[self.articles[indexPath.row] articleURLString]
           parameters:nil
              success:^(NSURLSessionDataTask * task, id responseObject) {
                  NSString *HTMLString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                  //NSLog(@"文章内容请求成功!%@", HTMLString);
                  
                  //对获取的网页进行正则提取，并处理成最终显示页面
                  NSString *contentString = [self parseArticleContent:HTMLString];
                  if (contentString) {
                      //NSLog(@"%@", contentString);
                      XEJArticleWebViewController *articleWebVC = [[XEJArticleWebViewController alloc] initWithHTMLString:contentString];
                      UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:articleWebVC];
                      [self presentViewController:nvc
                                         animated:YES
                                       completion:nil];
                  }
                  
                  
              } failure:^(NSURLSessionDataTask * task, NSError * error) {
                  NSLog(@"文章内容请求失败。Error：%@", error);

              }];

}

@end
