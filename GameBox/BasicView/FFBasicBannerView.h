//
//  FFBasicBannerView.h
//  GameBox
//
//  Created by 燚 on 2018/5/11.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FFBasicBannerView;

@protocol  FFBasicBannerViewDelegate <NSObject>

- (void)FFBasicBannerView:(FFBasicBannerView *)view didSelectImageWithInfo:(NSDictionary *)info;

@end

@interface FFBasicBannerView : UIView

/** 轮播视图数组 */
@property (nonatomic, strong) NSMutableArray * rollingArray;

/** delegate */
@property (nonatomic, weak) id<FFBasicBannerViewDelegate> delegate;

- (instancetype)init;

- (instancetype)initWithFrame:(CGRect)frame;

/** 停止定时器 */
- (void)stopTimer;

/** 启动定时器 */
- (void)startTimer;

@end




