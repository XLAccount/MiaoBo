//
//  XLLiveTool.h
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLNewResult.h"
#import "XLShareSingle.h"
#import "XLHotHeaderResult.h"

typedef NS_ENUM(NSUInteger, NetworkStates) {
    NetworkStatesNone, // 没有网络
    NetworkStates2G, // 2G
    NetworkStates3G, // 3G
    NetworkStates4G, // 4G
    NetworkStatesWIFI // WIFI
};


@interface XLLiveTool : NSObject

XLSingletonH(LiveTool)

/** 请求新晋主播数据 */
+ (void)GetWithNewURL:(NSInteger)page success:(void (^)(XLNewResult *result))success failure:(void (^)(NSError *error))failure;

/** 请求热门主播数据 */
+ (void)GetWithHotURL:(NSInteger)page success:(void (^)(XLNewResult *result))success failure:(void (^)(NSError *error))failure;

/** 请求热门头部信息 */
+ (void)GetWithSuccess:(void (^)(XLHotHeaderResult *result))success failure:(void (^)(NSError *error))failure;

/** 请求数据 */
+ (void)GetWithURL:(NSString *)url success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;


// 判断网络类型
+ (NetworkStates)getNetworkStates;
@end

