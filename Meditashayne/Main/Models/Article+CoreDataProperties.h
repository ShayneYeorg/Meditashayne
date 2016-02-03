//
//  Article+CoreDataProperties.h
//  Meditashayne
//
//  Created by 杨淳引 on 16/2/3.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Article.h"

NS_ASSUME_NONNULL_BEGIN

@interface Article (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *content;
@property (nullable, nonatomic, retain) NSDate *createTime;
@property (nullable, nonatomic, retain) NSString *title;

@end

NS_ASSUME_NONNULL_END
