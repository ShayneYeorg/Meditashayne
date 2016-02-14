//
//  MDSAritcleCell.m
//  meditashayne
//
//  Created by 杨淳引 on 16/2/14.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "MDSAritcleCell.h"
#import "Article+CoreDataProperties.h"

@interface MDSAritcleCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation MDSAritcleCell

#pragma mark - Public

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MDSAritcleCell";
    MDSAritcleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
    }
    
    return cell;
}

#pragma mark - Setter

- (void)setArticle:(Article *)article {
    _article = article;
    
    self.titleLabel.text = article.title;
    self.contentLabel.text = [[NSString alloc]initWithData:article.content encoding:NSUTF8StringEncoding];
}

@end
