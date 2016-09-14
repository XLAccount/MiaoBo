//
//  XLUserInfoView.h
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLHotModel.h"

@interface XLUserInfoView : UIView

- (void)userWithHotModel:(XLHotModel *)hotModel ofView:(UIView *)view;

@property (nonatomic, copy) void (^selectedBlock)();

@property (nonatomic, copy) void (^deleteBlock)();

@property (nonatomic, strong) NSArray *allModel;

+ (instancetype)userInfoView;

@property (nonatomic, strong) UIImage *image;
@end
