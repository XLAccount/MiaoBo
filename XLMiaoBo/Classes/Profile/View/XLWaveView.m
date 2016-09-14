



//
//  XLWaveView.m
//  XLMiaoBo
//
//  Created by XuLi on 16/9/11.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import "XLWaveView.h"

@interface XLWaveView ()

/**
 *  波纹的振幅   amplitude （振幅）
 */
@property (nonatomic, assign) CGFloat waveAmplitude;

/**
 *  波纹的传播周期  单位s    period (周期)
 */
@property (nonatomic, assign) CGFloat wavePeriod;

/**
 *  波纹的长度
 */
@property (nonatomic, assign) CGFloat waveLength;

/** 偏移量 */
@property (nonatomic, assign) CGFloat offsetX;
/** 定时器 */
@property (nonatomic, strong) CADisplayLink *link;
/** 形状视图 */
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
/** 头像 */
@property (nonatomic, assign) UIImageView *icon;

/** 标签文字 */
@property (nonatomic, weak) UILabel *nameLabel;

/** 设置按钮 */
@property (nonatomic,weak) UIButton *setBtn;
@end

@implementation XLWaveView

- (UIButton *)setBtn
{
    if (_setBtn == nil){
    
        UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        setBtn.image = @"MoreSetting";
        
        [setBtn sizeToFit];
        
        [self addSubview:setBtn];
        
        [setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
//            make.trailing.equalTo(self.superview.superview.mas_right).offset(-50);
//            make.top.equalTo(self.superview.superview.mas_top).offset(60);
        }];
        
        _setBtn = setBtn;
    }
    return _setBtn;
}

- (UILabel *)nameLabel
{
    if (_nameLabel == nil){
        
        UILabel *nameLabel = [[UILabel alloc] init];
        
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.numberOfLines = 0;
        
        nameLabel.text = @"昵称";
        nameLabel.textColor = [UIColor whiteColor];
        
        [self addSubview:nameLabel];
        
        __weak typeof(self) weakSelf = self;
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(300);
            
            make.height.mas_equalTo([nameLabel.text sizeWithAttributes:@{NSFontAttributeName : nameLabel.font}].height);
            
            make.top.equalTo(weakSelf.icon.mas_bottom).offset(0);
            
            make.centerX.equalTo(weakSelf);
            
        }];
        
        _nameLabel = nameLabel;
    }
    
    return _nameLabel;
}


- (UIImageView *)icon
{
    if (_icon == nil){
    
        UIImageView *icon = [[UIImageView alloc] init];
        
        icon.height = icon.width = 80;
        icon.layer.cornerRadius = icon.width * 0.5;
        icon.layer.masksToBounds = YES;
        
        icon.contentMode = UIViewContentModeScaleAspectFill;
        
        [self addSubview:icon];
        
        __weak typeof(self) weakSelf = self;
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.width.equalTo(@80);
            make.centerX.equalTo(weakSelf);
            make.bottom.equalTo(weakSelf.mas_bottom).offset(-40);
            
        }];
        
        _icon = icon;
    }
    return _icon;
}


- (instancetype)initWithFrame:(CGRect)frame Image:(NSString *)imageName centerIcon:(NSString *)icon
{
    self = [super initWithFrame:frame];
    if (self){
    
    self.contentMode = UIViewContentModeScaleToFill;
        [self setBtn];
    self.image = [UIImage imageNamed:imageName];
    self.icon.image = [UIImage imageNamed:icon];
    self.nameLabel.text = @"iOS技术交流群：528243317";
        
        self.wavePeriod = 1;
        self.waveLength = XLScreenW;
    }
    return self;
}

- (void)starWave {
    
    self.waveAmplitude = 6.0;
    self.shapeLayer = [CAShapeLayer layer];
    [self.layer addSublayer:self.shapeLayer];
    self.shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    //【**波动画关键**】 一秒执行60次（算是CADisplayLink特性），即每一秒执行 setShapeLayerPath 方法60次
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(setShapeLayerPath)];
    
    
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
}

- (void)setShapeLayerPath {
    
    // 振幅不断减小，波执行完后为0 （使波浪更逼真些）
    self.waveAmplitude -= 0.02; // 2s 后为0
    
    if (self.waveAmplitude < 0.1) {
        [self stopWave];
    }
    
    // 每次执行画的正玄线平移一小段距离 （SCREEN_W / 60 / wavePeriod，1s执行60次，传播周期为wavePeriod,所以每个波传播一个屏幕的距离） 从而形成波在传播的效果
    
    self.offsetX += (XLScreenW / 60 / self.wavePeriod);
    _shapeLayer.path = [[self currentWavePath] CGPath];
}


// UIBezierPath 画线
- (UIBezierPath *)currentWavePath {
    
    UIBezierPath *p = [UIBezierPath bezierPath];
    CGMutablePathRef path = CGPathCreateMutable();
    
    // 设置线宽
    p.lineWidth = 2.0;
    
    CGPathMoveToPoint(path, nil, 0, self.height);
    CGFloat y = 0.0f;
    
    for (float x = 0.0f; x <= XLScreenW * 2; x++) {
        
        /**
         * *** 正玄波的基础知识  ***
         *
         *  f(x) = Asin(ωx+φ)+k
         *
         *  A    为振幅, 波在上下振动时的最大偏移
         *
         *  φ/w  为在x方向平移距离
         *
         *  k    y轴偏移，即波的振动中心线y坐标与x轴的偏移距离
         *
         *  2π/ω 即为波长，若波长为屏幕宽度即， SCREEN_W = 2π/ω, ω = 2π/SCREEN_W
         */
        
        y = _waveAmplitude * sinf((2 * M_PI / _waveLength) * (x + _offsetX + _waveLength / 12)) + self.height - _waveAmplitude;
        
        // A = waveAmplitude  w = (2 * M_PI / waveLength) φ = (waveLength / 12) / (2 * M_PI / waveLength) k = headHeight - waveAmplitude （注意：坐标轴是一左上角为原点的）
        CGPathAddLineToPoint(path, nil, x, y);
        
    }
    
    CGPathAddLineToPoint(path, nil, XLScreenW, self.height);
    CGPathCloseSubpath(path);
    p.CGPath = path;
    CGPathRelease(path);
    return p;
}

- (void)stopWave {
    
    [self.shapeLayer removeFromSuperlayer];
    [self.link invalidate];
    self.link = nil;
}

@end
