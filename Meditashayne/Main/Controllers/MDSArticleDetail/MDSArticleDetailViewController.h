//
//  MDSArticleDetailViewController.h
//  Meditashayne
//
//  Created by 杨淳引 on 16/2/3.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDSCoreDataAccess.h"

@interface MDSArticleDetailViewController : UIViewController

@property (strong, nonatomic) Article *alteringArticle;//正在修改的文章，编辑状态下才有值

@end
