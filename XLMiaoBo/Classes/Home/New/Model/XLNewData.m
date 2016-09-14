
//
//  XLNewData.m
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import "XLNewData.h"
#import "XLNewModel.h"
@implementation XLNewData

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list" : [XLNewModel class]};
}

@end
