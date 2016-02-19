//
//  MDSSearchView.m
//  Meditashayne
//
//  Created by 杨淳引 on 16/2/3.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "MDSSearchView.h"

@interface MDSSearchView ()

@property (weak, nonatomic) IBOutlet UIView *viewHandler;//拖拽点
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

#pragma mark - Action

- (IBAction)panGestureAction:(id)sender {
    UIPanGestureRecognizer *gesture = (UIPanGestureRecognizer *)sender;
    CGPoint point = [gesture translationInView:self];
    if (point.y != 0) {
        if ([self.delegate respondsToSelector:@selector(searchView:didDragging:)]) {
            [self.delegate searchView:self didDragging:point.y];
        }
    }
}

- (IBAction)searchBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(searchViewDidClicksSearchBtn:)]) {
        [self.delegate searchViewDidClicksSearchBtn:self];
    }
}

@end
