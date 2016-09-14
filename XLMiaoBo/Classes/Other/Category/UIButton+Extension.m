//
//  UIButton+Extension.m
//  美团HD
//
//  Created by MJ Lee on 14/8/14.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "UIButton+Extension.h"


@implementation UIButton (Extension)

- (void)setHighlightedTitle:(NSString *)highlightedTitle
{
    [self setTitle:highlightedTitle forState:UIControlStateHighlighted];
}

- (NSString *)highlightedTitle
{
    return nil;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}

- (UIColor *)titleColor
{
    return nil;
}

- (void)setHighlightedTitleColor:(UIColor *)highlightedTitleColor
{
    [self setTitleColor:highlightedTitleColor forState:UIControlStateHighlighted];
}

- (UIColor *)highlightedTitleColor
{
    return nil;
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor
{
    [self setTitleColor:selectedTitleColor forState:UIControlStateSelected];
}

- (UIColor *)selectedTitleColor
{
    return nil;
}

- (void)setTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
}

- (NSString *)title
{
    return [self titleForState:UIControlStateNormal];
}

- (void)setSelectedTitle:(NSString *)selectedTitle
{
    [self setTitle:selectedTitle forState:UIControlStateSelected];
}

- (NSString *)selectedTitle
{
    return [self titleForState:UIControlStateSelected];
}

- (void)setImage:(NSString *)image
{
    [self setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
}

- (NSString *)image
{
    return nil;
}

- (void)setHighlightedImage:(NSString *)image
{
    [self setImage:[UIImage imageNamed:image] forState:UIControlStateHighlighted];
}

- (NSString *)highlightedImage
{
    return nil;
}

- (void)setSelectedImage:(NSString *)image
{
    [self setImage:[UIImage imageNamed:image] forState:UIControlStateSelected];
}

- (NSString *)selectedImage
{
    return nil;
}

- (void)setBgImage:(NSString *)image
{
    [self setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
}

- (NSString *)bgImage
{
    return nil;
}

- (void)setHighlightedBgImage:(NSString *)image
{
    [self setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateHighlighted];
}

- (NSString *)highlightedBgImage
{
    return nil;
}

- (void)setSelectedBgImage:(NSString *)image
{
    [self setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateSelected];
}

- (NSString *)selectedBgImage
{
    return nil;
}

- (void)addTarget:(id)target action:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

static UIButton *TopBtn;

+ (void)initialize
{
    UIButton *btn = [[UIButton alloc] initWithFrame:[UIApplication sharedApplication].statusBarFrame];
    [btn addTarget:self action:@selector(windowClick) forControlEvents:UIControlEventTouchUpInside];
    [[self statusBarView] addSubview:btn];
    btn.hidden = YES;
    TopBtn = btn;
}

+ (void)show
{
    TopBtn.hidden = NO;
}

+ (void)hide
{
    TopBtn.hidden = YES;
}

/**
 获取当前状态栏的方法
 */
+ (UIView *)statusBarView
{
    UIView *statusBar = nil;
    NSData *data = [NSData dataWithBytes:(unsigned char []){0x73, 0x74, 0x61, 0x74, 0x75, 0x73, 0x42, 0x61, 0x72} length:9];
    NSString *key = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    id object = [UIApplication sharedApplication];
    if ([object respondsToSelector:NSSelectorFromString(key)]) statusBar = [object valueForKey:key];
    return statusBar;
}

/**
 * 监听窗口点击
 */
+ (void)windowClick
{
    NSLog(@"点击了最顶部...");
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self searchScrollViewInView:window];
}

+ (void)searchScrollViewInView:(UIView *)superview
{
    for (UIScrollView *subview in superview.subviews) {
        // 如果是scrollview, 滚动最顶部
        if ([subview isKindOfClass:[UIScrollView class]] && subview.isShowingOnKeyWindow) {
            CGPoint offset = subview.contentOffset;
            offset.y = - subview.contentInset.top;
            [subview setContentOffset:offset animated:YES];
        }
        
        // 继续查找子控件
        [self searchScrollViewInView:subview];
    }
}


@end
