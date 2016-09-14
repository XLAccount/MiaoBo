


//
//  XLCustomScrollView.m
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import "XLCustomScrollView.h"
#import "XLHotViewController.h"
#import "XLNewViewController.h"
#import "XLCareViewController.h"

@interface XLCustomScrollView ()

@property (nonatomic, strong) XLCareViewController *care;

@end

@implementation XLCustomScrollView

- (void)setupBasic{
    
    //去掉滚动条
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    //去掉弹簧效果
    self.bounces = NO;
    //设置自动分页
    self.pagingEnabled = YES;

    
    self.frame = [UIScreen mainScreen].bounds;
    self.contentSize = CGSizeMake(XLScreenW * 3, 0);
    
    XLHotViewController *hot = [[XLHotViewController alloc] init];
    XLNewViewController *new = [[XLNewViewController alloc] init];
     self.care = [[XLCareViewController alloc] init];
    
    [self addSubview:hot.view];
    [self addSubview:new.view];
    [self addSubview:self.care.view];
    
    hot.view.y = 0;
    hot.view.x = 0;
    new.view.x = XLScreenW;
    self.care.view.x = XLScreenW * 2;
    
    [self.vc addChildViewController:hot];
    [self.vc addChildViewController:new];
    [self.vc addChildViewController:self.care];

}

- (void)setContenOffsetX:(NSInteger)contenOffsetX
{
    _contenOffsetX = contenOffsetX;
    
//    如果x坐标大于屏幕宽度就重新加载关注页面，便于关注数据的刷新
    if (contenOffsetX > XLScreenW){
        [self.care.collectionView reloadData];
    }
}

- (void)setVc:(UIViewController *)vc
{
    _vc = vc;
    
    [self setupBasic];
}

@end
