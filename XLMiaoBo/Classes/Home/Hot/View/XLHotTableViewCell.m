
//
//  XLHotTableViewCell.m
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import "XLHotTableViewCell.h"
#import "UIImage+Extension.h"
#import "XLUserInfoView.h"
#import "XLWatchLiveViewController.h"
#import "UMSocial.h"
#import "XLHotModel.h"


@interface XLHotTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton    *locationBtn;
@property (weak, nonatomic) IBOutlet UILabel     *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *startView;
@property (weak, nonatomic) IBOutlet UILabel     *fansLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomid;

@property (weak, nonatomic) IBOutlet UILabel *signatures;
- (IBAction)share;
@end



@implementation XLHotTableViewCell

+ (instancetype)tableViewCell
{
       return [[[NSBundle mainBundle] loadNibNamed:@"XLHotTableViewCell" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
        self.headImageView.layer.cornerRadius  = self.headImageView.height * 0.5;
        self.headImageView.layer.masksToBounds = YES;

}

- (void)setHotModel:(XLHotModel *)hotModel
{
    _hotModel = hotModel;
    
    __weak typeof(self) weakSelf = self;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:hotModel.smallpic] placeholderImage:[UIImage imageNamed:@"placeholder_head"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    
        weakSelf.headImageView.image  = [UIImage  circleImage:image borderColor:[UIColor clearColor] borderWidth:1];
      
    }];
    
    [self.headImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerImage:)]];
    
    
    self.nameLabel.text = hotModel.myname;
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
    
    // 如果没有地址, 给个默认的地址
    if (!hotModel.gps.length) {
        hotModel.gps = @"上海";
    }
    
    [self.locationBtn setTitle:hotModel.gps forState:UIControlStateNormal];
    [self.bigPicView sd_setImageWithURL:[NSURL URLWithString:hotModel.bigpic] placeholderImage:[UIImage imageNamed:@"profile_user_414x414"]];

    
    self.startView.image  = hotModel.starImage;
    self.startView.hidden = !hotModel.starlevel;
    
    
    // 设置当前观众数量
    NSString *fullfans = [NSString stringWithFormat:@"%@人在看", hotModel.allnum];
    NSRange range = [fullfans rangeOfString:[NSString stringWithFormat:@"%@", hotModel.allnum]];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:fullfans];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range: range];
    [attr addAttribute:NSForegroundColorAttributeName value:XLBasicColor range:range];
    self.fansLabel.attributedText = attr;
    self.fansLabel.adjustsFontSizeToFitWidth = YES;
 
    self.roomid.text = [NSString stringWithFormat:@"房间号：%@",hotModel.roomid];
    self.signatures.text = hotModel.signatures;
}

- (IBAction)share {
    
        NSString *text = [NSString stringWithFormat:@"  主播昵称：%@\n  主播房间号：%@\n  个性签名：%@\n  在线粉丝数：%@",_hotModel.myname, _hotModel.roomid, _hotModel.signatures, _hotModel.allnum];
        
        UIImage *image = self.bigPicView.image;
        
        [UMSocialSnsService presentSnsIconSheetView:self.parentVC appKey:UmengAppkey shareText:text shareImage:image shareToSnsNames:nil delegate:nil];
}

- (void)headerImage:(UIGestureRecognizer *)ges
{
    XLUserInfoView *userInfoView = [XLUserInfoView userInfoView];
    UIImageView *imageView = (UIImageView *)ges.view;
    
    userInfoView.image = imageView.image;
    
    [userInfoView userWithHotModel:_hotModel ofView:self.parentVC.view];
    __weak typeof(self) weakSelf = self;
    
    [userInfoView setSelectedBlock:^{
       
        
        XLWatchLiveViewController *watch = [[XLWatchLiveViewController alloc] init];
        
        
        
        watch.hotModel = _hotModel;
        watch.allModels = weakSelf.allModels;
        
        [weakSelf.parentVC presentViewController:watch animated:YES completion:nil];
    }];
}

- (CGFloat)height
{
    
    return self.bigPicView.height + self.bigPicView.y;
}


@end
