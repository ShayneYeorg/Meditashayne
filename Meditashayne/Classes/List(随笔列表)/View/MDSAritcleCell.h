//
//  MDSAritcleCell.h
//  meditashayne
//
//  Created by 杨淳引 on 16/2/14.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Article;

@interface MDSAritcleCell : UITableViewCell

@property (nonatomic, strong) Article *article;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (CGFloat)calculateCellHeight;

@end
