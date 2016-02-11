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

@property (weak, nonatomic) AppDelegate *appDelegate;
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
    //要放在viewDidAppear里
    __weak MDSArticleListViewController *weakSelf = self;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.tableView addPullUpToMoreWithActionHandler:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.tableView.pullUpToMoreView stopAnimation];
            });
        }];
    });
    
    self.articles = [self fetchArticlesFromDataSource:LoadType_First_Load];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Confiruration

- (void)configDeatails {
    self.title = @"Meditashayne";
    self.view.backgroundColor = [UIColor whiteColor];
    self.appDelegate = kApp;
    
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

//查询所有数据
- (NSMutableArray *)fetchArticlesFromDataSource:(LoadType)loadType {
    //request和entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Article" inManagedObjectContext:self.appDelegate.managedObjectContext];
    [request setEntity:entity];
    
    //设置排序规则
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:NO];
    NSArray * sortDescriptors = @[sort];
    [request setSortDescriptors:sortDescriptors];
    
    //设置分页规则
    NSInteger offset = 0;
    NSInteger limit = 8;
    if (loadType == LoadType_Load_More) {
        offset = 8;
        limit = 50;
    }
    [request setFetchLimit:limit];
    [request setFetchOffset:offset];
    
    //查询
    NSError *error = nil;
    NSMutableArray *articles = [[self.appDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (articles == nil) MDSLog(@"查询所有数据时发生错误:%@,%@",error,[error userInfo]);
    return articles;
}

//根据参数查询数据
- (NSMutableArray *)retrieveArticlesFromDataSource:(NSString *)searchStr {
    //request和entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Article" inManagedObjectContext:self.appDelegate.managedObjectContext];
    [request setEntity:entity];
    
    //设置排序规则
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:NO];
    NSArray *sortDescriptors = @[sort];
    [request setSortDescriptors:sortDescriptors];
    
    //设置查询条件
    NSString *str = [NSString stringWithFormat:@"title LIKE '*%@*'", searchStr];
    NSPredicate *pre = [NSPredicate predicateWithFormat:str];
    [request setPredicate:pre];
    
    //查询
    NSError *error = nil;
    NSMutableArray *articles = [[self.appDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (articles == nil) MDSLog(@"根据条件查询时发生错误:%@,%@",error,[error userInfo]);
    return articles;
}

//删除数据
- (void)removeArticleFromDataSource:(Article *)article {
    [self.appDelegate.managedObjectContext deleteObject:article];
    NSError *error = nil;
    if(![self.appDelegate.managedObjectContext save:&error]) MDSLog(@"删除数据时发生错误:%@,%@",error,[error userInfo]);
}

@end
