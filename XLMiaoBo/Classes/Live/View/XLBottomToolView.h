//
//  XLBottomToolView.h
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLBottomToolView : UIView

@property (nonatomic, copy) void (^clickToolBlock)(NSInteger tag);

@end
