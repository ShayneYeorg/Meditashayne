//
//  MDSTool.m
//  Meditashayne
//
//  Created by 杨淳引 on 16/2/3.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "MDSTool.h"
#import "MDSShadeViewAnimationView.h"

@implementation MDSTool

dispatch_queue_t shadeViewQueue = nil;

+ (UIWindow *)getWindow {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    return window;
}

+ (void)showShadeViewWithText:(NSString *)text {
    UIWindow *window = [MDSTool getWindow];
    [[window viewWithTag:362912631]removeFromSuperview];
    UIView *view = [[UIView alloc]initWithFrame:window.bounds];
    view.tag = 362912631;
    UIView *backView = [[UIView alloc]initWithFrame:window.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.4;
    [view addSubview:backView];
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 130, 110)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius=8;
    MDSShadeViewAnimationView *activity = [[MDSShadeViewAnimationView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    activity.center = CGPointMake(130/2, 40);
    activity.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
    [activity startAnimation];
    [whiteView addSubview:activity];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0,67, 130, 35)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    label.textColor = kAppTextCoclor;
    [whiteView addSubview:label];
    [view addSubview:whiteView];
    whiteView.center = CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2);
    
    [window addSubview:view];
}

+ (void)dismissShadeView {
    UIWindow *window = [MDSTool getWindow];
    [[window viewWithTag:362912631]removeFromSuperview];
    MDSLog(@"removeFromSuperview");
}

@end
