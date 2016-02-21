//
//  MDSPullUpToMore.m
//  MDSPullUpToMore
//
//  Created by 杨淳引 on 16/2/3.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#pragma mark - MDSPullUpToMore

#import "MDSPullUpToMore.h"
#import "MDSPullAnimationView.h"
#import <QuartzCore/QuartzCore.h>

enum {
    MDSPullUpToMoreStateHidden = 1,
    MDSPullUpToMoreStateLoading,
    MDSPullUpToMoreStateNoMore
};

typedef NSUInteger MDSPullUpToMoreState;

@interface MDSPullUpToMore ()

@property (nonatomic, copy) void (^actionHandler)(void); //加载的操作块
@property (nonatomic, copy) NSString *noRecordTip; //无更多记录时的提示语
@property (nonatomic, strong) MDSPullAnimationView *pullAnimationView; //动画图
@property (nonatomic, strong) UILabel *titleLabel; //说明文字
@property (nonatomic, strong) UIScrollView *scrollView; //MDSPullUpToMore所关联的UIScrollView
@property (nonatomic, readwrite) MDSPullUpToMoreState state; //当前状态
@property (nonatomic, readwrite) UIEdgeInsets originalScrollViewContentInset; //触发操作前的ContentInset

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset;

@end

@implementation MDSPullUpToMore

@synthesize actionHandler, textColor, state, titleLabel, pullAnimationView, originalScrollViewContentInset, noRecordTip;
@synthesize scrollView = _scrollView;

#pragma mark - Initialization

- (id)initWithScrollView:(UIScrollView *)scrollView {
    self = [super initWithFrame:CGRectZero];
    self.scrollView = scrollView;
    [_scrollView addSubview:self];
    
    if (_scrollView.contentSize.height < _scrollView.frame.size.height) {
        self.hidden = YES;//内容不满屏则不显示
    }
    
    self.pullAnimationView=[self configPullAnimationView]; //动图
    self.textColor = kAppTextCoclor;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 20, 150, 20)];
    titleLabel.text = NSLocalizedString(@"...",);
    titleLabel.font = [UIFont boldSystemFontOfSize:14];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = textColor;
    [self addSubview:titleLabel];
    
    _canMore=YES;
    self.originalScrollViewContentInset = scrollView.contentInset;
    self.state = MDSPullUpToMoreStateHidden;
    
    CGFloat y = self.scrollView.contentSize.height;
    if ([self.scrollView isKindOfClass:[UITableView class]]) {
        [(UITableView *)self.scrollView reloadData];
        y = self.scrollView.contentSize.height;
    }
    self.frame = CGRectMake(0, y, scrollView.bounds.size.width, 60);
    
    return self;
}

- (id)initWithScrollView:(UIScrollView *)scrollView noRecordTip:(NSString *)tip {
    self = [self initWithScrollView:scrollView];
    self.noRecordTip = tip;
    return self;
}

#pragma mark - Public

- (void)triggerMore {
    self.state = MDSPullUpToMoreStateLoading;
}

- (void)stopAnimation {
    self.state = MDSPullUpToMoreStateHidden;
}

- (void)scrollViewDidScroll:(CGPoint)contentOffset {
    [self setSelfFrame];
    CGFloat tmpfl = self.scrollView.contentSize.height - contentOffset.y - self.scrollView.frame.size.height;
    if (tmpfl <= -60) {
        if (self.canMore) {
            self.state = MDSPullUpToMoreStateLoading;
        } else {
            self.state = MDSPullUpToMoreStateNoMore;
        }
        return;
    }
}

#pragma mark - Private

- (MDSPullAnimationView *)configPullAnimationView {
    if(!pullAnimationView) {
        pullAnimationView = [[MDSPullAnimationView alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x - 30, 20, 20, 20)];
        pullAnimationView.hidesWhenStopped = YES;
        [self addSubview:pullAnimationView];
    }
    return pullAnimationView;
}

- (void)setSelfFrame {
    CGFloat y = self.scrollView.contentSize.height;
    self.frame = CGRectMake(0, y, self.scrollView.bounds.size.width, 60);
}

#pragma mark - Setter

- (void)setCanMore:(BOOL)canMore {
    _canMore = canMore;
    if (!_canMore) {
        self.state = MDSPullUpToMoreStateNoMore;
    }
}

- (void)setTextColor:(UIColor *)newTextColor {
    textColor = newTextColor;
    titleLabel.textColor = newTextColor;
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset {
    if (!self.scrollView) return;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.scrollView.contentInset = contentInset;
    } completion:^(BOOL finished) {}];
    
    return;
}

- (void)setState:(MDSPullUpToMoreState)newState {
    [self setSelfFrame];
    
    self.hidden = NO;
    if (self.scrollView.contentSize.height < self.scrollView.frame.size.height) {
//        MDSLog(@"self.scrollView.contentSize.height = %f, self.scrollView.frame.size.height = %f", self.scrollView.contentSize.height, self.scrollView.frame.size.height);
        self.hidden = YES;
        return;
    }
    if (self.state == newState) {
        return;
    }
    state = newState;
    switch (newState) {
        case MDSPullUpToMoreStateHidden:
            titleLabel.text = NSLocalizedString(@"上拉加载更多笔记...       ",);
            [self.pullAnimationView stopAnimation];
            [self setScrollViewContentInset:self.originalScrollViewContentInset];
            break;
            
        case MDSPullUpToMoreStateNoMore:
            if (self.noRecordTip == nil) {
                titleLabel.text = NSLocalizedString(@"无更多笔记        ",);
            } else {
                titleLabel.text = NSLocalizedString(self.noRecordTip,);
            }
            [self.pullAnimationView stopAnimation];
            [self setScrollViewContentInset:self.originalScrollViewContentInset];
            break;
            
        case MDSPullUpToMoreStateLoading:
            titleLabel.text = NSLocalizedString(@"正在载入更多笔记...",);
            [self.pullAnimationView startAnimation];
            
            UIEdgeInsets edgeinset = self.scrollView.contentInset;
            edgeinset.bottom = edgeinset.bottom + 60;
            [self setScrollViewContentInset:edgeinset];
            
            if(self.actionHandler)
                actionHandler();
            break;
    }
    
    CGRect titleFrame = self.titleLabel.frame;
    [self.titleLabel sizeToFit];
    titleFrame.origin.x = (self.bounds.size.width - self.titleLabel.bounds.size.width)/2 + 15;
    self.titleLabel.frame = titleFrame;
    
    CGRect animationViewFrame = self.pullAnimationView.frame;
    animationViewFrame.origin.x = titleFrame.origin.x - 30;
    self.pullAnimationView.frame = animationViewFrame;
}

@end


#pragma mark - UIScrollView (MDSPullUpToMore)

#import <objc/runtime.h>

static char UIScrollViewPullUpToMoreView;
@implementation UIScrollView (MDSPullUpToMore)

@dynamic pullUpToMoreView;

#pragma mark - Public

- (void)addPullUpToMoreWithNoRecordTip:(NSString *)tip andActionHandler:(void (^)(void))actionHandler{
    MDSPullUpToMore *pullUpToMoreView = [[MDSPullUpToMore alloc] initWithScrollView:self noRecordTip:tip];
    pullUpToMoreView.actionHandler = actionHandler;
    self.pullUpToMoreView = pullUpToMoreView;
}

- (void)addPullUpToMoreWithActionHandler:(void (^)(void))actionHandler{
    MDSPullUpToMore *pullUpToMoreView = [[MDSPullUpToMore alloc] initWithScrollView:self];
    pullUpToMoreView.actionHandler = actionHandler;
    self.pullUpToMoreView = pullUpToMoreView;
}

- (void)stopAnimation {
    if (self.pullUpToMoreView) {
        [self.pullUpToMoreView stopAnimation];
    }
}

- (void)didScroll {
    CGPoint point = self.contentOffset;
    if (self.pullUpToMoreView) {
        [self.pullUpToMoreView scrollViewDidScroll:point];
    }
}

#pragma mark - Runtime

- (void)setPullUpToMoreView:(MDSPullUpToMore *)pullUpToMoreView {
    [self willChangeValueForKey:@"pullUpToMoreView"];
    objc_setAssociatedObject(self, &UIScrollViewPullUpToMoreView,
                             pullUpToMoreView,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"pullUpToMoreView"];
}

- (MDSPullUpToMore *)pullUpToMoreView {
    return objc_getAssociatedObject(self, &UIScrollViewPullUpToMoreView);
}

@end

