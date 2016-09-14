//
//  XLHotHeaderView.h
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLHotHeaderModel.h"
#import "XRCarouselView.h"

@interface XLHotHeaderView : UIView <XRCarouselViewDelegate>

/** 顶部AD数组 */
@property (nonatomic, strong) NSArray *headerModels;
/** 点击图片的block */
@property (nonatomic, copy) void (^imageClickBlock)(XLHotHeaderModel *headerModel);

@end
