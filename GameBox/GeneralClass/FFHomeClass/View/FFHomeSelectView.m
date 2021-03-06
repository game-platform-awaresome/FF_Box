//
//  FFHomeSelectView.m
//  GameBox
//
//  Created by 燚 on 2018/5/10.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFHomeSelectView.h"
#import "FFColorManager.h"

const NSUInteger HomeButtonTag = 10086;

@interface FFHomeSelectView ()<UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger selectTitleIndex;
@property (nonatomic, strong) UIView *cursorView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) CALayer *lineLayer;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) BOOL isAnimating;



@property (nonatomic, strong) NSMutableArray<NSNumber *> *titleWidthArray;

@end

@implementation FFHomeSelectView {
    UIButton *lastButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initDataSource];
        [self initUserInterface];
        self.totalFrame = frame;
        syLog(@"init home select view with frame");
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame WithHeaderTitleArray:(NSArray *)array {
    self = [super init];
    if (self) {
        [self initDataSource];
        [self initUserInterface];
        self.totalFrame = frame;
        self.titleArray = array;
    }
    return self;
}

- (void)initUserInterface {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.cursorView];
    [self addSubview:self.lineView];
//    [self addSubview:self.cursorView];
}

- (void)initDataSource {
    self.backgroundColor = [UIColor whiteColor];
    _titleNormalColor = [UIColor grayColor];
    _titleSelectColor = [FFColorManager home_select_view_color];
    _titleBackGroundColor = [UIColor clearColor];
    _cursorWidthEqualToTitleWidth = YES;
    _selectTitleIndex = 0;
    _titleSize = CGSizeMake(kSCREEN_WIDTH / 6, 0);
    _titleNormalFont = [UIFont systemFontOfSize:17];
    _titleSelectFont = [UIFont boldSystemFontOfSize:18];
    self.showCursorView = YES;
    self.totalFrame = CGRectMake(0, 0, kSCREEN_WIDTH, 44);
    self.cursorView.bounds = CGRectMake(0, 0, 0, 3);
    self.lineColor = [FFColorManager textColorDark];
    self.cursorColor = [FFColorManager home_select_view_color];
}

#pragma mark - method
/** Calculate title width */
- (void)signTitleArrayWidthWith:(NSArray<NSString *> *)titleArray {
    _titleWidthArray = [NSMutableArray arrayWithCapacity:titleArray.count];
    CGFloat Max_width = 0;
    for (NSString *title in titleArray) {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        CGSize retSize = [title boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH / 4, 30) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        NSNumber *width = [NSNumber numberWithFloat:retSize.width];
        if (retSize.width > Max_width) {
            Max_width = retSize.width;
        }
        [_titleWidthArray addObject:width];
    }
    self.ButtonSize = CGSizeMake(Max_width + 2, self.bounds.size.height - KSTATUBAR_HEIGHT);
}

/** create button */
- (void)creatTitleButtonWithTitleArray:(NSArray<NSString *> *)titleArray {
    if (titleArray == nil || titleArray.count == 0) {
        return;
    }
    //如果 title 和按钮的数组个数相等, 就替换标题.否则就重新创建按钮数组
    if (self.titleArray.count > 0 && self.buttonArray.count == titleArray.count) {
        [self changeTitleTextWithArray:titleArray];
    } else {
        _buttonArray = [NSMutableArray arrayWithCapacity:titleArray.count];
        int idx = 0;
        for (NSString *title in titleArray) {
            UIButton *button = [self creatButtonWithIndex:idx WidthTitle:title];
            [_buttonArray addObject:button];
            idx++;
        }
    }
}


- (UIButton *)creatButtonWithIndex:(NSUInteger)idx WidthTitle:(NSString *)title {
    static UIButton *lastButton;
    UIButton *button = [UIButton hyb_buttonWithTitle:title superView:self.scrollView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(KSTATUBAR_HEIGHT);
        make.left.mas_equalTo(lastButton ? lastButton.mas_right : self).offset(10);
        make.bottom.mas_equalTo(self);
        if (idx < self.titleWidthArray.count) {
            make.width.mas_equalTo(self.titleWidthArray[idx].floatValue + 10);
        }
    } touchUp:^(UIButton *sender) {
        [self respondsToTitleButton:sender];
    }];
    button.tag = HomeButtonTag + idx;
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    [button setTitleColor:self.titleNormalColor forState:(UIControlStateNormal)];
    button.titleLabel.font = self.titleNormalFont;
    button.backgroundColor = self.titleBackGroundColor;
    lastButton = button;
    return button;
}

/** Modify the title */
- (void)changeTitleTextWithArray:(NSArray<NSString *> *)titleArray {
    if (self.buttonArray != nil && self.buttonArray.count > 0 && self.titleArray.count >= self.buttonArray.count) {
        int i = 0;
        for (UIButton *button in self.buttonArray) {
            [button setTitle:titleArray[i] forState:(UIControlStateNormal)];
        }
    } else {
        self.titleArray = titleArray;
    }
}

/** set title frame */
- (void)setButtonArrayFrame {
//    if (self.buttonArray.count < 1) {
//        syLog(@"标题按钮数组为空");
//        return;
//    }
//    int idx = 0;
//    CGFloat width = self.ButtonSize.width + 6;
//    for (UIButton *button in self.buttonArray) {
//        button.frame = CGRectMake(10 + idx * width, KSTATUBAR_HEIGHT, width, self.ButtonSize.height);
//        idx++;
//    }
}

#pragma mark - responds
/** responds button */
- (void)respondsToTitleButton:(UIButton *)sender {
    if (!_isAnimating) {
        self.selectTitleIndex = sender.tag - HomeButtonTag;
        if (self.delegate && [self.delegate respondsToSelector:@selector(FFHomeSelectView:didSelectButtonWithIndex:)]) {
            [self.delegate FFHomeSelectView:self didSelectButtonWithIndex:sender.tag - HomeButtonTag];
        }
    }
}

#pragma mark - setter
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.totalFrame = frame;
}
/** 设置总共的尺寸 */
- (void)setTotalFrame:(CGRect)totalFrame {
    _totalFrame = CGRectMake(0, 0, totalFrame.size.width, totalFrame.size.height);
    _titleSize.height = totalFrame.size.height;
    self.scrollView.frame = _totalFrame;
    self.lineView.frame = CGRectMake(0, totalFrame.size.height - 0.5, kSCREEN_WIDTH, 0.5);
    [self bringSubviewToFront:self.lineView];
}
- (void)setTitleSize:(CGSize)titleSize {
    _titleSize = titleSize;
}

- (void)setLineColor:(UIColor *)lineColor {
    self.lineView.backgroundColor = lineColor;
}

- (void)setTitleArray:(NSArray<NSString *> *)titleArray {
    _titleArray = titleArray;


    if (self.buttonArray) {
        for (UIButton *button in self.buttonArray) {
            [button removeFromSuperview];
        }
    }
    self.buttonArray = nil;

    //计算 title 的宽度
    [self signTitleArrayWidthWith:_titleArray];

    //创建按钮;
    [self creatTitleButtonWithTitleArray:_titleArray];

    //设置 button frame
//    [self setButtonArrayFrame];
    //选择第一个下标
//    [self setSelectTitleIndex:_selectTitleIndex];

    if (_cursorWidthEqualToTitleWidth) {
        self.cursorView.bounds = CGRectMake(0, 0, (_titleWidthArray[0].floatValue + 5), _cursorView.bounds.size.height);
    } else {
        self.cursorView.bounds = CGRectMake(0, 0, _cursorView.bounds.size.width, _cursorView.bounds.size.height);
    }

    [self setButtonHighlightedWintIndex:_selectTitleIndex];

//    self.selectTitleIndex = 0;

//    self.cursorView = [UIView hyb_viewWithSuperView:self constraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.buttonArray[0].mas_centerX);
//        make.height.mas_equalTo(3);
//        make.bottom.mas_equalTo(self.mas_bottom);
//        make.width.mas_equalTo(self.buttonArray[0].mas_width);
//    }];

    self.cursorView.center = CGPointMake(self.buttonArray[0].center.x, self.bounds.size.height - 3);
    [self setCursorCenter];
}

- (void)setCursorCenter {
    self.selectTitleIndex = 0;
    if (self.cursorView.center.x == 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setCursorCenter];
        });
    }
}

- (void)setTitleNormalColor:(UIColor *)titleNormalColor {
    for (UIButton *button in self.buttonArray) {
        [button setTitleColor:titleNormalColor forState:(UIControlStateNormal)];
    }
}


- (void)setCursorCenter_X:(CGFloat)cursorCenter_X {
    CGFloat count = (float)self.buttonArray.count;
    CGFloat totalWidth = self.buttonArray.lastObject.center.x - self.buttonArray.firstObject.center.x;
    cursorCenter_X = cursorCenter_X * totalWidth;
    NSInteger index = (cursorCenter_X / totalWidth * (count - 1) + 0.5);
    cursorCenter_X += self.buttonArray[0].center.x;
    self.cursorView.center = CGPointMake(cursorCenter_X, self.cursorView.center.y);
    [self setButtonHighlightedWintIndex:index];
}


- (void)setButtonHighlightedWintIndex:(NSUInteger)idx {
    if (lastButton) {
        [lastButton setTitleColor:self.titleNormalColor forState:(UIControlStateNormal)];
        [lastButton.titleLabel setFont:self.titleNormalFont];
    }
    UIButton *button = self.buttonArray[idx];
    [button setTitleColor:self.titleSelectColor forState:(UIControlStateNormal)];
    [button.titleLabel setFont:self.titleSelectFont];
    lastButton = button;
}

- (void)setSelectTitleIndex:(NSInteger)selectTitleIndex {
    _selectTitleIndex = selectTitleIndex;
    if (_cursorWidthEqualToTitleWidth) {
        self.cursorView.bounds = CGRectMake(0, 0, (_titleWidthArray[selectTitleIndex].floatValue + 5), _cursorView.bounds.size.height);
    } else {
        self.cursorView.bounds = CGRectMake(0, 0, _cursorView.bounds.size.width, _cursorView.bounds.size.height);
    }


    [self setButtonHighlightedWintIndex:_selectTitleIndex];

    [self.scrollView sendSubviewToBack:self.cursorView];
    _isAnimating = YES;

    [UIView animateWithDuration:0.3 animations:^{
        self.cursorView.center = CGPointMake(self.buttonArray[self -> _selectTitleIndex].center.x, self.cursorView.center.y);
    } completion:^(BOOL finished) {
        self -> _isAnimating = NO;
        [self.scrollView sendSubviewToBack:self.cursorView];
    }];
}

- (void)setCursorColor:(UIColor *)cursorColor {
    _cursorColor = cursorColor;
}


#pragma mark - getter
- (UIView *)cursorView {
    if (!_cursorView) {
        _cursorView = [[UIView alloc] init];
        _cursorView.center = CGPointMake(self.buttonArray[0].center.x, _totalFrame.size.height - 4);
        _cursorView.backgroundColor = [FFColorManager home_select_view_lineColor];
        _cursorView.layer.cornerRadius = 1;
        _cursorView.layer.masksToBounds = YES;
    }
    return _cursorView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _totalFrame.size.width, _totalFrame.size.height)];
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (CGFloat)cursorCenter_Y {
    if (_cursorCenter_Y == 0) {
        _cursorCenter_Y = _totalFrame.size.height - 4;
    }
    return _cursorCenter_Y;
}

- (CALayer *)lineLayer {
    if (!_lineLayer) {
        _lineLayer = [[CALayer alloc] init];
        _lineLayer.bounds = CGRectMake(0, 0, _totalFrame.size.width, 1);
    }
    return _lineLayer;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.5)];
    }
    return _lineView;
}






@end













