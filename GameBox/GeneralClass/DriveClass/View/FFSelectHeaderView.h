//
//  FFSelectHeaderView.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/10.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FFSelectHeaderView;


@protocol FFSelectHeaderViewDelegate <NSObject>

- (void)FFSelectHeaderView:(FFSelectHeaderView *)view didSelectTitleWithIndex:(NSUInteger)idx;

@end


@interface FFSelectHeaderView : UIView

@property (nonatomic, weak) id<FFSelectHeaderViewDelegate> delegate;

/** header select title */
@property (nonatomic, strong) NSArray<NSString *> *headerTitleArray;

/** default gray color */
@property (nonatomic, strong) UIColor *titleNormalColor;
/** default orange color */
@property (nonatomic, strong) UIColor *titleSelectColor;
/** default clear color */ 
@property (nonatomic, strong) UIColor *titleBackGroundColor;

/** cursor color */
@property (nonatomic, strong) UIColor *cursorColor;

/** default is NO */
@property (nonatomic, assign) BOOL cursorWidthEqualToTitleWidth;
@property (nonatomic, assign) CGSize cursorSize;
@property (nonatomic, assign) CGFloat cursorCenter_Y;

/** default is clear color */ 
@property (nonatomic, strong) UIColor *lineColor;

/** default is NO */
@property (nonatomic, assign) BOOL canScrollTitle;
/**
 title bounds
 default height = total height - 4
 */
@property (nonatomic, assign) CGSize titleSize;


@property (nonatomic, assign) BOOL showCursorView;

/** title button Array */
@property (nonatomic, strong) NSMutableArray<UIButton *> *titleButtonArray;


- (instancetype)initWithFrame:(CGRect)frame;


- (instancetype)initWithFrame:(CGRect)frame WithHeaderTitleArray:(NSArray *)array;


- (void)setSelectTitleIndex:(NSInteger)selectTitleIndex;

- (void)setCursorX:(CGFloat)x;


@end
