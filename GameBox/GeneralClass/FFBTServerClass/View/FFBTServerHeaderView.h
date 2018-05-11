//
//  FFBTServerHeaderView.h
//  GameBox
//
//  Created by 燚 on 2018/5/10.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FFBTServerHeaderView;

@protocol FFBTServerHeaderViewDelegate <NSObject>

- (void)FFBTServerHeaderView:(FFBTServerHeaderView *)headerView didSelectImageWithInfo:(NSDictionary *)info;


@end

@interface FFBTServerHeaderView : UIView

@property (nonatomic, weak) id<FFBTServerHeaderViewDelegate> delegate;

@property (nonatomic, strong) UIImageView *searchBarView;

@property (nonatomic, strong) NSArray *bannerArray;




- (instancetype)init;

- (instancetype)initWithFrame:(CGRect)frame;




@end
