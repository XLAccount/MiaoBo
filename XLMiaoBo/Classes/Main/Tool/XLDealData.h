//
//  XLDealData.h
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XLShareSingle.h"
#import "XLHotModel.h"

@interface XLDealData : NSObject

XLSingletonH(DealData)

@property (nonatomic, strong, readonly) NSMutableArray *allModels;

/** 保存数据 */
- (void)saveData:(XLHotModel *)hotModel;

/** 删除数据 */
- (void)unsaveData:(XLHotModel *)hotModel;
@end
