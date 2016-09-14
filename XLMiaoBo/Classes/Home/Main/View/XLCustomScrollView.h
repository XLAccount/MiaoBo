//
//  XLCustomScrollView.h
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLCustomScrollView : UIScrollView

@property (nonatomic, strong) UIViewController *vc;

/** 偏移x坐标 */
@property (nonatomic, assign) NSInteger contenOffsetX;
@end
