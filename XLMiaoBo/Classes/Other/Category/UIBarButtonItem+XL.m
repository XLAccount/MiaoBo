//
//  UIBarButtonItem+XL.m
//  XLMiaoBo
//
//  Created by XuLi on 16/9/10.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import "UIBarButtonItem+XL.h"

@implementation UIBarButtonItem (XL)

+ (instancetype)barButtonItemWithImage:(NSString *)image highlightImage:(NSString *)highlightImage targer:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.image = image;
    btn.highlightedImage = highlightImage;
    
    [btn sizeToFit];
    
    [btn addTarget:target action:action];
    
    return [[self alloc] initWithCustomView:btn];
}

@end
