//
//  FFOpenServerSelectView.h
//  GameBox
//
//  Created by 燚 on 2018/5/21.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FFOpenServerSelectView;


@protocol FFOpenServerSelectViewDelegate <NSObject>

- (void)FFOpenServerSelectView:(FFOpenServerSelectView *)view didSelectTitleWithIndex:(NSUInteger)idx;

@end

@interface FFOpenServerSelectView : UIView


@property (nonatomic, weak) id<FFOpenServerSelectViewDelegate> delegate;

@property (nonatomic, strong) NSArray <NSString *> *titleArray;


- (instancetype)initWithFrame:(CGRect)frame;

- (instancetype)initWithFrame:(CGRect)frame WithHeaderTitleArray:(NSArray *)array;


- (void)setCursorX:(CGFloat)x;

@property (nonatomic, strong) UIColor *normolColor;
@property (nonatomic, strong) UIColor *selectColor;




@end
