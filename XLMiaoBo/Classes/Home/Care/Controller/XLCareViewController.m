//
//  XLCareViewController.m
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import "XLCareViewController.h"
#import "XLDealData.h"
#import "XLCollectionViewCell.h"
#import "XLCoverView.h"
#import "XLWatchLiveViewController.h"

@interface XLCareViewController ()

@property (nonatomic, strong) NSMutableArray *allModels;

@property (nonatomic, weak) XLCoverView *coverView;

@end

static NSString *reuseID = @"cell";
@implementation XLCareViewController


- (XLCoverView *)coverView
{
    if (_coverView == nil){
    
        XLCoverView *cover = [XLCoverView coverView];
        
        cover.contentMode = UIViewContentModeScaleToFill;
        
        cover.frame = self.collectionView.bounds;
        [self.view insertSubview:cover aboveSubview:self.collectionView];
        
        _coverView = cover;
    }
    return _coverView;
}

- (NSMutableArray *)allModels
{
    if (_allModels == nil){
    
        _allModels = [NSMutableArray arrayWithArray:[XLDealData shareDealData].allModels];
        
    }
    return _allModels;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    self.allModels = [XLDealData shareDealData].allModels;
    
    [self.collectionView reloadData];
}

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat margin = 10;
    
    CGFloat WH = (XLScreenW - margin * 3) / 2;
    layout.itemSize = CGSizeMake(WH, WH);
    
    layout.minimumLineSpacing = margin;
    layout.minimumInteritemSpacing = margin;
    
    layout.collectionView.showsVerticalScrollIndicator = NO;
    layout.collectionView.showsHorizontalScrollIndicator = NO;
    layout.collectionView.alwaysBounceVertical = YES;
    
    layout.sectionInset = UIEdgeInsetsMake(margin, margin, margin, margin);
    
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
    }];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"XLCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseID];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.coverView.hidden = self.allModels.count != 0;
    return self.allModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    
    cell.layer.cornerRadius = 20;
    cell.layer.masksToBounds = YES;
    
    cell.hotModel = self.allModels[indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XLWatchLiveViewController *watch = [[XLWatchLiveViewController alloc] init];
    
    watch.hotModel = self.allModels[indexPath.item];
    
    watch.allModels = self.allModels;
    
    [self presentViewController:watch animated:YES completion:nil];
}

@end
