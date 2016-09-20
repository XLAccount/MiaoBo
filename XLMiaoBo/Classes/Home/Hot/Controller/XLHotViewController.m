//
//  XLHotViewController.m
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import "XLHotViewController.h"
#import "XLHotTableViewCell.h"
#import "XLHotHeaderView.h"
#import "XLLiveTool.h"
#import "XLHotData.h"
#import "XLHotModel.h"
#import "XLHotHeaderModel.h"
#import "XLWatchLiveViewController.h"
#import "XLCrownRankViewController.h"

@interface XLHotViewController ()<UITableViewDelegate,UITableViewDataSource>
/** 当前页 */
@property(nonatomic, assign) NSUInteger currentPage;
/** 直播 */
@property(nonatomic, strong) NSMutableArray *allModels;


/** 返回数据 */
@property (nonatomic, strong) XLHotData *hotData;

@property (nonatomic, strong) NSArray *imageArray;


@property (nonatomic, weak) UIScrollView *bgScrollView;

@property (nonatomic, weak) XLHotHeaderView *headerView;

@property (nonatomic, weak) UITableView *tableView;

@end

static NSString *reuseIdentifier = @"cell";
@implementation XLHotViewController

- (UIScrollView *)bgScrollView
{
    if (_bgScrollView == nil){
    
        UIScrollView *bgScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        
        bgScrollView.backgroundColor = [UIColor whiteColor];
        
        self.view = bgScrollView;
        
        _bgScrollView = bgScrollView;
    }
    return _bgScrollView;
}

- (UITableView *)tableView
{
    if (_tableView == nil){
    
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), XLScreenW, XLScreenH - self.headerView.height)];
        
        
        tableView.dataSource = self;
        tableView.delegate = self;
        
        tableView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:tableView];
        
        _tableView = tableView;
    }
    return _tableView;
}

- (XLHotHeaderView *)headerView
{
    if (_headerView == nil){
    
        XLHotHeaderView *headerView = [[XLHotHeaderView alloc] initWithFrame:CGRectMake(0, 0, XLScreenW, 100)];
        
        
        [headerView setImageClickBlock:^(XLHotHeaderModel *headerModel) {
            
            XLCrownRankViewController *web = [[XLCrownRankViewController alloc] init];
            
            if (headerModel.link.length){
                
                web.title = headerModel.title;
                web.urlStr = headerModel.link;
                
                [self.navigationController pushViewController:web animated:YES];
                
            }
        }];

        
        _tableView.tableHeaderView = headerView;
        
        _headerView = headerView;
    }
    return _headerView;
}

- (NSArray *)imageArray
{
    if (_imageArray == nil){
    
        _imageArray = @[[UIImage imageNamed:@"reflesh1_60x55"], [UIImage imageNamed:@"reflesh2_60x55"], [UIImage imageNamed:@"reflesh3_60x55"]];
    }
    return _imageArray;
}



- (NSMutableArray *)allModels
{
    if (_allModels == nil) {
        _allModels = [NSMutableArray array];

    }
    return _allModels;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self headerView];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self refresh];
    
    //注册Cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XLHotTableViewCell class]) bundle:nil] forCellReuseIdentifier:
     reuseIdentifier];
   
}

- (void)refresh
{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
     
        self.currentPage = 1;
        
        // 获取顶部的广告
        [self loadHeaderData];
        [self loadNewData];
        
    }];
    
    self.bgScrollView.mj_header = header;
    
    [header setImages:self.imageArray  forState:MJRefreshStateRefreshing];
    [header setImages:self.imageArray  forState:MJRefreshStatePulling];
    [header setImages:self.imageArray  forState:MJRefreshStateIdle];

    
    
    
    self.bgScrollView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.currentPage++;
        [self loadHeaderData];
        [self loadNewData];
        
        
    }];
    
    
    [self.bgScrollView.mj_header beginRefreshing];

    
}

- (void)loadHeaderData
{
    
    __weak typeof(self) weakSelf = self;
    [XLLiveTool GetWithSuccess:^(XLHotHeaderResult *result) {
       
        [weakSelf.bgScrollView.mj_header endRefreshing];
        [weakSelf.bgScrollView.mj_footer endRefreshing];
    
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            weakSelf.headerView.headerModels = result.data;
        });
        
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showAlertMessage:@"网络异常"];
    }];
    
}

- (void)loadNewData
{
    __weak typeof(self) weakSelf = self;
    [XLLiveTool GetWithHotURL:self.currentPage success:^(XLNewResult *result) {
        
        if (weakSelf.currentPage == 1){
            [weakSelf.allModels removeAllObjects];
        }
        
        XLHotData *hotData = [XLHotData mj_objectWithKeyValues:result.data];
        weakSelf.hotData = hotData;
        
        [weakSelf.bgScrollView.mj_header endRefreshing];
        [weakSelf.bgScrollView.mj_footer endRefreshing];
        
        if (hotData.list){
            
            [weakSelf.allModels addObjectsFromArray:hotData.list];
            
            
                           //重新加载
                [weakSelf.tableView reloadData];
            
        }else{
            
            [MBProgressHUD showAlertMessage:@"暂时没有更多的数据"];
            
            weakSelf.currentPage--;
        }
        
    } failure:^(NSError *error) {
        
        [weakSelf.bgScrollView.mj_header endRefreshing];
        [weakSelf.bgScrollView.mj_footer endRefreshing];
        weakSelf.currentPage--;
        
        [MBProgressHUD showAlertMessage:@"网络异常"];
    }];

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
         return self.allModels.count;
    

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    XLHotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
        XLHotModel *hotModel = self.allModels[indexPath.item];
    
            
        cell.hotModel = hotModel;
        cell.allModels = self.hotData.list;
        cell.parentVC = self;
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XLHotTableViewCell *cell = [XLHotTableViewCell tableViewCell];
    
        
    cell.hotModel = self.allModels[indexPath.item];

    
    return cell.height;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    XLWatchLiveViewController *watch = [[XLWatchLiveViewController alloc] init];
    
    XLHotModel *hotModel = self.allModels[indexPath.item];
    
    XLHotTableViewCell *cell = [XLHotTableViewCell tableViewCell];
    cell.hotModel = hotModel;
    watch.image = cell.bigPicView.image;
    
    watch.hotModel = hotModel;
    watch.allModels = self.hotData.list;

    
    [self presentViewController:watch animated:YES completion:nil];
}

@end
