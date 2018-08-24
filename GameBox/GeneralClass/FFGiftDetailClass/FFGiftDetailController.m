//
//  FFGiftDetailController.m
//  GameBox
//
//  Created by 燚 on 2018/8/24.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFGiftDetailController.h"
#import "FFUserModel.h"
#import "FFCurrentGameModel.h"

@interface FFGiftDetailController ()

@property (nonatomic, strong) id info;

@property (nonatomic, strong) NSString *pid;

@property (nonatomic, strong) NSDictionary *dict;

/** 游戏 logo */
@property (nonatomic, strong) UIImageView           *gameLogoImageView;
/** 游戏名称 */
@property (nonatomic, strong) UILabel               *gameNameLabel;
/** 游戏大小 */
@property (nonatomic, strong) UILabel               *gameSizeLabel;
/** 游戏描述 */
@property (nonatomic, strong) UILabel               *gameDescriptionLabel;

/** 礼包名称 */
@property (nonatomic, strong) UILabel               *giftNameLabel;
/** 礼包领取按钮 */
@property (nonatomic, strong) UIButton              *giftButton;
/** 礼包完成度 */
@property (nonatomic, strong) UILabel               *giftProgressLabel;
/** 礼包进度条 */
@property (nonatomic, strong) UIView                *giftProgressBackView;

/** 礼包描述 */
@property (nonatomic, strong) NSArray<UILabel *>    *desTitleArray;
/** 礼包描述详情 */
@property (nonatomic, strong) NSArray<UILabel *>    *desContentArray;




@end

@implementation FFGiftDetailController

+ (FFGiftDetailController *)detail:(id)info {
    FFGiftDetailController *controller = [[FFGiftDetailController alloc] init];
    controller.info = info;
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initDataSource {
    [super initDataSource];
}

- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.title = @"礼包详情";

    /** 游戏logo */
    self.gameLogoImageView = [UIImageView hyb_imageViewWithImage:CURRENT_GAME.game_logo_image superView:self.view constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(88);
        make.left.mas_equalTo(self.view).offset(20);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];

    /** 游戏名称 */
    self.gameNameLabel = [UILabel hyb_labelWithFont:15 superView:self.view constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.gameLogoImageView.mas_top);
        make.left.mas_equalTo(self.gameLogoImageView.mas_right).offset(10);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(self.view).offset(-20);
    }];
    self.gameNameLabel.font = [UIFont boldSystemFontOfSize:16];

    /** 游戏大小 */
    self.gameSizeLabel = [UILabel hyb_labelWithFont:14 superView:self.view constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.gameNameLabel.mas_bottom);
        make.left.mas_equalTo(self.gameLogoImageView.mas_right).offset(10);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(self.view).offset(-20);
    }];
    self.gameNameLabel.textColor = [FFColorManager textColorMiddle];

    /** 游戏描述 */
    self.gameDescriptionLabel = [UILabel hyb_labelWithFont:12 superView:self.view constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.gameSizeLabel.mas_bottom);
        make.left.mas_equalTo(self.gameLogoImageView.mas_right).offset(10);
        make.height.mas_equalTo(20);
        make.right.mas_equalTo(self.view).offset(-20);
    }];
    self.gameDescriptionLabel.textColor = [FFColorManager textColorMiddle];

    /** 分割线 */
    UIView *line = [UIView hyb_viewWithSuperView:self.view constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.gameLogoImageView.mas_bottom).offset(20);
        make.left.mas_equalTo(self.view).offset(0);
        make.right.mas_equalTo(self.view).offset(0);
        make.height.mas_equalTo(1);
    }];
    line.backgroundColor = [FFColorManager view_separa_line_color];

    /** 礼包按钮 */
    self.giftButton = [UIButton hyb_buttonWithTitle:@"领取" superView:self.view constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom).offset(20);
        make.right.mas_equalTo(self.view).offset(-20);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    } touchUp:^(UIButton *sender) {
        [self respondsToGiftButton];
    }];
    [self.giftButton setBackgroundColor:[FFColorManager blue_dark]];
    self.giftButton.layer.cornerRadius = 15;
    self.giftButton.layer.masksToBounds = YES;
    [self.giftButton setTitle:@"复制" forState:(UIControlStateSelected)];
    self.giftButton.userInteractionEnabled = NO;

    /** 礼包详情 */
    self.giftNameLabel = [UILabel hyb_labelWithFont:15 superView:self.view constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom).offset(10);
        make.left.mas_equalTo(self.view).offset(20);
        make.right.mas_equalTo(self.giftButton.mas_left).offset(-20);
        make.height.mas_equalTo(20);
    }];

    line = [UIView hyb_viewWithSuperView:self.view constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.giftButton.mas_bottom).offset(20);
        make.left.mas_equalTo(self.view).offset(0);
        make.right.mas_equalTo(self.view).offset(0);
        make.height.mas_equalTo(1);
    }];
    line.backgroundColor = [FFColorManager view_separa_line_color];

    /** 进度 */
    self.giftProgressLabel = [UILabel hyb_labelWithFont:14 superView:self.view constraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(line.mas_top).offset(-10);
        make.right.mas_equalTo(self.giftButton.mas_left).offset(-10);
        make.height.mas_equalTo(30);
    }];
    self.giftProgressLabel.textColor = [FFColorManager textColorMiddle];
    self.giftProgressLabel.text = @"(剩余100%)";

    /** 进度条背景 */
    self.giftProgressBackView = [UIView hyb_viewWithSuperView:self.view constraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(20);
        make.right.mas_equalTo(self.giftProgressLabel.mas_left).offset(-8);
        make.centerY.mas_equalTo(self.giftProgressLabel.mas_centerY);
        make.height.mas_equalTo(4);
    }];
    self.giftProgressBackView.backgroundColor = [FFColorManager textColorDark];




    /** 礼包说明 */
    NSMutableArray *titleArray = [NSMutableArray array];
    NSMutableArray *contentArray = [NSMutableArray array];
    NSArray *title = @[@"1.礼包内容",@"2.兑换方法",@"3.注意事项",@"4.礼包时间"];
    UIView *lastLine;
    for (int i = 0; i < 4; i++) {
        UILabel *titleLabel = [UILabel hyb_labelWithText:title[i] font:16 superView:self.view constraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lastLine ? lastLine.mas_bottom : line.mas_bottom).offset(10);
            make.left.mas_equalTo(self.view).offset(20);
            make.right.mas_equalTo(self.view).offset(-20);
            make.height.mas_equalTo(22);
        }];
        titleLabel.textColor = [FFColorManager blue_dark];
        titleLabel.font = [UIFont boldSystemFontOfSize:18];

        UILabel *contentLabel = [UILabel hyb_labelWithText:@"" font:13 lines:0 superView:self.view constraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(10);
            make.left.mas_equalTo(self.view).offset(20);
            make.right.mas_equalTo(self.view).offset(-20);
//            make.height.mas_equalTo(20);
        }];
        contentLabel.textColor = [FFColorManager textColorDark];

        UIView *line = [UIView hyb_viewWithSuperView:self.view constraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(contentLabel.mas_bottom).offset(10);
            make.left.mas_equalTo(self.view).offset(0);
            make.right.mas_equalTo(self.view).offset(0);
            make.height.mas_equalTo(1);
        }];
        line.backgroundColor = [FFColorManager view_separa_line_color];

        lastLine = line;
        [titleArray addObject:titleLabel];
        [contentArray addObject:contentLabel];
    }

    self.desContentArray = contentArray;

}

- (void)refreshData {
    [self startWaiting];
    [FFGameModel GiftDetailInfoWith:self.pid Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        syLog(@"gift detail == %@",content);
        if (success) {
            self.dict = CONTENT_DATA;
        } else {
            [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:^{
                [self back];
            }];
        }
    }];
}

- (void)back {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma makr - setter
- (void)setInfo:(id)info {
    if ([info isKindOfClass:[NSDictionary class]]) {
        self.pid = info[@"id"] ?: info[@"pid"] ?: @"0";
    } else if ([info isKindOfClass:[NSString class]]) {
        self.pid = info;
    } else {
        [self back];
    }
}

- (void)setPid:(NSString *)pid {
    _pid = [NSString stringWithFormat:@"%@",pid];
    [self refreshData];
}

#define SafeString(string) [NSString stringWithFormat:@"%@",dict[string]];
- (void)setDict:(NSDictionary *)dict {
    _dict = dict;

    //游戏名称
    self.gameNameLabel.text = SafeString(@"game_name");
    //游戏大小
    self.gameSizeLabel.text = [NSString stringWithFormat:@"%@M",dict[@"game_size"]];;
    //游戏描述
    self.gameDescriptionLabel.text = SafeString(@"game_content");
    //礼包按钮
    self.giftButton.selected = [dict[@"card"] isKindOfClass:[NSString class]];
    self.giftButton.userInteractionEnabled = YES;
    //礼包名称
    self.giftNameLabel.text = SafeString(@"pack_name");
    //1礼包内容
    self.desContentArray[0].text = SafeString(@"pack_abstract");
    //2礼包方法
    self.desContentArray[1].text = SafeString(@"pack_method");
    //3注意事项
    self.desContentArray[2].text = SafeString(@"pack_notice");

    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"YYYY-MM-dd";

    //开始时间
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:[NSString stringWithFormat:@"%@",dict[@"start_time"]].integerValue];
    NSString *starString = [NSString stringWithFormat:@"开始时间 : %@",[formatter stringFromDate:date]];

    //结束时间
    date = [NSDate dateWithTimeIntervalSinceNow:[NSString stringWithFormat:@"%@",dict[@"end_time"]].integerValue];
    NSString *endString = [NSString stringWithFormat:@"结束时间 : %@",[formatter stringFromDate:date]];

    self.desContentArray[3].text = [NSString stringWithFormat:@"%@\n%@",starString,endString];

    //礼包总数
    NSString *totalString = SafeString(@"pack_counts");
    //使用个数
    NSString *useString = SafeString(@"pack_used_counts");

    //剩余礼包百分比
    CGFloat currentFloat = (totalString.floatValue - useString.floatValue) / totalString.floatValue;
    self.giftProgressLabel.text = [NSString stringWithFormat:@"(剩余%.0f%%)",currentFloat * 100];

    UIView *view = [UIView hyb_viewWithSuperView:self.giftProgressBackView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.giftProgressBackView);
        make.bottom.mas_equalTo(self.giftProgressBackView);
        make.left.mas_equalTo(self.giftProgressBackView);
        make.width.mas_equalTo((self.giftProgressBackView.hyb_width * currentFloat));
    }];
    view.backgroundColor = [FFColorManager blue_dark];


}


#pragma mark - respondst
- (void)respondsToGiftButton {
    syLog(@"领取礼包");
    NSString *str = self.dict[@"card"];
    if ([str isKindOfClass:[NSNull class]]) {
        [FFGameModel getGameGiftWithPackageID:self.pid Completion:^(NSDictionary * _Nonnull content, BOOL success) {
            if (success) {
                [UIAlertController showAlertMessage:@"领取成功" dismissTime:0.7 dismissBlock:nil];
                [self refreshData];
            } else {
                [UIAlertController showAlertMessage:@"领取失败" dismissTime:0.7 dismissBlock:nil];
            }
        }];
    } else {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = str;
        [UIAlertController showAlertMessage:@"已复制礼包兑换码" dismissTime:0.7 dismissBlock:nil];
    }
}










@end

















