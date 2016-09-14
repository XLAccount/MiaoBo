//
//  XLWaveView.h
//  XLMiaoBo
//
//  Created by XuLi on 16/9/11.
//  Copyright © 2016年 XuLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLWaveView : UIImageView

- (instancetype)initWithFrame:(CGRect)frame Image:(NSString *)imageName centerIcon:(NSString *)icon;

- (void)starWave;
- (void)stopWave;


@end
