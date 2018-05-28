//
//  FFAboutViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/23.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFAboutViewController.h"

@interface FFAboutViewController ()

//logo
@property (nonatomic, strong) UIImageView *imageView;
//官网
@property (nonatomic, strong) UIView *viewIE;
//微博
@property (nonatomic, strong) UIView *viewWeiBo;
//微信
@property (nonatomic, strong) UIView *viewWeixin;
//文字
@property (nonatomic, strong) UIImageView *wenzi;
//版本
@property (nonatomic, strong) UILabel *version;



@end

@implementation FFAboutViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navBarBGAlpha = @"1.0";
    [self.navigationController.navigationBar setTintColor:[FFColorManager navigation_bar_black_color]];
    [self.navigationController.navigationBar setBarTintColor:[FFColorManager navigation_bar_white_color]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUserInterFace];
}


- (void)initUserInterFace {
    //    self.view.backgroundColor = RGBCOLOR(228, 217, 219);
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"关于我们";
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.version];
    [self.view addSubview:self.viewIE];
    //    [self.view addSubview:self.viewWeiBo];
    [self.view addSubview:self.viewWeixin];
    [self.view addSubview:self.wenzi];
}

#pragma mark - getter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.bounds = CGRectMake(0, 0, 80, 80);
        _imageView.center = CGPointMake(kSCREEN_WIDTH / 2, 140);

        _imageView.image = [UIImage imageNamed:@"Mine_logo_image"];
        _imageView.layer.cornerRadius = 8;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

- (UILabel *)version {
    if (!_version) {
        _version = [[UILabel alloc] init];
        _version.bounds = CGRectMake(0, 0, kSCREEN_WIDTH, 44);
        _version.center = CGPointMake(kSCREEN_WIDTH / 2, 200);
        _version.textAlignment = NSTextAlignmentCenter;
        _version.textColor = [FFColorManager textColorDark];
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        _version.text = [NSString stringWithFormat:@"当前版本:%@",[infoDic objectForKey:@"CFBundleShortVersionString"]];
    }
    return _version;
}


- (UIView *)viewIE {
    if (!_viewIE) {
        _viewIE = [[UIView alloc] init];
        _viewIE.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _viewIE.center = CGPointMake(kSCREEN_WIDTH / 2, 270);

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 12, 20, 20)];
        imageView.image = [UIImage imageNamed:@"aboutus_IE"];
        [_viewIE addSubview:imageView];

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(50, 7, kSCREEN_WIDTH - 100, 30)];
        title.text = @"官网地址: www.185sy.com";
        title.font = [UIFont systemFontOfSize:16];
        [_viewIE addSubview:title];

        //        _viewIE.backgroundColor = RGBCOLOR(201, 194, 194);
        _viewIE.backgroundColor = BACKGROUND_COLOR;
        _viewIE.layer.cornerRadius = 22;
        _viewIE.layer.masksToBounds = YES;

    }
    return _viewIE;
}



- (UIView *)viewWeiBo {
    if (!_viewWeiBo) {
        _viewWeiBo = [[UIView alloc] init];
        _viewWeiBo.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _viewWeiBo.center = CGPointMake(kSCREEN_WIDTH / 2, 335);

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 12, 20, 20)];
        imageView.image = [UIImage imageNamed:@"aboutus_weibo"];
        [_viewWeiBo addSubview:imageView];

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(50, 7, kSCREEN_WIDTH - 100, 30)];
        title.text = @"官方微博: www.185sy.com";
        title.font = [UIFont systemFontOfSize:16];
        [_viewWeiBo addSubview:title];

        _viewWeiBo.backgroundColor = RGBCOLOR(201, 194, 194);
        _viewWeiBo.layer.cornerRadius = 22;
        _viewWeiBo.layer.masksToBounds = YES;

    }
    return _viewWeiBo;
}


- (UIView *)viewWeixin {
    if (!_viewWeixin) {
        _viewWeixin = [[UIView alloc] init];
        _viewWeixin.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.8, 44);
        _viewWeixin.center = CGPointMake(kSCREEN_WIDTH / 2, 335);

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 12, 20, 20)];
        imageView.image = [UIImage imageNamed:@"aboutus_weixin"];
        [_viewWeixin addSubview:imageView];

        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(50, 7, kSCREEN_WIDTH - 100, 30)];
        title.text = @"微信公众号: 益起玩手游";
        title.font = [UIFont systemFontOfSize:16];
        [_viewWeixin addSubview:title];

        //        _viewWeixin.backgroundColor = RGBCOLOR(201, 194, 194);
        _viewWeixin.backgroundColor = BACKGROUND_COLOR;
        _viewWeixin.layer.cornerRadius = 22;
        _viewWeixin.layer.masksToBounds = YES;

    }
    return _viewWeixin;
}

- (UIImageView *)wenzi {
    if (!_wenzi) {
        _wenzi = [[UIImageView alloc] init];
        _wenzi.bounds = CGRectMake(0, 0, 188, 25);

        _wenzi.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT - 100);

        _wenzi.image = [UIImage imageNamed:@"aboutus_wenzi"];

    }
    return _wenzi;
}







@end
