//
//  FFGameHeaderView.m
//  GameBox
//
//  Created by 燚 on 2018/5/16.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameHeaderView.h"
#import "FFImageManager.h"
#import "FFColorManager.h"
#import "FFCurrentGameModel.h"
#import "FFControllerManager.h"

@interface FFGameHeaderView ()

@property (nonatomic, strong) UIView *settingView;


@end

@implementation FFGameHeaderView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}



- (void)initUserInterface {
    [self addSubview:self.backgroundView];
    [self addSubview:self.settingView];
}



#pragma mark - setter
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.backgroundView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.settingView.frame = CGRectMake(15, kNAVIGATION_HEIGHT, frame.size.width - 30, frame.size.height - kNAVIGATION_HEIGHT);
}

- (void)refreshBackgroundHeight:(CGFloat)height {
    if (height <= 0) {
        self.backgroundView.frame = CGRectMake(0, 0 + height, self.bounds.size.width, self.bounds.size.height + fabs(height));
    }
}

#pragma mark - getter
- (UIImageView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] initWithImage:[FFImageManager Game_header_background_image]];
    }
    return _backgroundView;
}

- (UIView *)settingView {
    if (!_settingView) {
        _settingView = [[UIView alloc] initWithFrame:CGRectMake(15, kNAVIGATION_HEIGHT, 220, 20)];
        _settingView.backgroundColor = [FFColorManager game_header_setview_BKColor];
        _settingView.layer.cornerRadius = 8;
        _settingView.layer.masksToBounds = YES;
    }
    return _settingView;
}


@end






