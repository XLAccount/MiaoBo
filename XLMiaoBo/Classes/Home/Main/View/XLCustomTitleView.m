

//
//  XLCustomTitleView.m
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import "XLCustomTitleView.h"

@interface XLCustomTitleView ()

@property (nonatomic, weak) UIButton *selectedBtn;

@end

@implementation XLCustomTitleView


- (UIView *)underLine
{
    if (_underLine == nil){
    
        UIView *underLine = [[UIView alloc] init];
        
        underLine.backgroundColor = [UIColor whiteColor];
        underLine.height = 4;
        underLine.width = 60;
        underLine.y = self.height - underLine.height;
        
        
        [self addSubview:underLine];
        _underLine = underLine;
    }
    return _underLine;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
    
        [self setupBasic];
    }
    return self;
}

- (void)setupBasic
{
    [self createBtn:@"热门" tag:Hot];
    [self createBtn:@"最新" tag:New];
    [self createBtn:@"关注" tag:Care];
}

/** 创建按钮 */
- (UIButton *)createBtn:(NSString *)title tag:(NSInteger)tag
{
    UIButton *btn = [[UIButton alloc] init];
    btn.title = title;
    btn.titleColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    btn.selectedTitleColor = [UIColor whiteColor];
    btn.tag = tag;
    
    [btn sizeToFit];
    
    if (tag == 0){
        
        [self clickBtn:btn];
    }
    
    CGFloat margin = (self.width - btn.width * 3) / 2;
    
    btn.frame = CGRectMake((btn.width + margin) * tag, 0, btn.width, btn.height);
    
    [btn addTarget:self action:@selector(clickBtn:)];
    
    [self addSubview:btn];
    
    return btn;
}

- (void)setType:(Type)type
{
    _type = type;
    
    for (UIView *view in self.subviews) {
        
        if ([view isKindOfClass:[UIButton class]] && view.tag == type){
            
            self.selectedBtn.selected = NO;
            ((UIButton *)view).selected = YES;
            self.selectedBtn = (UIButton *)view;
        }
    }
}

- (void)clickBtn:(UIButton *)btn
{
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    self.selectedBtn = btn;
    
    if (self.selectedBlock){
        
        self.selectedBlock(btn.tag);
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.underLine.centerX = btn.centerX;

    }];
}
@end
