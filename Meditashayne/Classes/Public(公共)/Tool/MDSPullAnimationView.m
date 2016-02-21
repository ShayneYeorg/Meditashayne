//
//  MDSPullAnimationView.m
//  MDSPullUpToMore
//
//  Created by 杨淳引 on 16/2/3.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#define kAnimationViewWidth  20

#import "MDSPullAnimationView.h"

@interface MDSPullAnimationView ()

@property (strong, nonatomic) UIView *progressView1;
@property (strong, nonatomic) UIView *progressView2;
@property (strong, nonatomic) UIView *progressView3;
@property (assign, nonatomic) BOOL isStop;

@end

@implementation MDSPullAnimationView

#pragma mark - Public

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, kAnimationViewWidth, kAnimationViewWidth)];
    if (self) {
        [self congfigAnimationView];
    }
    return self;
}

- (void)startAnimation {
    self.hidden = NO;
    self.isStop = NO;
    
    CGRect viewFrame1 = self.progressView1.frame;
    viewFrame1.size.width = 0;
    self.progressView1.frame = viewFrame1;
    CGRect viewFrame2 = self.progressView2.frame;
    viewFrame2.size.width = 0;
    self.progressView2.frame = viewFrame2;
    CGRect viewFrame3 = self.progressView3.frame;
    viewFrame3.size.width = 0;
    self.progressView3.frame = viewFrame3;
    
    __weak MDSPullAnimationView *weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect viewFrame1 = weakSelf.progressView1.frame;
        viewFrame1.size.width = kAnimationViewWidth*0.6;
        weakSelf.progressView1.frame = viewFrame1;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect viewFrame2 = weakSelf.progressView2.frame;
            viewFrame2.size.width = kAnimationViewWidth*0.6;
            weakSelf.progressView2.frame = viewFrame2;
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                CGRect viewFrame3 = weakSelf.progressView3.frame;
                viewFrame3.size.width = kAnimationViewWidth*0.6;
                weakSelf.progressView3.frame = viewFrame3;
                
            } completion:^(BOOL finished) {
                if (weakSelf.isStop) return;
                [weakSelf startAnimation];
            }];
        }];
    }];
}

-(void)stopAnimation {
    self.isStop = YES;
    if (self.hidesWhenStopped) {
        self.hidden = YES;
    }
}

#pragma mark - UIConfiguration

- (void)congfigAnimationView {
    self.backgroundColor = [UIColor clearColor];
    [self configCircle];
    [self configProgressView];
}

- (void)configCircle {
    UIView *circle1 = [[UIView alloc]initWithFrame:CGRectMake(kAnimationViewWidth*0.075, kAnimationViewWidth*0.125, kAnimationViewWidth*0.15, kAnimationViewWidth*0.15)];
    circle1.backgroundColor = kAppTextCoclor;
    [circle1.layer setCornerRadius:circle1.frame.size.width*0.5];
    [self addSubview:circle1];
    
    UIView *circle2 = [[UIView alloc]initWithFrame:CGRectMake(kAnimationViewWidth*0.075, kAnimationViewWidth*0.425, kAnimationViewWidth*0.15, kAnimationViewWidth*0.15)];
    circle2.backgroundColor = kAppTextCoclor;
    [circle2.layer setCornerRadius:circle1.frame.size.width*0.5];
    [self addSubview:circle2];
    
    UIView *circle3 = [[UIView alloc]initWithFrame:CGRectMake(kAnimationViewWidth*0.075, kAnimationViewWidth*0.725, kAnimationViewWidth*0.15, kAnimationViewWidth*0.15)];
    circle3.backgroundColor = kAppTextCoclor;
    [circle3.layer setCornerRadius:circle1.frame.size.width*0.5];
    [self addSubview:circle3];
}

- (void)configProgressView {
    self.progressView1 = [[UIView alloc]initWithFrame:CGRectMake(kAnimationViewWidth*0.3, kAnimationViewWidth*0.15, 0, kAnimationViewWidth*0.1)];
    self.progressView1.backgroundColor = kAppTextCoclor;
    [self addSubview:self.progressView1];
    
    self.progressView2 = [[UIView alloc]initWithFrame:CGRectMake(kAnimationViewWidth*0.3, kAnimationViewWidth*0.45, 0, kAnimationViewWidth*0.1)];
    self.progressView2.backgroundColor = kAppTextCoclor;
    [self addSubview:self.progressView2];
    
    self.progressView3 = [[UIView alloc]initWithFrame:CGRectMake(kAnimationViewWidth*0.3, kAnimationViewWidth*0.75, 0, kAnimationViewWidth*0.1)];
    self.progressView3.backgroundColor = kAppTextCoclor;
    [self addSubview:self.progressView3];
}

@end
