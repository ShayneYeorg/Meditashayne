//
//  MDSArticleListViewController.m
//  Meditashayne
//
//  Created by 杨淳引 on 16/2/3.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "MDSArticleListViewController.h"
#import "MDSArticleDetailViewController.h"
#import "MDSPullUpToMore.h"

@interface MDSArticleListViewController () <UITableViewDelegate, UITableViewDataSource>

//@property (weak, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *articles;

@end

@implementation MDSArticleListViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configDeatails];
    [self configTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    MDSLog(@"height = %f", self.tableView.contentSize.height);
    
    //要放在viewDidAppear里
    __weak MDSArticleListViewController *weakSelf = self;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.tableView addPullUpToMoreWithActionHandler:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.tableView.pullUpToMoreView stopAnimation];
                [weakSelf.articles addObjectsFromArray:[MDSCoreDataAccess fetchArticlesWithOffset:8 limit:8]];
                [weakSelf.tableView reloadData];
            });
        }];
    });

    MDSLog(@"height = %f", self.tableView.contentSize.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Confiruration

- (void)configDeatails {
    self.title = @"Meditashayne";
    self.view.backgroundColor = [UIColor whiteColor];
//    self.appDelegate = kApp;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 50, 20)];
    [btn addTarget:self action:@selector(createArticle) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"新建" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)configTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.tableFooterView = [UIView new];
//    self.articles = [self fetchArticlesFromDataSource:LoadType_First_Load];
    self.articles = [MDSCoreDataAccess fetchArticlesWithOffset:0 limit:8];
}

#pragma mark - Getter

- (NSMutableArray *)articles {
    if (_articles == nil) {
        _articles = [NSMutableArray array];
    }
    return _articles;
}

#pragma mark - Button Action

- (void)createArticle {
    MDSArticleDetailViewController *articleDetailViewController = [MDSArticleDetailViewController new];
    [self.navigationController pushViewController:articleDetailViewController animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        [scrollView didScroll];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MDSArticleDetailViewController *detailVC = [MDSArticleDetailViewController new];
    detailVC.alteringArticle = self.articles[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ArticleCell"];
    
    Article *article = self.articles[indexPath.row];
    cell.textLabel.text = article.title;
    cell.detailTextLabel.text = [[NSString alloc]initWithData:article.content encoding:NSUTF8StringEncoding];
    
    return cell;
}

#pragma mark - Core Data

@end
