//
//  XLUserInfoView.m
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import "XLUserInfoView.h"
#import "XLDealData.h"
#import "XLAnchorInfoView.h"

@interface XLUserInfoView ()

@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *careNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansNumLabel;
@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UIButton *care;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightContraints;

@property (nonatomic, strong) XLHotModel *hotModel;
@property (nonatomic, weak) XLUserInfoView *userInfoView;
@property (nonatomic, weak) UIView *myView;
@end
@implementation XLUserInfoView

+ (instancetype)userInfoView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.careNumLabel.text = [NSString stringWithFormat:@"%d", arc4random_uniform(5000) + 500];
    self.fansNumLabel.text = [NSString stringWithFormat:@"%d", arc4random_uniform(30000) + 500];
    self.userView.layer.cornerRadius = 10;
    self.userView.layer.masksToBounds = YES;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    self.coverView.layer.cornerRadius = self.coverView.width / 2;
    self.coverView.layer.masksToBounds = YES;
    
    
    self.coverView.image = image;
}

- (void)userWithHotModel:(XLHotModel *)hotModel ofView:(UIView *)view
{
    self.hotModel = hotModel;
    self.myView = view;
 
    [[XLDealData shareDealData].allModels enumerateObjectsUsingBlock:^(XLHotModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([hotModel.flv isEqualToString:obj.flv]){
            
            self.care.selected = YES;
        }
        
    }];

    
    self.nickNameLabel.text = hotModel.myname;
    
    if (self.userInfoView) return;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.width = XLScreenW;
    
    if (XLScreenW < 400){
        
        self.heightContraints.constant = 400;
        
        
    }else{
    
    self.heightContraints.constant = XLScreenW;
   
    }
    self.center = [UIApplication sharedApplication].keyWindow.center;
    
    view.userInteractionEnabled = NO;
    
    self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.transform = CGAffineTransformIdentity;
    }];
    
    self.userInfoView = self;
}


- (IBAction)care:(UIButton *)sender {
 
    sender.selected = !sender.selected;
    
    if (sender.selected){
        
        [[XLDealData shareDealData] saveData:_hotModel];
        [MBProgressHUD showSuccess:@"关注成功"];
    }else{
        
        if ([[XLDealData shareDealData].allModels isEqualToArray:self.allModel]){
            
            sender.selected = YES;
            [MBProgressHUD showError:@"不能取消,请点击别的取消按钮"];
            
        }else{
        
        [[XLDealData shareDealData] unsaveData:self.hotModel];
        [MBProgressHUD showSuccess:@"取消关注成功"];
        }
    }
    
}

- (IBAction)tipoffs {
    
    [MBProgressHUD showSuccess:@"举报成功"];
}

- (IBAction)close {
    
    self.myView.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.userInfoView = nil;
    }];

}
- (IBAction)watchLive {
    
    [self close];
    
    if (self.selectedBlock){
        
        self.selectedBlock();
    }
}

@end
