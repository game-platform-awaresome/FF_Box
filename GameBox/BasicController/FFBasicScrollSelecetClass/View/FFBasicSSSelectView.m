//
//  FFBasicSSSelectView.m
//  GameBox
//
//  Created by 燚 on 2018/5/17.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicSSSelectView.h"


#define Button_tag 10086

NS_ASSUME_NONNULL_BEGIN

@interface FFBasicSSSelectView ()

@property (nonatomic, strong) NSMutableArray<UIButton *> *buttonArray;
@property (nonatomic, strong) NSMutableArray<UILabel *>  *subscriptLabelArray;

@property (nonatomic, strong) UIView *headerLine;
@property (nonatomic, strong) UIView *footerLine;

@property (nonatomic, strong) UIView *cursorView;

@property (nonatomic, assign) BOOL isAnimation;
@property (nonatomic, strong) UIButton *lastButton;
@property (nonatomic, strong) UILabel  *lastLabel;

@property (nonatomic, assign) NSUInteger selectIndex;

@property (nonatomic, strong) UILabel *subscriptLabel;

@end


@implementation FFBasicSSSelectView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}


- (void)initUserInterface {
    _selectIndex = 0;
    [self addSubview:self.headerLine];
    [self addSubview:self.footerLine];
    [self addSubview:self.cursorView];
}

#pragma mark - responds
- (void)respondsToButton:(UIButton *)sender {
    if (_isAnimation) {
        return;
    }

    _isAnimation = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.selectIndex = sender.tag - Button_tag;
    } completion:^(BOOL finished) {
        if (finished) _isAnimation = NO;
    }];

    if (self.selectBlock) {
        self.selectBlock(sender.tag - Button_tag);
    }
}

#pragma mark - method
- (void)removeAllButtons {
    if (self.buttonArray.count > 0) {
        for (UIButton *button in self.buttonArray) {
            [button removeFromSuperview];
        }
    }

    if (self.subscriptLabelArray.count > 0) {
        for (UILabel *label in self.buttonArray) {
            [label removeFromSuperview];
        }
    }
}

- (void)setSelectIndex:(NSUInteger)selectIndex {
    _selectIndex = selectIndex;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize retSize = [self.buttonArray[selectIndex].titleLabel.text boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH / self.buttonArray.count, self.bounds.size.height) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    self.cursorView.bounds = CGRectMake(0, 0, (retSize.width + 5), _cursorView.bounds.size.height);
    self.cursorView.center = CGPointMake(self.buttonArray[selectIndex].center.x, self.cursorView.center.y);
    [self setButtonHighlightedWintIndex:selectIndex];
}

- (void)setButtonHighlightedWintIndex:(NSUInteger)idx {
    if (_lastButton) {
        [_lastButton setTitleColor:self.normalColor forState:(UIControlStateNormal)];
    }
    if (_lastLabel) {
        _lastLabel.textColor = self.normalColor;
    }
    UIButton *button = self.buttonArray[idx];
    [button setTitleColor:self.selectColor forState:(UIControlStateNormal)];
    UILabel *label = self.subscriptLabelArray[idx];
    label.textColor = self.selectColor;
    _lastButton = button;
    _lastLabel = label;
}

- (void)setCursorView_X:(CGFloat)x {
    CGFloat count = (float)self.buttonArray.count;
    x += self.buttonArray[0].center.x;
    self.cursorView.center = CGPointMake(x, self.cursorView.center.y);
    NSInteger index = x / (kSCREEN_WIDTH / count);
    [self setButtonHighlightedWintIndex:index];
}

#pragma mark - setter
- (void)setTitleArray:(NSArray<NSString *> *)titleArray {
    if (titleArray.count == self.buttonArray.count) {
        [titleArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.buttonArray[idx] setTitle:obj forState:(UIControlStateNormal)];
        }];
    } else {
        [self removeAllButtons];
        _buttonArray = [NSMutableArray arrayWithCapacity:titleArray.count];
        _subscriptLabelArray = [NSMutableArray arrayWithCapacity:titleArray.count];
        [titleArray enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {

            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];

            button.frame = CGRectMake(idx * kSCREEN_WIDTH / titleArray.count, 0, kSCREEN_WIDTH / titleArray.count, self.frame.size.height);

            [button setTitle:obj forState:(UIControlStateNormal)];
            [button setTitleColor:self.normalColor forState:(UIControlStateNormal)];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.tag = Button_tag + idx;
            [button addTarget:self action:@selector(respondsToButton:) forControlEvents:(UIControlEventTouchUpInside)];
            [_buttonArray addObject:button];


            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:12];
            label.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.masksToBounds = YES;
            [_subscriptLabelArray addObject:label];

            [self addSubview:button];
        }];
    }
    self.selectIndex = _selectIndex;
}

- (void)setHeaderLineColor:(UIColor *)headerLineColor {
    _headerLineColor = headerLineColor;
    self.headerLine.backgroundColor = headerLineColor;
}

- (void)setFooterLineColor:(UIColor *)footerLineColor {
    self.footerLine.backgroundColor = footerLineColor;
}

- (void)setCursorColor:(UIColor *)cursorColor {
    self.cursorView.backgroundColor = cursorColor;
}

- (void)setButtonSubscriptWithIdx:(NSUInteger)idx Title:(NSString *)title {
    if (self.buttonArray.count > idx) {
        UIButton *button = self.buttonArray[idx];
        UILabel *label = self.subscriptLabelArray[idx];
        CGRect frame = [button convertRect:button.titleLabel.frame toView:self];
        CGRect btnFrame = button.frame;
        label.text = title;
        [label sizeToFit];
        CGRect labelBounds = label.bounds;
        labelBounds.size.width += 4;
        labelBounds.size.height += 2;
        if (labelBounds.size.width < labelBounds.size.height) {
            labelBounds.size.width = labelBounds.size.height;
        }
        frame.size = labelBounds.size;
        frame.origin.x = btnFrame.origin.x + btnFrame.size.width / 2 + 15;
        frame.origin.y = btnFrame.size.height / 2 - 16;
        label.layer.cornerRadius = labelBounds.size.height / 2;
        label.frame = frame;

        syLog(@"frame == %@",NSStringFromCGRect(frame));
        [self addSubview:label];
    }
}

#pragma mark - getter
- (UIColor *)normalColor {
    if (!_normalColor) {
        _normalColor = [UIColor grayColor];
    }
    return _normalColor;
}

- (UIColor *)selectColor {
    if (!_selectColor) {
        _selectColor = [UIColor blackColor];
    }
    return _selectColor;
}

- (UIView *)headerLine {
    if (!_headerLine) {
        _headerLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 0.5)];
    }
    return _headerLine;
}

- (UIView *)footerLine {
    if (!_footerLine) {
        _footerLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, kSCREEN_WIDTH, 0.5)];
    }
    return _footerLine;
}

- (UIView *)cursorView {
    if (!_cursorView) {
        _cursorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 3, 20, 2)];
        _cursorView.layer.cornerRadius = _cursorView.bounds.size.height / 2;
        _cursorView.layer.masksToBounds = YES;
        _cursorView.backgroundColor = [UIColor blackColor];
    }
    return _cursorView;
}


- (UILabel *)subscriptLabel {
    if (!_subscriptLabel) {
        _subscriptLabel = [[UILabel alloc] init];
        _subscriptLabel.font = [UIFont systemFontOfSize:12];
        _subscriptLabel.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        _subscriptLabel.textAlignment = NSTextAlignmentCenter;
        _subscriptLabel.layer.masksToBounds = YES;
    }
    return _subscriptLabel;
}



@end


NS_ASSUME_NONNULL_END








