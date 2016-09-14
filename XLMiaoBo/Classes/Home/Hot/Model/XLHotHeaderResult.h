//
//  XLHotHeaderResult.h
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLHotHeaderResult : NSObject

/** 状态码 */
@property (nonatomic, copy) NSString *code;

/** 状态 */
@property (nonatomic, copy) NSString *msg;

/** 返回主播信息 */
@property (nonatomic, strong) NSArray *data;

@end
