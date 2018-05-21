//
//  FFGameDetailFooterView.m
//  GameBox
//
//  Created by 燚 on 2018/5/21.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGameFooterView.h"
#import "FFDeviceInfo.h"
#import "FFCurrentGameModel.h"
#import "FFImageManager.h"
#import "FFColorManager.h"
#import <FFTools/FFTools.h>

@interface FFGameFooterView ()

/**收藏按钮*/
@property (nonatomic, strong) UIButton *collectionBtn;
/**下载按钮*/
@property (nonatomic, strong) UIButton *downLoadBtn;
/**评论按钮*/
@property (nonatomic, strong) UIButton *shardBtn;

@end

@implementation FFGameFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}


- (void)initUserInterface {
    self.backgroundColor = [FFColorManager tabbarColor];
    [self addSubview:self.collectionBtn];
    [self addSubview:self.downLoadBtn];

    if ([Channel isEqualToString:@"185"]) {
        [self addSubview:self.shardBtn];
    } else {
        [self.shardBtn removeFromSuperview];
    }
}


- (void)refresh {
    BOOL isCollection = CURRENT_GAME.game_is_collection.boolValue;
    if (isCollection) {
        [self.collectionBtn setImage:[FFImageManager Game_detail_footer_collection] forState:(UIControlStateNormal)];
    } else {
        [self.collectionBtn setImage:[FFImageManager Game_detail_footer_nocollection] forState:(UIControlStateNormal)];
    }
}

#pragma mark - respondToButton
- (void)clickCollectButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFGameDetailFooterView:clickCollecBtn:)]) {
        [self.delegate FFGameDetailFooterView:self clickCollecBtn:sender];
    }
}

- (void)clickShareButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFGameDetailFooterView:clickShareBtn:)]) {
        [self.delegate FFGameDetailFooterView:self clickShareBtn:sender];
    }
}

- (void)clickDownLoadButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(FFGameDetailFooterView:clickDownLoadBtn:)]) {
        [self.delegate FFGameDetailFooterView:self clickDownLoadBtn:sender];
    }
}

#pragma mark - getter
- (UIButton *)collectionBtn {
    if (!_collectionBtn) {
        _collectionBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _collectionBtn.frame = CGRectMake(0, 0, 60, 50);
        [_collectionBtn setImage:[FFImageManager Game_detail_footer_nocollection] forState:(UIControlStateNormal)];
        [_collectionBtn addTarget:self action:@selector(clickCollectButton:) forControlEvents:(UIControlEventTouchUpInside)];
//        [_collectionBtn setTitle:@"分享" forState:(UIControlStateNormal)];
//        [_collectionBtn layoutButtonWithImageStyle:(FFButtonImageOnTop) imageTitleSpace:0];
//        _collectionBtn.titleLabel.font = [UIFont systemFontOfSize:9];
        [_collectionBtn setTitleColor:[FFColorManager blue_dark] forState:(UIControlStateNormal)];
    }
    return _collectionBtn;
}


- (UIButton *)downLoadBtn {
    if (!_downLoadBtn) {
        _downLoadBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _downLoadBtn.frame = CGRectMake(60, 3, kSCREEN_WIDTH - 120, 44);
        [_downLoadBtn setTitle:@"下载" forState:(UIControlStateNormal)];
        _downLoadBtn.backgroundColor = [FFColorManager blue_dark];
        _downLoadBtn.layer.cornerRadius = 22;
        _downLoadBtn.layer.masksToBounds = YES;
        [_downLoadBtn addTarget:self action:@selector(clickDownLoadButton:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _downLoadBtn;
}

- (UIButton *)shardBtn {
    if (!_shardBtn) {
        _shardBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _shardBtn.frame = CGRectMake(kSCREEN_WIDTH - 60, 0, 60, 50);
//        [_shardBtn setTitle:@"评论" forState:(UIControlStateNormal)];
        [_shardBtn setImage:[FFImageManager Game_detail_footer_comment] forState:(UIControlStateNormal)];
        [_shardBtn addTarget:self action:@selector(clickShareButton:) forControlEvents:(UIControlEventTouchUpInside)];
//        [_shardBtn layoutButtonWithImageStyle:(FFButtonImageOnTop) imageTitleSpace:-2];
//        _shardBtn.titleLabel.font = [UIFont systemFontOfSize:9];
        [_shardBtn setTitleColor:[FFColorManager blue_dark] forState:(UIControlStateNormal)];
    }
    return _shardBtn;
}


@end







