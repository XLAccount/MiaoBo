//
//  XLNewViewController.m
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import "XLNewViewController.h"
#import "XLNewData.h"
#import "XLNewModel.h"
#import "XLLiveTool.h"
#import "XLHotData.h"
#import "XLWatchLiveViewController.h"
#import "XLCollectionViewCell.h"


@interface XLNewViewController ()

/** 最新主播列表 */
@property(nonatomic, strong) NSMutableArray *allModels;
/** 当前页 */
@property(nonatomic, assign) NSUInteger currentPage;
/** NSTimer */
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) XLNewData *starData;

@property (nonatomic, strong) NSArray *imageArray;
@end


static NSString *reuseID = @"cell";
@implementation XLNewViewController


- (NSArray *)imageArray
{
    if (_imageArray == nil){
        
        _imageArray = @[[UIImage imageNamed:@"reflesh1_60x55"], [UIImage imageNamed:@"reflesh2_60x55"], [UIImage imageNamed:@"reflesh3_60x55"]];
    }
    return _imageArray;
}


- (NSMutableArray *)allModels
{
    if (_allModels ==  nil){
    
        _allModels = [NSMutableArray array];
    }
    
    return _allModels;
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
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"XLCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseID];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 * 60 target:self selector:@selector(setupBasic) userInfo:nil repeats:YES];
    
    [self setupBasic];
}

- (void)setupBasic
{
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{

        
        self.currentPage = 1;
        
        [self loadNewData];

    }];
                                  
    self.collectionView.mj_header = header;
    
    [header setImages:self.imageArray  forState:MJRefreshStateRefreshing];
    [header setImages:self.imageArray  forState:MJRefreshStatePulling];
    [header setImages:self.imageArray  forState:MJRefreshStateIdle];
    
    
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.currentPage++;
        
        [self loadNewData];
        
    }];
    
    
    [self.collectionView.mj_header beginRefreshing];
    

}

- (void)loadNewData
{
    [XLLiveTool GetWithNewURL:self.currentPage success:^(XLNewResult *result) {
        
        
        if (self.currentPage == 1){
            
             [self.allModels removeAllObjects];
        }
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        if ([result.msg isEqualToString:@"fail"]){
            
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            [MBProgressHUD showAlertMessage:@"暂时没有数据更新"];
            
            self.currentPage--;
        }else{
            
            XLNewData *newData = [XLNewData mj_objectWithKeyValues:result.data];
            
            self.starData = newData;
   
            
            [self.allModels addObjectsFromArray:newData.list];
            
            [self.collectionView reloadData];
        }
        
        
    } failure:^(NSError *error) {
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        self.currentPage--;
        [MBProgressHUD showError:@"加载数据失败"];

    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.allModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    
    cell.starModel = self.allModels[indexPath.item];
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XLWatchLiveViewController *watch = [[XLWatchLiveViewController alloc] init];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (XLNewModel *newModel in self.starData.list) {
        
        XLHotModel *hotModel = [[XLHotModel alloc] init];
        hotModel.bigpic = newModel.photo;
        hotModel.myname = newModel.nickname;
        hotModel.smallpic = newModel.photo;
        hotModel.gps = newModel.position;
        hotModel.useridx = newModel.useridx;
        hotModel.allnum = @(arc4random_uniform(2000));
        hotModel.flv = newModel.flv;
        hotModel.roomid = newModel.roomid;
        
        [array addObject:hotModel];
    }
    
    
    
       NSMutableArray *array1 = [NSMutableArray array];
    [self.allModels enumerateObjectsUsingBlock:^(XLNewModel *newModel, NSUInteger idx, BOOL * _Nonnull stop) {
       
        XLHotModel *hotModel = [[XLHotModel alloc] init];
        hotModel.bigpic = newModel.photo;
        hotModel.myname = newModel.nickname;
        hotModel.smallpic = newModel.photo;
        hotModel.gps = newModel.position;
        hotModel.useridx = newModel.useridx;
        hotModel.allnum = @(arc4random_uniform(2000));
        hotModel.flv = newModel.flv;
        hotModel.roomid = newModel.roomid;
        
        [array1 addObject:hotModel];
    }];
    
    watch.hotModel = array1[indexPath.item];
    watch.allModels = array;
    
    [self presentViewController:watch animated:YES completion:nil];
}



@end
