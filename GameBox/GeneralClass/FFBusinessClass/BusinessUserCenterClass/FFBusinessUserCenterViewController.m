//
//  FFBusinessUserCenterViewController.m
//  GameBox
//
//  Created by 燚 on 2018/6/12.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessUserCenterViewController.h"
#import "FFBusinessModel.h"

@interface FFBusinessUserCenterViewController ()

@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *signButton;
@property (nonatomic, strong) UIButton *modifyPasswordButton;

@end

@implementation FFBusinessUserCenterViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.title = @"我的账号";
    self.tableView.tableFooterView = self.footerView;
}


#pragma mark - responds
- (void)respondsToSignButton {
    [FFBusinessModel signOut];
    [self.navigationController popViewControllerAnimated:YES];
    [UIAlertController showAlertMessage:@"退出登录" dismissTime:0.7 dismissBlock:nil];
}
- (void)respondsToModifyPasswordButton {
    pushViewController(@"FFBusinessModifyPasswordController");
}

#pragma mark - getter
- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 60)];
        _footerView.backgroundColor = [FFColorManager navigation_bar_white_color];
        [_footerView addSubview:self.modifyPasswordButton];
        [_footerView addSubview:self.signButton];
    }
    return _footerView;
}

- (UIButton *)signButton {
    if (!_signButton) {
        _signButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _signButton.frame = CGRectMake(kSCREEN_WIDTH / 2, 0, kSCREEN_WIDTH / 2, 44);
        [_signButton setTitle:@"退出登录" forState:(UIControlStateNormal)];
        _signButton.backgroundColor = [FFColorManager blue_dark];
        [_signButton addTarget:self action:@selector(respondsToSignButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _signButton;
}

- (UIButton *)modifyPasswordButton {
    if (!_modifyPasswordButton) {
        _modifyPasswordButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _modifyPasswordButton.frame = CGRectMake(0, 0, kSCREEN_WIDTH / 2, 44);
        [_modifyPasswordButton setTitle:@"修改密码" forState:(UIControlStateNormal)];
        _modifyPasswordButton.backgroundColor = [FFColorManager blue_dark];
        [_modifyPasswordButton addTarget:self action:@selector(respondsToModifyPasswordButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _modifyPasswordButton;
}





@end


