//
//  XLLoginViewController.m
//  XLMiaoBo
// 
//  Created by XuLi on 16/8/30.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import "XLLoginViewController.h"
#import "XLThirdLoginView.h"
#import "XLTabBarViewController.h"
#import "UMSocial.h"
#import "XLCrownRankViewController.h"
#import "XLNavigationController.h"
#import "UIBarButtonItem+XL.h"


#define XLREQUEST @"https://api.weibo.com/oauth2/authorize?client_id=2039393085&redirect_uri=http://www.code4app.com/space-uid-843201.html"



@interface XLLoginViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) IJKFFMoviePlayerController *player;
/** 封面图片 */
@property (nonatomic, weak) UIImageView *coverView;
/** 第三方登录 */
@property (nonatomic, weak) XLThirdLoginView *thirdView;
/** 快速登录 */
@property (nonatomic, weak) UIButton *loginBtn;

/** 新浪授权页面 */
@property (nonatomic, strong) XLCrownRankViewController *sina;
@property (nonatomic, strong) XLNavigationController *nav;

@end

@implementation XLLoginViewController


- (UIButton *)loginBtn
{
    if (_loginBtn == nil){
    
        UIButton *loginBtn = [[UIButton alloc] init];
        
        loginBtn.backgroundColor = [UIColor clearColor];
        loginBtn.titleColor = XLBasicColor;
        loginBtn.title = @"快速登录";
        loginBtn.layer.borderWidth = 1;
        loginBtn.layer.borderColor = XLBasicColor.CGColor;
        loginBtn.highlightedTitleColor = [UIColor redColor];
        
        
        [loginBtn addTarget:self action:@selector(loginClick)];
        
        [self.view addSubview:loginBtn];
        
        [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@40);
            make.right.equalTo(@-40);
            make.centerX.mas_equalTo(XLScreenW * 0.5);
            make.height.equalTo(@40);
            make.bottom.equalTo(self.view).offset(-60);
        }];
        
    
        
        _loginBtn = loginBtn;
    }
    return _loginBtn;
}

- (XLThirdLoginView *)thirdView
{
    if (_thirdView == nil){
    
        XLThirdLoginView *thirdView = [[XLThirdLoginView alloc] initWithFrame:CGRectMake(0, 0, XLScreenW, 60)];
        
         __weak typeof(self) weakSelf = self;
        [thirdView setSelectedBlock:^(XLType type) {
           
            weakSelf.coverView.hidden = YES;
            
            [self.coverView removeFromSuperview];
            weakSelf.coverView = nil;
            
            switch (type) {
                case sina:
                    
                    [weakSelf sinaMethod];
                    break;
                
                case qq:
                    
                    [weakSelf qq];
                    break;
                    
                case weixin:
                    
                    [weakSelf weixin];
                    break;
                default:
                    break;
            }
            
        }];
        
        
        [self.view addSubview:thirdView];
        
        
        thirdView.y = self.view.height - 40 - 60 - 60 - 30;

        
            _thirdView = thirdView;
    }
    return _thirdView;
}

- (IJKFFMoviePlayerController *)player
{
    if (_player == nil){
        
        NSString *path = arc4random_uniform(2) ? @"login_video" : @"loginmovie";
        
        _player = [[IJKFFMoviePlayerController alloc] initWithContentURLString:[[NSBundle mainBundle] pathForResource:path ofType:@"mp4"] withOptions:[IJKFFOptions optionsByDefault]];
     
        _player.view.frame = self.view.bounds;
        _player.scalingMode = IJKMPMovieScalingModeAspectFill;
        _player.shouldAutoplay = NO;
        [_player prepareToPlay];
        
        [self.view addSubview:_player.view];
        
    }
    
    return _player;
}

- (UIImageView *)coverView
{
    if (_coverView == nil) {
        UIImageView *cover = [[UIImageView alloc] initWithFrame:self.view.bounds];
        cover.image = [UIImage imageNamed:@"LaunchImage"];
        [self.player.view addSubview:cover];
        _coverView = cover;
    }
    return _coverView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self notificationOfPlayer];
    [self coverView];
}

- (void)notificationOfPlayer
{
    // 监听视频是否播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinish) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateDidChange) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:nil];
}

- (void)stateDidChange
{
     __weak typeof(self) weakSelf = self;
    if ((self.player.loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        if (!self.player.isPlaying) {
            
            [self.view insertSubview:self.coverView atIndex:0];
            [self.player play];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.thirdView.hidden = NO;
                weakSelf.loginBtn.hidden = NO;
            });
        }
    }
}

- (void)didFinish
{
    // 播放完之后, 继续重播
    [self.player play];
}

- (void)loginClick
{
    [MBProgressHUD showMessage:@"登录中..."];
    
    
    [self jump];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.player  play];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.player pause];
}



- (void)back
{
    [self.sina dismissViewControllerAnimated:YES completion:nil];
    [MBProgressHUD showAlertMessage:@"取消授权"];
}

/** 新浪 */
- (void)sinaMethod
{
   
    XLCrownRankViewController *sina = [[XLCrownRankViewController alloc] init];
    self.sina = sina;
    
    sina.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImage:@"back_9x16" highlightImage:nil targer:self action:@selector(back)];
    
    sina.urlStr = XLREQUEST;
    sina.title = @"新浪授权登录";
    
    XLNavigationController *nav = [[XLNavigationController alloc] initWithRootViewController:sina];


    [MBProgressHUD showMessage:@"正在加载..." toView:sina.view];
            sina.webView.delegate = self;
    [self presentViewController:nav animated:YES completion:nil];
    
}


/** 微信 */
- (void)weixin
{
     __weak typeof(self) weakSelf = self;
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //   获取用户名、uid、token
        if (response.responseCode == UMSResponseCodeSuccess) {
//            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToWechatTimeline];
//            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            //获取accestoken以及QQ用户信息，得到的数据在回调Block对象形参respone的data属性
            [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina  completion:^(UMSocialResponseEntity *response){
                
                [MBProgressHUD showSuccess:@"登陆成功"];
                
                [weakSelf jump];
            }];
        }});

}

/** qq */
- (void)qq
{
    UMSocialSnsPlatform * snsPlatform= [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
     __weak typeof(self) weakSelf = self;
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //   获取微博用户名、uid、token
        if (response.responseCode == UMSResponseCodeSuccess) {
//            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
//            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            //获取accestoken以及QQ用户信息，得到的数据在回调Block对象形参respone的data属性
            [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
                
                [MBProgressHUD showSuccess:@"登陆成功"];
                
                [weakSelf jump];
                
                }];
        }});

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.sina.view];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.sina.view];
    [MBProgressHUD showError:@"加载失败，请检查网络是否通畅" toView:self.sina.view];
}

#pragma mark 拦截webView扥所有请求
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    //1. 获得全路径
    NSString *urlStr=request.URL.absoluteString;
    
    //2. 获得范围
    NSRange range=[urlStr rangeOfString:@"code="];
    //3. 跳到回调地址，授权成功,截取请求标记
    if (range.length>0) {
        NSString *requestToken=[urlStr substringFromIndex:range.location+range.length];
        //4.获得访问标记
        
        
        [self getAccessToken:requestToken];
        
        return NO;
    }
    
    return  YES;
}
#pragma mark 获得AccessToken
-(void)getAccessToken:(NSString *)requestToken{
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSString *urlStr= @"https://api.weibo.com/oauth2/access_token?";
    NSURL *url=[NSURL URLWithString:urlStr];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    
    request.HTTPMethod = @"POST";
    
    NSString *Str = [NSString stringWithFormat:@"client_id=2039393085&client_secret=7da7d4501f3f51a14040e1fa5eca7723&grant_type=authorization_code&redirect_uri=http://www.code4app.com/space-uid-843201.html&code=%@",requestToken];
  
    
    request.HTTPBody = [Str dataUsingEncoding:NSUTF8StringEncoding];

    
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      
        [MBProgressHUD hideHUD];
        
        if (error) {
        
            [MBProgressHUD showAlertMessage:@"授权失败"];
            return;
        }else{
            
            [self.sina dismissViewControllerAnimated:YES completion:nil];
        }
        
        
        [self jump];
        
    }];
    
    [task resume];
    
    
    
}

/** 登陆成功之后跳转 */
- (void)jump
{
    XLTabBarViewController *tab = [[XLTabBarViewController alloc] init];
    
    __weak typeof(self) weakSelf = self;
    //一秒之后跳转
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"登陆成功"];
        
        [self presentViewController:tab animated:YES completion:^{
            
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            
            [weakSelf.player pause];
            [weakSelf.player stop];
            [weakSelf.player shutdown];
            [weakSelf.player.view removeFromSuperview];
            weakSelf.player = nil;
            
            [weakSelf.thirdView removeFromSuperview];
            weakSelf.thirdView = nil;
        }];
    });
    
}


@end
