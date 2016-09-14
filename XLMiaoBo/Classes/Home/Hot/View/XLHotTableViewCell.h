//
//  XLHotTableViewCell.h
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XLHotModel;
@interface XLHotTableViewCell : UITableViewCell

@property (nonatomic, strong) XLHotModel *hotModel;
@property (nonatomic, strong) NSArray *allModels;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) UIViewController *parentVC;

@property (weak, nonatomic) IBOutlet UIImageView *bigPicView;
+ (instancetype)tableViewCell;
@end
