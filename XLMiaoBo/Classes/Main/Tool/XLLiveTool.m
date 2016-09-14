
//
//  XLLiveTool.m
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import "XLLiveTool.h"
#import "AFHTTPSessionManager.h"
#import "AFURLRequestSerialization.h"

@interface XLLiveTool ()

@end

@implementation XLLiveTool

XLSingletonM(LiveTool)


+ (void)GetWithHotURL:(NSInteger)page success:(void (^)(XLNewResult *))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    
    manager.requestSerializer.HTTPShouldHandleCookies = NO;
    manager.requestSerializer.HTTPShouldUsePipelining = YES;
    [manager.operationQueue cancelAllOperations];
//    
//    request.HTTPShouldHandleCookies = NO;
//    
//    request.HTTPShouldUsePipelining = YES;
    
    manager.requestSerializer.timeoutInterval = 5;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    
    [manager GET:[NSString stringWithFormat:@"http://live.9158.com/Fans/GetHotLive?page=%ld", page] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        XLNewResult *result = [XLNewResult mj_objectWithKeyValues:responseObject];
        
        success(result);
        

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
    }];
}

+ (void)GetWithNewURL:(NSInteger)page success:(void (^)(XLNewResult *))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.requestSerializer.timeoutInterval = 5;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    
    [manager GET:[NSString stringWithFormat:@"http://live.9158.com/Room/GetNewRoomOnline?page=%ld", page] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        XLNewResult *result = [XLNewResult mj_objectWithKeyValues:responseObject];
        
        success(result);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
    }];

}

+ (void)GetWithSuccess:(void (^)(XLHotHeaderResult *))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    
    manager.requestSerializer.timeoutInterval = 5;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    
    [manager GET:@"http://live.9158.com/Living/GetAD" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        XLHotHeaderResult *result = [XLHotHeaderResult mj_objectWithKeyValues:responseObject];
        
        success(result);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
    }];

}

+ (void)GetWithURL:(NSString *)url success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    manager.requestSerializer.timeoutInterval = 5;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
    }];

}

// 判断网络类型
+ (NetworkStates)getNetworkStates
{
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    // 保存网络状态
    NetworkStates states = NetworkStatesNone;
    for (id child in subviews) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏码
            int networkType = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            switch (networkType) {
                case 0:
                    states = NetworkStatesNone;
                    //无网模式
                    break;
                case 1:
                    states = NetworkStates2G;
                    break;
                case 2:
                    states = NetworkStates3G;
                    break;
                case 3:
                    states = NetworkStates4G;
                    break;
                case 5:
                {
                    states = NetworkStatesWIFI;
                }
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return states;
}


@end
