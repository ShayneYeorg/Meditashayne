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

@property (nonatomic, strong) Article *alteringArticle;//正在修改的文章，编辑状态下才有值
@property (nonatomic, strong) NSIndexPath *alteringArticleIndexPath;//正在修改的文章的indexPath，编辑状态下才有值

@end
