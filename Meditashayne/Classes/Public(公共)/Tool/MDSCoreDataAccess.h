//
//  MDSCoreDataAccess.h
//  meditashayne
//
//  Created by 杨淳引 on 16/2/13.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDSResponse.h"
#import "Article+CoreDataProperties.h"

@interface MDSCoreDataAccess : NSObject

/**
 *  分页取出所有随笔
 *
 *  @param offset     本页首条数据的下标
 *  @param linmit     本页数据条数
 *  @param callBack   回调
 */
+ (void)fetchArticlesWithOffset:(NSInteger)offset limit:(NSInteger)limit callBack:(void(^)(MDSResponse *response))callBack;

/**
 *  根据objectID取出某条随笔
 *
 *  @param objectID   取出数据的objectID
 */
+ (Article *)fetchArticlesWithObjectID:(NSManagedObjectID *)objectID;

/**
 *  根据条件查询随笔
 *
 *  @param searchStr  查询条件
 */
+ (NSMutableArray *)queryArticlesAccordingTo:(NSString *)searchStr;

/**
 *  删除随笔
 */
+ (void)removeArticle:(Article *)article;

/**
 *  新增随笔
 *
 *  @param title      随笔标题
 *  @param content    随笔内容
 */
+ (void)addArticleWithTitle:(NSString *)title content:(NSString *)content;

/**
 *  更新(修改)随笔
 *
 *  @param objectID   随笔ID
 *  @param title      随笔标题
 *  @param content    随笔内容
 */
+ (void)updateArticleWithObjectID:(NSManagedObjectID *)objectID title:(NSString *)title content:(NSString *)content;

@end
