
//
//  XLLiveEndView.m
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import "XLLiveEndView.h"
#import "XLDealData.h"

@interface XLLiveEndView ()


@property (weak, nonatomic) IBOutlet UIButton *quitBtn;
@property (weak, nonatomic) IBOutlet UIButton *lookOtherBtn;
@property (weak, nonatomic) IBOutlet UIButton *careBtn;

@end
@implementation XLLiveEndView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self maskRadius:self.quitBtn];
    [self maskRadius:self.lookOtherBtn];
    [self maskRadius:self.careBtn];
}

+ (instancetype)liveEndView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)setHotModel:(XLHotModel *)hotModel
{
    _hotModel = hotModel;
    
    if ([[XLDealData shareDealData].allModels containsObject:hotModel]){
        
        self.careBtn.selected = YES;
    }
}

- (void)maskRadius:(UIButton *)btn
{
    btn.layer.cornerRadius = btn.height * 0.5;
    btn.layer.masksToBounds = YES;
    if (btn != self.careBtn) {
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = XLBasicColor.CGColor;
    }
}
- (IBAction)care:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected){
        
        [[XLDealData shareDealData] saveData:_hotModel];
        [MBProgressHUD showSuccess:@"关注成功"];
    }else{
        
        [[XLDealData shareDealData] unsaveData:_hotModel];
        [MBProgressHUD showSuccess:@"取消关注成功"];
    }
    
}
- (IBAction)lookOther {
    [self removeFromSuperview];
    if (self.lookOtherBlock) {
        self.lookOtherBlock();
    }
}
- (IBAction)quit {
    if (self.quitBlock) {
        self.quitBlock();
    }
}


@end
