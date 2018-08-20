//
//  FFRepairViewController.m
//  GameBox
//
//  Created by 燚 on 2018/8/15.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFRepairViewController.h"
#import "FFDeviceInfo.h"

#define ContentText @"      受苹果公司新版系统影响,部分应用存在闪退等无法正常使用的情况.敬请安装防闪退工具.\n      如果185sy游戏出现闪退,无法打开等情况,可用此工具一键修复,并可随时联系客服反馈问题,强烈建议您安装."

@interface FFRepairViewController ()

@property (nonatomic, strong) UIView        *backView;
@property (nonatomic, strong) UIButton      *closeButton;
@property (nonatomic, strong) UIImageView   *logImageView;
@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UILabel       *contentLabel;

@property (nonatomic, strong) UIButton      *installButton;


@end

@implementation FFRepairViewController


+ (FFRepairViewController *)showRepairView {
    FFRepairViewController *controller = [[FFRepairViewController alloc] init];
    [[UIApplication sharedApplication].keyWindow addSubview:controller.view];
    [controller.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointZero);
        make.size.mas_equalTo([UIApplication sharedApplication].keyWindow.bounds.size);
    }];
    return controller;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUserInterface {
    [super initUserInterface];
    self.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.3];


    self.backView = [UIView hyb_viewWithSuperView:self.view constraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.bounds.size.width * 0.7, self.view.bounds.size.height * 0.6));
        make.center.mas_equalTo(CGPointZero);
    }];
    self.backView.backgroundColor = kWhiteColor;
    self.backView.layer.cornerRadius = 8;
    self.backView.layer.masksToBounds = YES;

    self.closeButton = [UIButton hyb_buttonWithImage:@"Game_repaire_close" superView:self.view constraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.backView.mas_right);
        make.bottom.mas_equalTo(self.backView.mas_top);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    } touchUp:^(UIButton *sender) {
        [self close];
    }];

    self.logImageView = [UIImageView hyb_imageViewWithImage:@"Game_repaire_logo" superView:self.backView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView).offset(30);
        make.centerX.mas_equalTo(0);
    }];

    self.titleLabel = [UILabel hyb_labelWithText:@"防闪退修复工具" font:18 superView:self.backView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logImageView.mas_bottom).offset(10);
        make.left.mas_equalTo(self.backView).offset(8);
        make.right.mas_equalTo(self.backView).offset(-8);
        make.height.mas_equalTo(30);
    }];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;

    self.installButton = [UIButton hyb_buttonWithTitle:@"立即安装" superView:self.backView constraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.backView).offset(-30);
        make.left.mas_equalTo(self.backView).offset(40);
        make.right.mas_equalTo(self.backView).offset(-40);
        make.height.mas_equalTo(30);
    } touchUp:^(UIButton *sender) {
        [self respondsToLeftButton];
    }];
    self.installButton.backgroundColor = [FFColorManager blue_dark];
    self.installButton.layer.cornerRadius = 15;
    self.installButton.layer.masksToBounds = YES;

    self.contentLabel = [UILabel hyb_labelWithText:ContentText font:14 superView:self.backView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel).offset(8);
        make.left.mas_equalTo(self.backView).offset(8);
        make.right.mas_equalTo(self.backView).offset(-8);
        make.bottom.mas_equalTo(self.installButton.mas_top).offset(-9);
    }];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textColor = [FFColorManager textColorLight];
    self.contentLabel.textAlignment = NSTextAlignmentJustified;
}

#pragma mark - method
- (void)show {

}

- (void)close {
    [self.view removeFromSuperview];
}

- (void)respondsToLeftButton {
    NSString *urlStrig = [NSString stringWithFormat:@"https://ipa.185sy.com/ios/fix/ios_app_%@.mobileconfig",Channel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStrig]];
}







@end
