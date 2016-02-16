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
//@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seperatorLineHeight;


@end

@implementation MDSAritcleCell

#pragma mark - Public

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MDSAritcleCell";
    MDSAritcleCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:ID owner:nil options:nil] lastObject];
        cell.seperatorLineHeight.constant = 0.5;
    }
    return cell;
}

//+ (CGFloat)cellHeightWithArticleModel:(Article *)article {
//    return 100;
//}

#pragma mark - Setter

- (void)setArticle:(Article *)article {
    _article = article;
    
    self.titleLabel.text = article.title;
    self.contentLabel.text = [[NSString alloc]initWithData:article.content encoding:NSUTF8StringEncoding];
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    self.cellHeight = size.height + 1;
}

@end
