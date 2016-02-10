//
//  MDSArticleDetailViewController.m
//  Meditashayne
//
//  Created by 杨淳引 on 16/2/3.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "MDSArticleDetailViewController.h"

@interface MDSArticleDetailViewController ()

@property (strong, nonatomic) NSManagedObjectID *objectID;
@property (strong, nonatomic) UITextField *titleFiled;
@property (strong, nonatomic) UITextView *contentField;
@property (weak, nonatomic) AppDelegate *appDelegate;

@end

@implementation MDSArticleDetailViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Configuration

- (void)configDetails {
    self.appDelegate = kApp;
}

#pragma mark - Core Data

//新增数据
- (void)addArticle {
    NSString *title = self.titleFiled.text;
    NSString *content = self.contentField.text;
    
    Article *article = [NSEntityDescription insertNewObjectForEntityForName:@"Article" inManagedObjectContext:self.appDelegate.managedObjectContext];
    
    article.title = title;
    article.content = [content dataUsingEncoding:NSUTF8StringEncoding];
    article.createTime = [NSDate date];
    
    NSError *error = nil;
    if ([self.appDelegate.managedObjectContext save:&error]) {
        if (error) MDSLog(@"新增时发生错误:%@,%@",error,[error userInfo]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

//修改数据
- (void)alterArticle {
    Article *article = [self.appDelegate.managedObjectContext objectWithID:self.objectID];
    article.title = self.titleFiled.text;
    article.content = [self.contentField.text dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    if ([self.appDelegate.managedObjectContext save:&error]) MDSLog(@"修改成功");
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
