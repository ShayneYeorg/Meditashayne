//
//  MDSResponse.h
//  Meditashayne
//
//  Created by 杨淳引 on 16/2/21.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDSResponse : NSObject

@property (nonatomic, strong) NSString *desc; //查询结果描述
@property (nonatomic, strong) NSString *code; //查询结果代码
@property (nonatomic, strong) NSDictionary *responseDic; //查询结果

@end
