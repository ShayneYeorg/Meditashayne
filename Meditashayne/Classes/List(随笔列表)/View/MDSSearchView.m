//
//  MDSSearchView.m
//  Meditashayne
//
//  Created by 杨淳引 on 16/2/3.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "MDSSearchView.h"

@interface MDSSearchView ()

@property (weak, nonatomic) IBOutlet UIView *viewHandler; //拖拽点
@property (weak, nonatomic) IBOutlet UIView *searchFieldBGView; //搜索框背景
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UISegmentedControl *searchType;

@end

@implementation MDSSearchView

#pragma mark - Public

+ (instancetype)loadFromNibWithFrame:(CGRect)frame {
    MDSSearchView *view = [[NSBundle mainBundle] loadNibNamed:@"MDSSearchView" owner:nil options:nil][0];
    [view setFrame:frame];
    [view configViewDetails];
    
    return view;
}

#pragma mark - Private

- (void)configViewDetails {
    CALayer *layer=[self.searchFieldBGView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:4];
    [layer setBorderWidth:0.5];
    [layer setBorderColor:[RGB(50, 50, 50) CGColor]];
    
    self.isDragging = NO;
    
    UIImageView *searchImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search_icon"]];
    [searchImage setFrame:self.viewHandler.bounds];
    [self.viewHandler addSubview:searchImage];
}

//跳过当前view由subview接收事件
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    BOOL value = (CGRectContainsPoint(frame, point));
    
    NSArray *views = [self subviews];
    for (UIView *subview in views) {
        value = (CGRectContainsPoint(subview.frame, point));
        if (value) {
            return value;
        }
    }
    
    return NO;
}

#pragma mark - Getter

- (QueryType)queryType {
    _queryType = Query_Type_Content;
    if (self.searchType.selectedSegmentIndex == 0) {
        _queryType = Query_Type_Title;
    }
    return _queryType;
}

#pragma mark - Action

- (IBAction)panGestureAction:(id)sender {
    UIPanGestureRecognizer *gesture = (UIPanGestureRecognizer *)sender;
    CGPoint point = [gesture translationInView:self];
    if (gesture.state == UIGestureRecognizerStateChanged) {
        if (point.y != 0) {
            if ([self.delegate respondsToSelector:@selector(searchView:didDragging:)]) {
                self.isDragging = YES;
                [self.delegate searchView:self didDragging:point.y];
            }
        }
        
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(searchViewDidEndDragging:)]) {
            self.isDragging = NO;
            [self.delegate searchViewDidEndDragging:self];
        }
    }
}

- (IBAction)searchBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(searchViewDidClickSearchBtn:)]) {
        [self.delegate searchViewDidClickSearchBtn:self];
    }
}

@end
