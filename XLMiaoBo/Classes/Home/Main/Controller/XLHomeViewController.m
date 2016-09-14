//
//  XLHomeViewController.m
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import "XLHomeViewController.h"
#import "XLCustomScrollView.h"
#import "XLCrownRankViewController.h"
#import "XLCustomTitleView.h"
#import "UIButton+Extension.h"
#import "XLSearchViewController.h"

@interface XLHomeViewController ()<UIScrollViewDelegate>

@property (nonatomic, weak) XLCustomScrollView *scrollView;

@property (nonatomic, weak) XLCustomTitleView *titleview;
@end



@implementation XLHomeViewController

- (XLCustomTitleView *)titleview
{
    if (_titleview == nil){
    
        XLCustomTitleView *titleView = [[XLCustomTitleView alloc] initWithFrame:CGRectMake(0, 0, XLScreenW * 0.5, 40)];
        
        //点击按钮移动scrollView
        [titleView setSelectedBlock:^(Type tag) {
           
            
            
            [UIView animateWithDuration:0.2 animations:^{
                
                self.scrollView.contentOffset = CGPointMake(tag * XLScreenW, 0);
            }];
        }];
        
        self.navigationItem.titleView = titleView;
        
        _titleview = titleView;
    }
    return _titleview;
}

-  (XLCustomScrollView *)scrollView
{
    if (_scrollView == nil){
        
        XLCustomScrollView *scrollView = [[XLCustomScrollView alloc] init];
        
        scrollView.vc = self;
        scrollView.delegate = self;
        self.view = scrollView;
        
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [UIButton show];
    [self setupBasic];
}

- (void)setupBasic
{
    [self titleview];
    [self scrollView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search_15x14"] style:UIBarButtonItemStyleDone target:self action:@selector(search)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"head_crown_24x24"] style:UIBarButtonItemStyleDone target:self action:@selector(crownRank)];
}

- (void)search
{
    XLSearchViewController *search = [[XLSearchViewController alloc] init];
    
    search.title = @"搜索";
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(40, 60, self.view.width - 80, 30)];
    
    [search.view addSubview:searchBar];
    
    [self.navigationController pushViewController:search animated:YES];
}

- (void)crownRank
{
    XLCrownRankViewController *crownRank = [[XLCrownRankViewController alloc] init];
    
    crownRank.title = @"排行榜";
    crownRank.urlStr = @"http://live.9158.com/Rank/WeekRank?Random=10";
    
    [self.navigationController pushViewController:crownRank animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    
    //屏幕宽度除以两个中心点之间的距离得到百分比
    CGFloat scale = XLScreenW / ((self.titleview.width - 36) / 2);
    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x,  0);
    //18是第一次中心点的坐标因为是以中心点去的点所以每次都要加上，第一次中心点坐标为零
    self.titleview.underLine.centerX = self.scrollView.contentOffset.x / scale + 18;
    
    self.titleview.type = self.scrollView.contentOffset.x / XLScreenW + 0.5;
    
    self.scrollView.contenOffsetX = self.scrollView.contentOffset.x;
}


@end
