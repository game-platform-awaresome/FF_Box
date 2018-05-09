//
//  FFCustomeTabBar.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/10/30.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FFCustomizeTabBar;

@protocol FFCustomizeTabbarDelegate <NSObject>

- (void)CustomizeTabBar:(FFCustomizeTabBar *)tabBar didSelectCenterButton:(id)sender;


@end


@interface FFCustomizeTabBar : UITabBar

@property (nonatomic, weak) id<FFCustomizeTabbarDelegate> customizeDelegate;

@property (nonatomic, strong) UIButton *centerBtn;


@end

