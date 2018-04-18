//
//  FFBasicSelectView.h
//  GameBox
//
//  Created by 燚 on 2018/4/16.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FFBasicSelectView;


@protocol FFBasicSelectViewDelegate <NSObject>

- (void)FFSelectHeaderView:(FFBasicSelectView *)view didSelectTitleWithIndex:(NSUInteger)idx;

@end


@interface FFBasicSelectView : UIView

/** delegate */
@property (nonatomic, weak) id<FFBasicSelectViewDelegate> delegate;
/**  select title text */
@property (nonatomic, strong) NSArray<NSString *> *headerTitleArray;

/** default is gray color */
@property (nonatomic, strong) UIColor *titleNormalColor;
/** default is orange color */
@property (nonatomic, strong) UIColor *titleSelectColor;
/** default is clear color */
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
/** title bounds default height = total height - 4  */
@property (nonatomic, assign) CGSize titleSize;

@property (nonatomic, assign) BOOL showCursorView;

/** select button Array */
@property (nonatomic, strong) NSMutableArray<UIButton *> *titleButtonArray;


- (instancetype)initWithFrame:(CGRect)frame;

- (instancetype)initWithFrame:(CGRect)frame WithHeaderTitleArray:(NSArray *)array;

- (void)setSelectTitleIndex:(NSInteger)selectTitleIndex;

- (void)setCursorX:(CGFloat)x;

/** change title array */ 
- (void)changeTitleTextWithArray:(NSArray<NSString *> *)titleArray;



@end




