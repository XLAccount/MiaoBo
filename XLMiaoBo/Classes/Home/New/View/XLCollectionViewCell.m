
//
//  XLCollectionViewCell.m
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import "XLCollectionViewCell.h"

@interface XLCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UIImageView *star;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomID;

@end

@implementation XLCollectionViewCell

+ (instancetype)collectionview
{
    return [[[NSBundle mainBundle] loadNibNamed:@"XLCollectionViewCell" owner:nil options:nil] lastObject];
}

- (void)setStarModel:(XLNewModel *)starModel
{
    _starModel = starModel;
    
    // 设置封面头像
    [_coverView sd_setImageWithURL:[NSURL URLWithString:starModel.photo] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    // 是否是新主播
    self.star.hidden = !starModel.newStar;
    // 地址
    [self.locationBtn setTitle:starModel.position forState:UIControlStateNormal];
    // 主播名
    self.nickNameLabel.text = starModel.nickname;
    self.roomID.text = [NSString stringWithFormat:@"房间号：%@",starModel.roomid];

}

- (void)setHotModel:(XLHotModel *)hotModel
{
    _hotModel = hotModel;
    
    // 设置封面头像
    [_coverView sd_setImageWithURL:[NSURL URLWithString:hotModel.bigpic] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];

    // 地址
    [self.locationBtn setTitle:hotModel.gps forState:UIControlStateNormal];
    // 主播名
    self.nickNameLabel.text = hotModel.myname;
    self.roomID.text = [NSString stringWithFormat:@"房间号：%@",hotModel.roomid];
}
@end
