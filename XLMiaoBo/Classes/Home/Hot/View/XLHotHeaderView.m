
//
//  XLHotHeaderView.m
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import "XLHotHeaderView.h"

@interface XLHotHeaderView ()

@property (nonatomic, weak) UIView *myView;
@property (nonatomic, strong) NSMutableArray *lastModels;
@end
@implementation XLHotHeaderView



- (void)setHeaderModels:(NSArray *)headerModels
{
    _headerModels = headerModels;
    
    NSMutableArray *imageUrls = [NSMutableArray array];
    for (XLHotHeaderModel *headerModel in headerModels) {
        
        [imageUrls addObject:headerModel.imageUrl];
    }
    
    
    //如果返回数据和上一次一样直接返回
//    if ([self.lastModels containsObject:headerModels]) return;
    
    if (self.lastModels) return;
    
    self.myView = nil;
    [self.myView removeFromSuperview];
    
      XRCarouselView *view = [XRCarouselView carouselViewWithImageArray:imageUrls describeArray:nil];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
    
        view.time = 2.0;
        view.delegate = weakSelf;
        view.frame = weakSelf.bounds;
        //    移除之前的view
    
        NSLog(@"%@",self.lastModels);
        [weakSelf addSubview:view];
        
        weakSelf.lastModels = [NSMutableArray arrayWithArray:headerModels];
        weakSelf.myView = view;
    });


}


#pragma mark - XRCarouselViewDelegate
- (void)carouselView:(XRCarouselView *)carouselView clickImageAtIndex:(NSInteger)index
{
    if (self.imageClickBlock) {
        self.imageClickBlock(self.headerModels[index]);
    }
}

@end
