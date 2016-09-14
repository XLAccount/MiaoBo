//
//  XLDealData.m
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import "XLDealData.h"
#define XLData [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"allModel.pist"]


@interface XLDealData (){
    
    NSMutableArray *_allModels;
}

@end

@implementation XLDealData

XLSingletonM(DealData)

- (NSMutableArray *)allModels
{
    if (_allModels == nil){
        
        _allModels = [NSKeyedUnarchiver unarchiveObjectWithFile:XLData];
        
        if (_allModels == nil){
        
            _allModels = [NSMutableArray array];
        }
        
    }
    return _allModels;
}

- (void)saveData:(XLHotModel *)hotModel
{
    [self.allModels removeObject:hotModel];
    
    [self.allModels insertObject:hotModel atIndex:0];
    
    
    
    [NSKeyedArchiver archiveRootObject:self.allModels toFile:XLData];
}

- (void)unsaveData:(XLHotModel *)hotModel
{
    [[XLDealData shareDealData].allModels enumerateObjectsUsingBlock:^(XLHotModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([hotModel.flv isEqualToString:obj.flv]){
            
//                       
            [self.allModels removeObject:obj];
        }
        
    }];
    
    [NSKeyedArchiver archiveRootObject:self.allModels toFile:XLData];
}

@end
