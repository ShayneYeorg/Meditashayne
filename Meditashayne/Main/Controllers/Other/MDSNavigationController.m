//
//  MDSNavigationController.m
//  meditashayne
//
//  Created by 杨淳引 on 16/2/10.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "MDSNavigationController.h"
#import "MDSArticleDetailViewController.h"

@interface MDSNavigationController ()

@end

@implementation MDSNavigationController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)configDetails{
//    self.navigationBar.barTintColor = RGB(0, 150, 30);
    
//    NSMutableDictionary *navTitleAttrs = [NSMutableDictionary dictionary];
//    navTitleAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    [self.navigationBar setTitleTextAttributes:navTitleAttrs];
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
        //不要在这里保存数据
//        MDSLog(@"保存数据");
    }
    
    //仍然执行方法本身的内容
    return [super popViewControllerAnimated:animated];
}

@end
