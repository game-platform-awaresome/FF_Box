//
//  FFRepairViewController.m
//  GameBox
//
//  Created by 燚 on 2018/8/15.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFRepairViewController.h"
#import "FFDeviceInfo.h"

@interface FFRepairViewController ()

@property (nonatomic, strong) UIView    *backView;
@property (nonatomic, strong) UIButton  *closeButton;

@property (nonatomic, strong) UIButton  *installButton;


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

    self.closeButton = [UIButton hyb_buttonWithImage:@"" superView:self.view constraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.backView.mas_right);
        make.bottom.mas_equalTo(self.backView.mas_top);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    } touchUp:^(UIButton *sender) {
        [self close];
    }];
    self.closeButton.backgroundColor = kOrangeColor;


    self.installButton = [UIButton hyb_buttonWithTitle:@"立即安装" superView:self.backView constraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.backView).offset(-30);
        make.left.mas_equalTo(self.backView).offset(40);
        make.right.mas_equalTo(self.backView).offset(-40);
        make.height.mas_equalTo(44);
    } touchUp:^(UIButton *sender) {
        [self respondsToLeftButton];
    }];
    self.installButton.backgroundColor = [FFColorManager blue_dark];
    self.installButton.layer.cornerRadius = 22;
    self.installButton.layer.masksToBounds = YES;
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
