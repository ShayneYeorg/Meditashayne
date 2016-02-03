//
//  MDSArticleListViewController.m
//  Meditashayne
//
//  Created by 杨淳引 on 16/2/3.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "MDSArticleListViewController.h"
#import "MDSArticleDetailViewController.h"

@interface MDSArticleListViewController ()

@property (weak, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *articles;

@end

@implementation MDSArticleListViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"列表";
    self.view.backgroundColor = [UIColor whiteColor];
    self.appDelegate = kApp;
    MDSLog(@"加载成功");
    
    [self configTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - UI Confiruration

- (void)configTableView {
    
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
    NSInteger limit = 5;
    if (loadType == LoadType_Load_More) {
        offset = 5;
        limit = INTMAX_MAX;
    }
    [request setFetchLimit:limit];
    [request setFetchOffset:offset];
    
    //查询
    NSError *error = nil;
    NSMutableArray *articles = [[self.appDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (articles == nil) NSLog(@"查询所有数据时发生错误:%@,%@",error,[error userInfo]);
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
    if (articles == nil) NSLog(@"根据条件查询时发生错误:%@,%@",error,[error userInfo]);
    return articles;
}

@end
