//
//  MDSNavigationController.m
//  meditashayne
//
//  Created by 杨淳引 on 16/2/10.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "MDSNavigationController.h"
#import "MDSArticleDetailViewController.h"

@interface MDSNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation MDSNavigationController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configDetails];
    [self resetPopGestureDelegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)configDetails{
//    self.navigationBar.barTintColor = RGB(0, 150, 30);
    
//    NSMutableDictionary *navTitleAttrs = [NSMutableDictionary dictionary];
//    navTitleAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    [self.navigationBar setTitleTextAttributes:navTitleAttrs];
}

- (void)resetPopGestureDelegate {
    //由于随笔详情界面在navigation bar上使用自定义返回按钮，这里需要重新设置delegate，左滑才能生效
    __weak typeof(self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
}

#pragma mark - Overwrite

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //修改
//    if (self.viewControllers.count > 0) {
//        viewController.hidesBottomBarWhenPushed = YES;
//    }

    //仍然执行方法本身的内容
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    //修改
    if ([[self.viewControllers lastObject] isKindOfClass:[MDSArticleDetailViewController class]]) {
        //不要在这里保存数据，在随笔详情界面的dealloc方法里保存
//        MDSLog(@"保存数据");
    }
    
    //仍然执行方法本身的内容
    return [super popViewControllerAnimated:animated];
}

@end
