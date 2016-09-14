
//
//  XLCatEarView.m
//  XLMiaoBo
//
//  Created by XuLi on 16/8/31.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import "XLCatEarView.h"


@interface XLCatEarView ()

@property (weak, nonatomic) IBOutlet UIView *playView;
/** 直播播放器 */
@property (nonatomic, strong) IJKFFMoviePlayerController *moviePlayer;
@end

@implementation XLCatEarView
+ (instancetype)catEarView
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject ;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.playView.layer.cornerRadius = self.playView.height * 0.5;
    self.playView.layer.masksToBounds = YES;
}

- (void)setHotModel:(XLHotModel *)hotModel
{
    _hotModel = hotModel;
    
    // 设置只播放视频, 不播放声音
    // github详解: https://github.com/Bilibili/ijkplayer/issues/1491#issuecomment-226714613
    
    IJKFFOptions *option = [IJKFFOptions optionsByDefault];
    [option setPlayerOptionValue:@"1" forKey:@"an"];
    // 开启硬解码
    [option setPlayerOptionValue:@"1" forKey:@"videotoolbox"];
    IJKFFMoviePlayerController *moviePlayer = [[IJKFFMoviePlayerController alloc] initWithContentURLString:hotModel.flv withOptions:option];
    
    moviePlayer.view.frame = self.playView.bounds;
    // 填充fill
    moviePlayer.scalingMode = IJKMPMovieScalingModeAspectFill;
    // 设置自动播放
    moviePlayer.shouldAutoplay = YES;
    
    [self.playView addSubview:moviePlayer.view];
    
    [moviePlayer prepareToPlay];
    self.moviePlayer = moviePlayer;
    
}


- (void)removeFromSuperview
{
    if (_moviePlayer) {
        
        [self.moviePlayer pause];
        [self.moviePlayer stop];
        [self.moviePlayer shutdown];
        [self.moviePlayer.view removeFromSuperview];
        self.moviePlayer = nil;

    }
    [super removeFromSuperview];
}

/*
 //改进
 //[options setPlayerOptionIntValue:0 forKey:@"no-time-adjust"];
 //[options setPlayerOptionIntValue:1 forKey:@"audio_disable"];
 //[options setPlayerOptionIntValue:1 forKey:@"infbuf"];
 //[options setPlayerOptionIntValue:0 forKey:@"framedrop"];
 
 //videotoolbox 配置（硬件解码）
 [options setPlayerOptionIntValue:1  forKey:@"videotoolbox"];
 
 
 [options setPlayerOptionIntValue:30     forKey:@"max-fps"];
 [options setPlayerOptionIntValue:0      forKey:@"framedrop"];
 [options setPlayerOptionIntValue:3      forKey:@"video-pictq-size"];
 [options setPlayerOptionIntValue:0      forKey:@"videotoolbox"];
 [options setPlayerOptionIntValue:960    forKey:@"videotoolbox-max-frame-width"];
 
 [options setFormatOptionIntValue:0                  forKey:@"auto_convert"];
 [options setFormatOptionIntValue:1                  forKey:@"reconnect"];
 [options setFormatOptionIntValue:30 * 1000 * 1000   forKey:@"timeout"];
 [options setFormatOptionValue:@"ijkplayer"          forKey:@"user-agent"];
 
 */


@end
