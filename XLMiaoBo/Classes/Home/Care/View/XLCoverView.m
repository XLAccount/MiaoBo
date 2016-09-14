
//
//  XLCoverView.m
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import "XLCoverView.h"

@implementation XLCoverView

+ (instancetype)coverView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"XLCoverView" owner:nil options:nil] lastObject];
}

- (IBAction)goToHot {
    
    UIScrollView *scrollView = (UIScrollView *)self.superview.superview;
    
    [UIView animateWithDuration:0.2 animations:^{
    
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y);
    }];
    
}

@end
