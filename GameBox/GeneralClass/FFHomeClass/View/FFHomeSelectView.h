//
//  FFHomeSelectView.h
//  GameBox
//
//  Created by 燚 on 2018/5/10.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FFHomeSelectView;

@protocol FFHomeSelectViewDelegate <NSObject>

- (void)FFHomeSelectView:(FFHomeSelectView *)selectView didSelectButtonWithIndex:(NSUInteger)idx;

@end

@interface FFHomeSelectView : UIView

@property (nonatomic, weak) id<FFHomeSelectViewDelegate> delegate;

/** title array */
@property (nonatomic, strong) NSArray<NSString *> *titleArray;
/** button array */
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttonArray;

/** default is gray color */
@property (nonatomic, strong) UIColor *titleNormalColor;
/** default is orange color */
@property (nonatomic, strong) UIColor *titleSelectColor;
/** default is clear color */
@property (nonatomic, strong) UIColor *titleBackGroundColor;
/** default is system 20 */
@property (nonatomic, strong) UIFont *titleNormalFont;
/** default is system 24 */
@property (nonatomic, strong) UIFont *titleSelectFont;

/** show cursor view : defatult is YES*/
@property (nonatomic, assign) BOOL showCursorView;
/** default is clear color */
@property (nonatomic, strong) UIColor *cursorColor;
/** default is NO */
@property (nonatomic, assign) BOOL cursorWidthEqualToTitleWidth;
/** cursor size */
@property (nonatomic, assign) CGSize cursorSize;
/** cursorCenter */
@property (nonatomic, assign) CGFloat cursorCenter_Y;
@property (nonatomic, assign) CGFloat cursorCenter_X;

/** default is clear color */
@property (nonatomic, strong) UIColor *lineColor;

/** title size : defatult screen width / button array count */
@property (nonatomic, assign) CGSize titleSize;


#pragma mark - background view frame
@property (nonatomic, assign) CGRect totalFrame;
@property (nonatomic, assign) CGSize ButtonSize;


- (instancetype)initWithFrame:(CGRect)frame;

- (instancetype)initWithFrame:(CGRect)frame WithHeaderTitleArray:(NSArray *)array;

- (void)setSelectTitleIndex:(NSInteger)selectTitleIndex;

/** change title array */
- (void)changeTitleTextWithArray:(NSArray<NSString *> *)titleArray;



@end








