//
//  XLNavigationController.m
//  XLMiaoBo
//
//  Created by XuLi on 16/8/30.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import "XLNavigationController.h"
#import "XLLoginViewController.h"
#import "UIBarButtonItem+XL.h"

@interface XLNavigationController ()

@end

@implementation XLNavigationController

+ (void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"navBar_bg_414x70"] forBarMetrics:UIBarMetricsDefault];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{    
    
    if (self.childViewControllers.count) { // 隐藏导航栏
        
        viewController.hidesBottomBarWhenPushed = YES;
        
        
        // 自定义返回按钮
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:@"back_9x16" highlightImage:nil targer:self action:@selector(back)];
        
        // 如果自定义返回按钮后, 滑动返回可能失效, 需要添加下面的代码
        __weak typeof(viewController)Weakself = viewController;
        self.interactivePopGestureRecognizer.delegate = (id)Weakself;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    // 判断两种情况: push 和 present
    if ((self.presentedViewController || self.presentingViewController) && self.childViewControllers.count == 1) {
        
               
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
        [self popViewControllerAnimated:YES];
}

@end
