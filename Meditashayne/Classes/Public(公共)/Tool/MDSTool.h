//
//  MDSTool.h
//  Meditashayne
//
//  Created by 杨淳引 on 16/2/3.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _LoadType {
    LoadType_First_Load = 0,
    LoadType_Load_More
} LoadType;

typedef enum _QueryType {
    Query_Type_Title = 0,
    Query_Type_Content,
    Query_Type_None
} QueryType;

@interface MDSTool : NSObject

+ (UIWindow *)getWindow;
+ (void)showShadeViewWithText:(NSString *)text;
+ (void)dismissShadeView;

@end
