//
//  MDSArticleListViewController.m
//  Meditashayne
//
//  Created by 杨淳引 on 16/2/3.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#define kPageLimit 20

#import "MDSArticleListViewController.h"
#import "MDSArticleDetailViewController.h"
#import "MDSAritcleCell.h"
#import "MDSSearchView.h"
#import "MDSPullUpToMore.h"

@interface MDSArticleListViewController () <UITableViewDelegate, UITableViewDataSource, MDSSearchViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *articles;
@property (nonatomic, strong) MDSSearchView *searchView;
@property (nonatomic, assign) CGFloat searchViewInitialY;//searchView.frame初始的y值
@property (nonatomic, assign) CGFloat searchViewLastY;//searchView.frame上次静止时的y值

@end

@implementation MDSArticleListViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configViewDetails];
    [self configCreateBarBtn];
    [self configTableView];
    [self fetchArticles];
    
    [self addNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    //xib的尺寸和实际屏幕尺寸可能会有区别，在这里才加载可避免控件尺寸受xib影响
    [self configSearchView];
}

- (void)dealloc {
    [self removeNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Confiruration

- (void)configViewDetails {
    self.title = @"Meditashayne";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)configCreateBarBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 44, 44)];
    [btn setTitleColor:RGB(50, 50, 50) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [btn addTarget:self action:@selector(createArticle) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"新建" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)configTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Height - 64)];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    __weak MDSArticleListViewController *weakSelf = self;
    [self.tableView addPullUpToMoreWithActionHandler:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf fetchArticles];
        });
    }];
}

- (void)configSearchView {
    self.searchViewInitialY = self.view.frame.size.height - 40;
    self.searchViewLastY = self.searchViewInitialY;
    self.searchView = [MDSSearchView loadFromNibWithFrame:CGRectMake(0, self.searchViewInitialY, kScreen_Width, 800)];
    self.searchView.delegate = self;
    [self.view addSubview:self.searchView];
}

#pragma mark - Private

- (void)createArticle {
    MDSArticleDetailViewController *articleDetailViewController = [MDSArticleDetailViewController new];
    [self.navigationController pushViewController:articleDetailViewController animated:YES];
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:ARTICLE_CREATE_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCell:) name:ARTICLE_ALTER_NOTIFICATION object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ARTICLE_CREATE_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ARTICLE_ALTER_NOTIFICATION object:nil];
}

- (void)refreshTableView {
    [self.articles removeAllObjects];
    [self fetchArticles];
}

- (void)refreshCell:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    Article *alteredArticle = [MDSCoreDataAccess fetchArticlesWithObjectID:userInfo[@"objectID"]];
    NSIndexPath *alteredCellIndexPath = userInfo[@"indexPath"];
    self.articles[alteredCellIndexPath.row] = alteredArticle;
    [self.tableView reloadRowsAtIndexPaths:@[alteredCellIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Getter

- (NSMutableArray *)articles {
    if (_articles == nil) {
        _articles = [NSMutableArray array];
    }
    return _articles;
}

#pragma mark - MDSSearchViewDelegate

- (void)searchViewDidClicksSearchBtn:(MDSSearchView *)searchView {
    
}

- (void)searchView:(MDSSearchView *)searchView didDragging:(CGFloat)dragDistance {
    CGRect searchViewFrame = self.searchView.frame;
    searchViewFrame.origin.y = self.searchViewLastY + dragDistance;
    self.searchView.frame = searchViewFrame;
}

- (void)searchViewDidEndDragging:(MDSSearchView *)searchView {
    if (self.searchView.frame.origin.y > self.searchViewInitialY - 91) {
        //searchView显示不足91个像素时，恢复隐藏状态（searchView高度为105）
        [UIView animateWithDuration:0.2 animations:^{
            CGRect searchViewFrame = self.searchView.frame;
            searchViewFrame.origin.y = self.searchViewInitialY;
            self.searchView.frame = searchViewFrame;
            
        } completion:^(BOOL finished) {
            self.searchViewLastY = self.searchView.frame.origin.y;
        }];
        
    } else {
        //searchView显示大于等于91个像素时，切换成显示状态
        [UIView animateWithDuration:0.3 animations:^{
            CGRect searchViewFrame = self.searchView.frame;
            searchViewFrame.origin.y = self.searchViewInitialY - 105;
            self.searchView.frame = searchViewFrame;
            
        } completion:^(BOOL finished) {
            self.searchViewLastY = self.searchView.frame.origin.y;
        }];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDSAritcleCell *cell = (MDSAritcleCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MDSArticleDetailViewController *detailVC = [MDSArticleDetailViewController new];
    detailVC.alteringArticle = self.articles[indexPath.row];
    detailVC.alteringArticleIndexPath = indexPath;
    [self.navigationController pushViewController:detailVC animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDSAritcleCell *cell = [MDSAritcleCell cellWithTableView:tableView];
    cell.article = self.articles[indexPath.row];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        [scrollView didScroll];
    }
}

#pragma mark - Core Data

- (void)fetchArticles {
    NSArray *articlesOfOnePage = [MDSCoreDataAccess fetchArticlesWithOffset:self.articles.count limit:kPageLimit];
    [self.articles addObjectsFromArray:articlesOfOnePage];
    [self.tableView reloadData];
    
    if (articlesOfOnePage.count < kPageLimit) {
        self.tableView.pullUpToMoreView.canMore = NO;
        
    } else {
        [self.tableView.pullUpToMoreView stopAnimation];
    }
}

@end
