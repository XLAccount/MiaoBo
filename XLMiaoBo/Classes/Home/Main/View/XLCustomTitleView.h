//
//  XLCustomTitleView.h
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,Type) {
    Hot, // 热门
    New, // 最新
    Care // 关注
};

@interface XLCustomTitleView : UIView

/** 下划线 */
@property (nonatomic, weak) UIView *underLine;

/** 选中了 */
@property (nonatomic, copy)void (^selectedBlock)(Type type);

/** 设置滑动选中的按钮 */
@property (nonatomic, assign) Type type;
@end
