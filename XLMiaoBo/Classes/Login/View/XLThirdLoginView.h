//
//  XLThirdLoginView.h
//  XLMiaoBo
//
//  Created by XuLi on 16/8/30.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XLType){
    
    sina,
    qq,
    weixin
};

@interface XLThirdLoginView : UIView

@property (nonatomic, copy) void(^selectedBlock)(XLType type);
@end
