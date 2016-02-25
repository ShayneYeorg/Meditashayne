//
//  MDSShadeViewAnimationView.m
//  Meditashayne
//
//  Created by 杨淳引 on 16/2/25.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "MDSShadeViewAnimationView.h"

@interface MDSShadeViewAnimationView ()

@property (strong, nonatomic) UIView *progressView1;
@property (strong, nonatomic) UIView *progressView2;
@property (strong, nonatomic) UIView *progressView3;
@property (assign, nonatomic) CGFloat animationViewWidth;
@property (assign, nonatomic) BOOL isStop;

@end

@implementation MDSShadeViewAnimationView

#pragma mark - Public

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.animationViewWidth = frame.size.width;
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
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect viewFrame1 = weakSelf.progressView1.frame;
        viewFrame1.size.width = self.animationViewWidth*0.6;
        weakSelf.progressView1.frame = viewFrame1;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect viewFrame2 = weakSelf.progressView2.frame;
            viewFrame2.size.width = self.animationViewWidth*0.6;
            weakSelf.progressView2.frame = viewFrame2;
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                CGRect viewFrame3 = weakSelf.progressView3.frame;
                viewFrame3.size.width = self.animationViewWidth*0.6;
                weakSelf.progressView3.frame = viewFrame3;
                
            } completion:^(BOOL finished) {
                if (weakSelf.isStop) return;
                [weakSelf startAnimation];
            }];
        }];
    }];
}

#pragma mark - UIConfiguration

- (void)congfigAnimationView {
    self.backgroundColor = [UIColor clearColor];
    [self configCircle];
    [self configProgressView];
}

- (void)configCircle {
    UIView *circle1 = [[UIView alloc]initWithFrame:CGRectMake(self.animationViewWidth*0.075, self.animationViewWidth*0.15, self.animationViewWidth*0.12, self.animationViewWidth*0.12)];
    circle1.backgroundColor = kAppTextCoclor;
    [circle1.layer setCornerRadius:circle1.frame.size.width*0.5];
    [self addSubview:circle1];
    
    UIView *circle2 = [[UIView alloc]initWithFrame:CGRectMake(self.animationViewWidth*0.075, self.animationViewWidth*0.45, self.animationViewWidth*0.12, self.animationViewWidth*0.12)];
    circle2.backgroundColor = kAppTextCoclor;
    [circle2.layer setCornerRadius:circle1.frame.size.width*0.5];
    [self addSubview:circle2];
    
    UIView *circle3 = [[UIView alloc]initWithFrame:CGRectMake(self.animationViewWidth*0.075, self.animationViewWidth*0.75, self.animationViewWidth*0.12, self.animationViewWidth*0.12)];
    circle3.backgroundColor = kAppTextCoclor;
    [circle3.layer setCornerRadius:circle1.frame.size.width*0.5];
    [self addSubview:circle3];
}

- (void)configProgressView {
    self.progressView1 = [[UIView alloc]initWithFrame:CGRectMake(self.animationViewWidth*0.35, self.animationViewWidth*0.16, 0, self.animationViewWidth*0.08)];
    self.progressView1.backgroundColor = kAppTextCoclor;
    [self.progressView1.layer setCornerRadius:self.progressView1.frame.size.height*0.5];
    [self addSubview:self.progressView1];
    
    self.progressView2 = [[UIView alloc]initWithFrame:CGRectMake(self.animationViewWidth*0.35, self.animationViewWidth*0.46, 0, self.animationViewWidth*0.08)];
    self.progressView2.backgroundColor = kAppTextCoclor;
    [self.progressView2.layer setCornerRadius:self.progressView2.frame.size.height*0.5];
    [self addSubview:self.progressView2];
    
    self.progressView3 = [[UIView alloc]initWithFrame:CGRectMake(self.animationViewWidth*0.35, self.animationViewWidth*0.76, 0, self.animationViewWidth*0.08)];
    self.progressView3.backgroundColor = kAppTextCoclor;
    [self.progressView3.layer setCornerRadius:self.progressView3.frame.size.height*0.5];
    [self addSubview:self.progressView3];
}

@end
