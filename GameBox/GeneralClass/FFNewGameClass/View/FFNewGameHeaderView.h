//
//  FFNewGameHeaderView.h
//  GameBox
//
//  Created by 燚 on 2018/6/4.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FFNewGameHeaderView;

@protocol FFNewGameHeaderViewDelegate <NSObject>

- (void)FFNewGameHeaderView:(FFNewGameHeaderView *)view seletGameItemWithInfo:(id)info;

- (void)FFNewGameHeaderView:(FFNewGameHeaderView *)view showBetaGame:(id)info;

- (void)FFNewGameHeaderView:(FFNewGameHeaderView *)view showreservationGame:(id)info;

@end


@interface FFNewGameHeaderView : UIView

@property (nonatomic, weak) id<FFNewGameHeaderViewDelegate> delegate;

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSArray *titleArray;


@end
