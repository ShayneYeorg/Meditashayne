//
//  MDSPullUpToMore.h
//  MDSPullUpToMore
//
//  Created by 杨淳引 on 16/2/3.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDSPullUpToMore : UIView

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) BOOL canMore;

- (id)initWithScrollView:(UIScrollView*)scrollView;
- (void)scrollViewDidScroll:(CGPoint)contentOffset;
- (void)triggerMore;
- (void)stopAnimation;

@end


@interface UIScrollView (MDSPullUpToMore)

@property (nonatomic, strong) MDSPullUpToMore *pullUpToMoreView;

- (void)addPullUpToMoreWithActionHandler:(void (^)(void))actionHandler;
- (void)addPullUpToMoreWithNoRecordTip:(NSString *)tip andActionHandler:(void (^)(void))actionHandler;
- (void)stopAnimation;
- (void)didScroll;

@end
