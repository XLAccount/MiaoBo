
//
//  XLCrownRankViewController.m
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import "XLCrownRankViewController.h"

@interface XLCrownRankViewController ()


@end

@implementation XLCrownRankViewController

- (UIWebView *)webView
{
    if (_webView == nil){
        
        UIWebView *webView = [[UIWebView alloc] init];
        
        [self.view addSubview:webView];
        
        [webView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.width.equalTo(self.view);
            make.height.equalTo(self.view);
            make.center.equalTo(self.view);
        }];
        
        _webView = webView;
    }
    return _webView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    
    [self.webView loadRequest:request];
}

@end
