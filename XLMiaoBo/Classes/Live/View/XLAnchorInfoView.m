
//
//  XLAnchorInfoView.m
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import "XLAnchorInfoView.h"
#import "XLDealData.h"
#import <UIKit/UIKit.h>

@interface XLAnchorInfoView ()


@property (weak, nonatomic) IBOutlet UIView *anchorView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;
@property (weak, nonatomic) IBOutlet UIButton *careBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *peoplesScrollView;
@property (weak, nonatomic) IBOutlet UIButton *giftView;
@property (weak, nonatomic) IBOutlet UILabel *roomID;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation XLAnchorInfoView


+ (instancetype)anchorInfoView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self maskViewToBounds:self.anchorView];
    [self maskViewToBounds:self.headImageView];
    [self maskViewToBounds:self.careBtn];
    [self maskViewToBounds:self.giftView];
    
    self.headImageView.layer.borderWidth = 1;
    self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;

    
    [self.careBtn setBackgroundImage:[UIImage imageWithColor:XLBasicColor size:self.careBtn.size] forState:UIControlStateNormal];
    [self.careBtn setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor] size:self.careBtn.size] forState:UIControlStateSelected];

}

- (void)maskViewToBounds:(UIView *)view
{
    view.layer.cornerRadius = view.height * 0.5;
    view.layer.masksToBounds = YES;
}

static int randomNum = 0;
- (void)setHotModel:(XLHotModel *)hotModel
{
    _hotModel = hotModel;
 
    if ([[XLDealData shareDealData].allModels containsObject:hotModel]){
        
        self.careBtn.selected = YES;
    }
        
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:hotModel.bigpic] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    self.nameLabel.text = hotModel.myname;
    self.peopleLabel.text = [NSString stringWithFormat:@"%@人", hotModel.allnum];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateNum) userInfo:nil repeats:YES];
    self.headImageView.userInteractionEnabled = YES;
    [self.headImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeaderView:)]];
    
    self.peopleLabel.adjustsFontSizeToFitWidth = YES;
    self.roomID.adjustsFontSizeToFitWidth = YES;
    self.roomID.text = [NSString stringWithFormat:@"房间号:%@",hotModel.roomid];
}


- (void)setImage:(UIImage *)image
{
    _image = image;
    
    self.headImageView.image = self.image;
}

- (void)updateNum
{
    randomNum += arc4random_uniform(5);
    
    self.peopleLabel.text = [NSString stringWithFormat:@"%ld人", [self.hotModel.allnum integerValue] + randomNum];
    [self.giftView setTitle:[NSString stringWithFormat:@"猫粮:%u  娃娃%u", 1993045 + randomNum,  124593+randomNum] forState:UIControlStateNormal];
}

- (void)setAllModels:(NSArray *)allModels
{
    _allModels = allModels;
    
    CGFloat margin = 10;
    
    self.peoplesScrollView.contentSize = CGSizeMake((self.peoplesScrollView.height + margin) * allModels.count + margin, 0);
    
    if (self.peoplesScrollView.contentSize.width < XLScreenW){
        
        self.peoplesScrollView.contentSize = CGSizeMake(XLScreenW, 0);
    }
    
    
    self.peoplesScrollView.showsVerticalScrollIndicator = NO;
    self.peoplesScrollView.showsHorizontalScrollIndicator =  NO;
    
    CGFloat width = self.peoplesScrollView.height - 10;
    CGFloat x = 0;
    
    for (int i = 0; i<self.allModels.count; i++) {
        
        x = 0 + (margin + width) * i;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, 5, width, width)];
        btn.layer.cornerRadius = width * 0.5;
        btn.layer.masksToBounds = YES;
        
        
        CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        
        basic.toValue = @(M_PI * 2);
        
        basic.duration = 7;
        
        basic.repeatCount = MAXFLOAT;
        
        [btn.layer addAnimation:basic forKey:nil];
        
        [btn addTarget:self action:@selector(clickBtn:)];
        
        XLHotModel *hotModel = allModels[i];
        
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:hotModel.bigpic] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [btn setImage:[UIImage circleImage:image borderColor:[UIColor whiteColor] borderWidth:1] forState:UIControlStateNormal];
            });
        }];
       
        btn.tag = i;
        
        [self.peoplesScrollView addSubview:btn];

    }
}

- (void)clickHeaderView:(UITapGestureRecognizer *)tapGes
{
    if (self.selectBlock){
        self.selectBlock(_hotModel,self.headImageView.image);
    }
}

- (void)clickBtn:(UIButton *)btn
{
    
    [UIView animateWithDuration:0.3 animations:^{
        
         _peoplesScrollView.contentOffset = CGPointMake(btn.x ,_peoplesScrollView.contentOffset.y);
    }];
    
    if (self.selectBlock){
        self.selectBlock(_allModels[btn.tag], btn.imageView.image);
    }
}

- (IBAction)careClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (sender.selected){
        
        [[XLDealData shareDealData] saveData:_hotModel];
        [MBProgressHUD showSuccess:@"关注成功"];
    }else{
        
        
        [[XLDealData shareDealData] unsaveData:_hotModel];
        [MBProgressHUD showSuccess:@"取消关注成功"];
        
        
        
    }

}

@end
