//
//  XLThirdLoginView.m
//  XLMiaoBo
//
//  Created by XuLi on 16/8/30.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import "XLThirdLoginView.h"

@implementation XLThirdLoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
       
        [self setupBasic];
    }
    
    return self;
}

- (void)setupBasic
{
    [self createBtnWithImage:@"wbLoginicon_60x60" tag:0];
    [self createBtnWithImage:@"qqloginicon_60x60" tag:1];
    [self createBtnWithImage:@"wxloginicon_60x60" tag:2];
}

- (UIButton *)createBtnWithImage:(NSString *)imageName tag:(NSInteger)tag
{
    UIButton *btn = [[UIButton alloc] init];
    
    btn.image = imageName;
    btn.tag = tag;
    
//    自适应大小
    [btn sizeToFit];
    
    [btn addTarget:self action:@selector(btnClick:)];
    
    [self addSubview:btn];
    return btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSInteger count = self.subviews.count;
    for (int i=0; i<count; i++){
        UIButton *btn = self.subviews[i];
        CGFloat margin =  (XLScreenW -  btn.width* count) / (count + 1);
        CGFloat x = (btn.width + margin) * i + margin;
        CGFloat y = 0;
        btn.frame = CGRectMake(x, y, btn.width, btn.height);
    }
}



- (void)btnClick:(UIButton *)btn
{
    if (self.selectedBlock){
        
        self.selectedBlock(btn.tag);
    }
}
@end
