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

- (void)FFBTServerHeaderView:(FFBTServerHeaderView *)headerView didSelectButtonWithInfo:(id)info;

- (void)FFBTServerHeaderView:(FFBTServerHeaderView *)headerView didSelectSearchViewWithInfo:(id)info;

@end

@interface FFBTServerHeaderView : UIView

@property (nonatomic, weak) id<FFBTServerHeaderViewDelegate> delegate;


@property (nonatomic, assign) CGRect searchHeaderFrame;
@property (nonatomic, assign) CGRect searchScrollFrame;

@property (nonatomic, assign) BOOL   isAddHeader;
@property (nonatomic, assign) BOOL   isAddView;


@property (nonatomic, strong) UIView        *searchView;
@property (nonatomic, strong) UIImageView   *searchBarView;
@property (nonatomic, strong) UIImageView   *searchScrollImage;
@property (nonatomic, strong) UIButton      *searchTitleButton;

@property (nonatomic, strong) NSArray       *bannerArray;

@property (nonatomic, strong) NSArray<NSString *> *titleArray;
@property (nonatomic, strong) NSArray<UIImage *>  *imageArray;
@property (nonatomic, strong) NSArray<NSString *> *controllerName;


- (instancetype)init;

- (instancetype)initWithFrame:(CGRect)frame;




@end
