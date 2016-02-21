//
//  MDSCoreDataAccess.m
//  meditashayne
//
//  Created by 杨淳引 on 16/2/13.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "MDSCoreDataAccess.h"

@implementation MDSCoreDataAccess

//查询所有数据
+ (NSMutableArray *)fetchArticlesWithOffset:(NSInteger)offset limit:(NSInteger)limit {
    //request和entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Article" inManagedObjectContext:kManagedObjectContext];
    [request setEntity:entity];
    
    //设置排序规则
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:NO];
    NSArray * sortDescriptors = @[sort];
    [request setSortDescriptors:sortDescriptors];
    
    //设置分页规则
    [request setFetchLimit:limit];
    [request setFetchOffset:offset];
    
    //查询
    NSError *error = nil;
    NSMutableArray *articles = [[kManagedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (articles == nil) MDSLog(@"查询所有数据时发生错误:%@,%@",error,[error userInfo]);
    return articles;
}

+ (void)fetchArticlesWithOffset:(NSInteger)offset limit:(NSInteger)limit callBack:(void(^)(MDSResponse *response))callBack {
    
}

//根据objectID取出某条随笔
+ (Article *)fetchArticlesWithObjectID:(NSManagedObjectID *)objectID {
    Article *article = [kManagedObjectContext objectWithID:objectID];
    return article;
}

//根据参数查询数据
+ (NSMutableArray *)queryArticlesAccordingTo:(NSString *)searchStr {
    //request和entity
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Article" inManagedObjectContext:kManagedObjectContext];
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
    NSMutableArray *articles = [[kManagedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (articles == nil) MDSLog(@"根据条件查询时发生错误:%@,%@",error,[error userInfo]);
    return articles;
}

//删除数据
+ (void)removeArticle:(Article *)article {
    [kManagedObjectContext deleteObject:article];
    NSError *error = nil;
    if(![kManagedObjectContext save:&error]) MDSLog(@"删除数据时发生错误:%@,%@",error,[error userInfo]);
}

//新增数据
+ (void)addArticleWithTitle:(NSString *)title content:(NSString *)content {
    Article *article = [NSEntityDescription insertNewObjectForEntityForName:@"Article" inManagedObjectContext:kManagedObjectContext];
    article.title = title;
    article.content = [content dataUsingEncoding:NSUTF8StringEncoding];
    article.createTime = [NSDate date];
    
    NSError *error = nil;
    if ([kManagedObjectContext save:&error]) {
        if (error) MDSLog(@"新增时发生错误:%@,%@",error,[error userInfo]);
    }
}

//修改数据
+ (void)updateArticleWithObjectID:(NSManagedObjectID *)objectID title:(NSString *)title content:(NSString *)content {
    Article *article = [kManagedObjectContext objectWithID:objectID];
    article.title = title;
    article.content = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    if ([kManagedObjectContext save:&error]) MDSLog(@"修改成功");
}

@end
