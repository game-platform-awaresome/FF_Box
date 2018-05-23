//
//  FFRebateSelectView.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/2.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FFRebateSelectView;

@protocol FFRebateSelectViewDelegate <NSObject>

- (void)FFRebateSelectView:(FFRebateSelectView *)selectView didSelectBtnAtIndexPath:(NSInteger)idx;

@end

@interface FFRebateSelectView : UIView

- (instancetype)initWithFrame:(CGRect)frame WithBtnArray:(NSArray *)btnNameArray;

@property (nonatomic, strong) NSArray *btnNameArray;

@property (nonatomic, weak) id<FFRebateSelectViewDelegate> delegate;

/**是否在动画中*/
@property (nonatomic, assign) BOOL isAnimation;

/**移动主视图时下标的位置*/
@property (nonatomic, assign) NSInteger index;

/** 分割线颜色 */
@property (nonatomic, strong) UIColor *lineColor;
/** 字体颜色 */
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) UIView *seleView;

@property (nonatomic, strong) UIView *line;

/** 移动标签 */
- (void)reomveLabelWithX:(CGFloat)x;





@end
