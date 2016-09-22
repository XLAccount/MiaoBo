//
//  AppDelegate.m
//  XLMiaoBo
//
//  Created by XuLi on 16/8/30.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import "AppDelegate.h"
#import "XLLoginViewController.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialData.h"
#import "UMSocialSnsService.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialConfig.h"
#import "Reachability.h"
#import "XLLiveTool.h"

@interface AppDelegate ()

@property (nonatomic, strong) Reachability *reacha;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    XLLoginViewController *login = [[XLLoginViewController alloc] init];
  
    self.window.rootViewController = login;
    
    [self.window makeKeyAndVisible];
    
    [UMSocialData setAppKey:UmengAppkey];
    
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"2039393085" secret:@"7da7d4501f3f51a14040e1fa5eca7723" RedirectURL:@"http://www.code4app.com/space-uid-843201.html"];
    
    [UMSocialWechatHandler setWXAppId:@"wxe6b5b748cdcff60f" appSecret:@"d4624c36b6795d1d99dcf0547af5443d" url:@"http://www.umeng.com/social"];
    
    [UMSocialQQHandler setQQWithAppId:@"1104908293" appKey:@"MnGtpPN5AiB6MNvj" url:@"www.umeng.com/social"];
    

    [self checkNetworkStates];
    
    return YES;
}


- (void)checkNetworkStates
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChange) name:kReachabilityChangedNotification object:nil];
    _reacha = [Reachability reachabilityWithHostName:@"http://www.baidu.com"];
    [_reacha startNotifier];
}



- (void)networkChange
{
    NSString *tips;
    NetworkStates currentStates = [XLLiveTool getNetworkStates];
    
    switch (currentStates) {
        case NetworkStatesNone:
            tips = @"当前无网络, 请检查您的网络状态";
            break;
        case NetworkStates2G:
            tips = @"切换到了2G网络";
            break;
        case NetworkStates3G:
            tips = @"切换到了3G网络";
            break;
        case NetworkStates4G:
            tips = @"切换到了4G网络";
            break;
        case NetworkStatesWIFI:
            tips = nil;
            break;
        default:
            break;
    }
    
    if (tips.length) {
        [[[UIAlertView alloc] initWithTitle:@"喵播" message:tips delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
        
        }
}


/**
 这里处理新浪微博SSO授权之后跳转回来，和微信分享完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return  result;
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDImageCache sharedImageCache] clearMemory];
}

@end
