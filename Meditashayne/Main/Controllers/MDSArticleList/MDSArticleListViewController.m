//
//  MDSArticleListViewController.m
//  Meditashayne
//
//  Created by 杨淳引 on 16/2/3.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "MDSArticleListViewController.h"

@interface MDSArticleListViewController ()

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MDSArticleListViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"列表";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - UI Confiruration

- (void)configTableView {
    
}

@end
