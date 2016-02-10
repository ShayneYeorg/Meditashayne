//
//  MDSNavigationController.m
//  meditashayne
//
//  Created by 杨淳引 on 16/2/10.
//  Copyright © 2016年 shayneyeorg. All rights reserved.
//

#import "MDSNavigationController.h"

@interface MDSNavigationController ()

@end

@implementation MDSNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configDetails{
//    self.navigationBar.barTintColor = RGB(0, 150, 30);
    
//    NSMutableDictionary *navTitleAttrs = [NSMutableDictionary dictionary];
//    navTitleAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    [self.navigationBar setTitleTextAttributes:navTitleAttrs];
}

//重写
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //取到第二级或第二级以下的viewController（即不是根控制器的其他控制器）做修改
//    if (self.viewControllers.count > 0) {
//        viewController.hidesBottomBarWhenPushed = YES;
//    }
    
    //做完个性化修改，然后仍然执行方法本身的内容
    [super pushViewController:viewController animated:animated];
}

@end
