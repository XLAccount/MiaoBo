//
//  XLTabBarViewController.m
//  XLMiaoBo
//
//  Created by XuLi on 16/8/30.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import "XLTabBarViewController.h"
#import "XLNavigationController.h"
#import "XLHomeViewController.h"
#import "XLPlayLiveViewContorller.h"
#import "XLProfileViewController.h"


@interface XLTabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation XLTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    [self setupBasic];
}

- (void)setupBasic
{
    //首页
    [self addChildViewController:[[XLHomeViewController alloc] init] notmalimageNamed:@"toolbar_home" selectedImage:@"toolbar_home_sel" title:@"首页"];
    //直播
    [self addChildViewController:[[XLPlayLiveViewContorller alloc] init] notmalimageNamed:@"toolbar_live" selectedImage:nil title:@"直播"];
    //个人中心
    [self addChildViewController:[[XLProfileViewController alloc] init] notmalimageNamed:@"toolbar_me" selectedImage:@"toolbar_me_sel" title:@"个人中心"];
}

- (void)addChildViewController:(UIViewController *)childController notmalimageNamed:(NSString *)imageName selectedImage:(NSString *)selectedImageName title:(NSString *)title
{
    XLNavigationController *nav = [[XLNavigationController alloc] initWithRootViewController:childController];
    childController.tabBarItem.image = [UIImage imageNamed:imageName];
    childController.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    childController.title = title;
    [childController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : XLBasicColor} forState:UIControlStateNormal];
    
    [self addChildViewController:nav];
}

#pragma mark 代理方法
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([viewController.tabBarItem.image isEqual:[UIImage imageNamed:@"toolbar_live"]]){
        
        [self presentViewController:[[XLPlayLiveViewContorller alloc] init] animated:YES completion:nil];
        
        return NO;
    }
    
    return YES;
}
@end
