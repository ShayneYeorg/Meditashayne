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
#import "SVProgressHUD.h"

@interface MDSArticleListViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MDSSearchViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *articles;
@property (nonatomic, strong) MDSSearchView *searchView;
@property (nonatomic, copy) NSString *searchHandler;//搜索关键字
@property (nonatomic, assign) QueryType queryType;//搜索方法（标题、内容或无）
@property (nonatomic, strong) UIView *searchingBackgroundView; //搜索时的背景
@property (nonatomic, assign) CGFloat searchViewInitialY;//searchView.frame初始的y值
@property (nonatomic, assign) CGFloat searchViewLastY;//searchView.frame上次静止时的y值
@property (nonatomic, strong) NSMutableDictionary *cellHeightDic; //用来存放所有cell的高度

@end

@implementation MDSArticleListViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configViewDetails];
    [self configCreateBarBtn];
    [self configTableView];
    [self configSearchView];
    [self fetchArticlesWithLoadType:LoadType_First_Load];
    
    [self addNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    //在6和6s下尺寸会出现偏差（为什么？）
    if (self.searchView.frame.size.width != kScreen_Width) {
        CGRect searchFrame = self.searchView.frame;
        searchFrame.size.width = kScreen_Width;
        self.searchView.frame = searchFrame;
    }
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
    self.searchHandler = @"";
    self.queryType = Query_Type_None;
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
            [weakSelf fetchArticlesWithLoadType:LoadType_Load_More];
        });
    }];
}

- (void)configSearchView {
    self.searchViewInitialY = kScreen_Height - 50;
    self.searchViewLastY = self.searchViewInitialY;
    self.searchView = [MDSSearchView loadFromNibWithFrame:CGRectMake(0, self.searchViewInitialY, kScreen_Width, 800)];
    self.searchView.delegate = self;
    self.searchView.searchfield.delegate = self;
    [self.view addSubview:self.searchView];
}

#pragma mark - Private

- (void)createArticle {
    if ([self.searchView.searchfield isFirstResponder]) {
        [self.searchView.searchfield resignFirstResponder];
    }
    
    MDSArticleDetailViewController *articleDetailViewController = [MDSArticleDetailViewController new];
    [self.navigationController pushViewController:articleDetailViewController animated:YES];
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:ARTICLE_CREATE_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCell:) name:ARTICLE_ALTER_NOTIFICATION object:nil];
}

- (void)addKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ARTICLE_CREATE_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ARTICLE_ALTER_NOTIFICATION object:nil];
}

- (void)removeKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)refreshTableView {
    [self.cellHeightDic removeAllObjects];
    [self fetchArticlesWithLoadType:LoadType_First_Load];
}

- (void)refreshCell:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    Article *alteredArticle = [MDSCoreDataAccess fetchArticlesWithObjectID:userInfo[@"objectID"]];
    NSIndexPath *alteredCellIndexPath = userInfo[@"indexPath"];
    self.articles[alteredCellIndexPath.row] = alteredArticle;
    
    MDSAritcleCell *cell = (MDSAritcleCell *)[self tableView:self.tableView cellForRowAtIndexPath:alteredCellIndexPath];
    self.cellHeightDic[[NSString stringWithFormat:@"%zd", alteredCellIndexPath.row]] = [NSString stringWithFormat:@"%f", [cell calculateCellHeight]];
    
    [self.tableView reloadRowsAtIndexPaths:@[alteredCellIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    [self moveSearchViewForState:Search_View_State_Input moveDistance:-(keyboardRect.size.height+105)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchingBackgroundViewTap)];
    [self.navigationController.navigationBar addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchingBackgroundViewTap)];
    self.searchingBackgroundView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.searchingBackgroundView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:self.searchingBackgroundView belowSubview:self.searchView];
    [self.searchingBackgroundView addGestureRecognizer:tap2];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self moveSearchViewForState:Search_View_State_Hidden moveDistance:0];
    
    if (self.searchingBackgroundView) {
        [self.searchingBackgroundView removeFromSuperview];
    }
    for (UITapGestureRecognizer *g in self.navigationController.navigationBar.gestureRecognizers) {
        [self.navigationController.navigationBar removeGestureRecognizer:g];
    }
}

//Hidden和Show两种状态可以不指定moveDistance
- (void)moveSearchViewForState:(SearchViewState)state moveDistance:(CGFloat)moveDistance {
    if (self.searchView.isDragging) return;
    
    switch (state) {
        case Search_View_State_Hidden:
            moveDistance = 0;
            [self removeKeyboardNotifications];
            break;
            
        case Search_View_State_Show:
            moveDistance = -105;
            [self addKeyboardNotifications];
            break;
            
        default:
            break;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect searchViewFrame = self.searchView.frame;
        searchViewFrame.origin.y = self.searchViewInitialY + moveDistance;
        self.searchView.frame = searchViewFrame;
        
    } completion:^(BOOL finished) {
        self.searchViewLastY = self.searchView.frame.origin.y;
    }];
}

- (void)searchingBackgroundViewTap {
    MDSLog(@"tap");
    if ([self.searchView.searchfield isFirstResponder]) {
        [self.searchView.searchfield resignFirstResponder];
    }
}

#pragma mark - Getter

- (NSMutableArray *)articles {
    if (_articles == nil) {
        _articles = [NSMutableArray array];
    }
    return _articles;
}

- (NSMutableDictionary *)cellHeightDic {
    if (_cellHeightDic == nil) {
        _cellHeightDic = [NSMutableDictionary dictionary];
    }
    return _cellHeightDic;
}

#pragma mark - MDSSearchViewDelegate

- (void)searchViewDidClickSearchBtn:(MDSSearchView *)searchView {
    if ([self.searchView.searchfield isFirstResponder]) {
        [self.searchView.searchfield resignFirstResponder];
    }
    
    self.searchHandler = self.searchView.searchfield.text;
    if (self.searchHandler.length) {
        self.title = self.searchHandler;
        self.queryType = self.searchView.queryType;
        
    } else {
        self.title = @"Meditashayne";
        self.queryType = Query_Type_None;
    }
    
    [self fetchArticlesWithLoadType:LoadType_First_Load];
}

- (void)searchView:(MDSSearchView *)searchView didDragging:(CGFloat)dragDistance {
    if ([self.searchView.searchfield isFirstResponder]) {
        [self.searchView.searchfield resignFirstResponder];
    }
    
    CGRect searchViewFrame = self.searchView.frame;
    searchViewFrame.origin.y = self.searchViewLastY + dragDistance;
    self.searchView.frame = searchViewFrame;
}

- (void)searchViewDidEndDragging:(MDSSearchView *)searchView {
    if (self.searchView.frame.origin.y > self.searchViewInitialY - 91) {
        //searchView显示不足91个像素时，恢复隐藏状态（searchView高度为105）
        [self moveSearchViewForState:Search_View_State_Hidden moveDistance:0];
        
    } else {
        //searchView显示大于等于91个像素时，切换成显示状态
        [self moveSearchViewForState:Search_View_State_Show moveDistance:0];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.searchView.searchfield isFirstResponder]) {
        [self.searchView.searchfield resignFirstResponder];
    }
    return YES;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.cellHeightDic.allKeys containsObject:[NSString stringWithFormat:@"%zd", indexPath.row]]) {
        return [self.cellHeightDic[[NSString stringWithFormat:@"%zd", indexPath.row]] floatValue];
        
    } else {
        return 150;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
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
    
    if (![self.cellHeightDic.allKeys containsObject:[NSString stringWithFormat:@"%zd", indexPath.row]]) {
        [self.cellHeightDic setValue:[NSString stringWithFormat:@"%f", [cell calculateCellHeight]] forKey:[NSString stringWithFormat:@"%zd", indexPath.row]];
    }
    
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        [scrollView didScroll];
    }
}

#pragma mark - Core Data

- (void)fetchArticlesWithLoadType:(LoadType)loadType {
    if (loadType == LoadType_First_Load) {
        self.tableView.pullUpToMoreView.canMore = YES;
        [self.articles removeAllObjects];
    }
    
    __weak typeof(self) weakSelf = self;
    [MDSCoreDataAccess queryArticlesAccordingTo:self.searchHandler queryType:self.queryType offset:self.articles.count limit:kPageLimit callBack:^(MDSResponse *response) {
        if (response) {
            if ([response.code isEqualToString:RESPONSE_CODE_SUCCEED]) {
                NSArray *articlesOfOnePage = response.responseDic[@"articles"];
                [weakSelf.articles addObjectsFromArray:articlesOfOnePage];
                [weakSelf.tableView reloadData];
                
                if (articlesOfOnePage.count < kPageLimit) {
                    weakSelf.tableView.pullUpToMoreView.canMore = NO;
                    
                } else {
                    [weakSelf.tableView.pullUpToMoreView stopAnimation];
                }
                
            } else {
                [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
                [SVProgressHUD showErrorWithStatus:response.desc];
            }
            
        } else {
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
            [SVProgressHUD showErrorWithStatus:@"读取失败"];
        }
    }];
}

@end









