//
//  XLHotData.m
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import "XLHotData.h"
#import "XLHotModel.h"

@implementation XLHotData

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list" : [XLHotModel class]};
}

@end
