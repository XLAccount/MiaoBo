//
//  XLAnchorInfoView.h
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLHotModel.h"

@interface XLAnchorInfoView : UIView


@property (nonatomic, strong) XLHotModel *hotModel;

@property (nonatomic, strong) NSArray *allModels;

@property (nonatomic, copy) void (^selectBlock)(XLHotModel *hotModel, UIImage *image);

@property (nonatomic, strong) UIImage *image;

+ (instancetype)anchorInfoView;
@end
