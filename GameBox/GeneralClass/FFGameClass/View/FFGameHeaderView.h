//
//  FFGameHeaderView.h
//  GameBox
//
//  Created by 燚 on 2018/5/16.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^RespondsToQQGroupButtonBlock)(void);

@interface FFGameHeaderView : UIView

/** 内测游戏字段 */
@property (nonatomic, strong) NSString      *betaString;
/** 预约游戏字段 */
@property (nonatomic, strong) NSString      *reservationString;
/** 背景视图 */
@property (nonatomic, strong) UIImageView   *backgroundView;


@property (nonatomic, strong) RespondsToQQGroupButtonBlock qqGroupButtonBlock;


- (void)refreshBackgroundHeight:(CGFloat)height;


- (void)refresh;
- (void)showNavigationTitle;
- (void)hideNavigationTitle;


@end





