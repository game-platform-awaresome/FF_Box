//
//  FFSignInViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/23.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFSignInViewController.h"
#import "FFUserModel.h"
#import "FFColorManager.h"
#import "FFImageManager.h"

@interface FFSignInViewController ()

/** 上半部分背景 */
@property (nonatomic, strong) UIImageView       *topImageView;
/** 签到按钮 */
@property (nonatomic, strong) UIButton          *signInButton;
/** 红色签到按钮 */
@property (nonatomic, strong) UIButton          *redSigninButton;
/** 签到累计天数虚线 */
@property (nonatomic, strong) UIImageView       *singinLine;
/** 累计签到奖励 */
@property (nonatomic, strong) NSArray<UIButton*>*signDayButtons;
/** 累计签到天数 */
@property (nonatomic, strong) NSArray<UILabel *>*signDayLabels;
/** 下半部分背景 */
@property (nonatomic, strong) UIView            *bottomView;
/** 累计签到天数提示 */
@property (nonatomic, strong) UILabel           *remindLabel;


/** 签到说明 */
@property (nonatomic, strong) UILabel           *signInDescriptionTitle;
@property (nonatomic, strong) UIView            *signInDescriptionDetail;

/** 签到说明标题数组 */
@property (nonatomic, strong) NSArray           *descriptionTitleArray;
/** 签到说明内容数组 */
@property (nonatomic, strong) NSArray           *descriptionContentArray;
/** 点到说明数据 */
@property (nonatomic, strong) NSArray<UILabel *>*descriptionContentLabels;



#pragma mark - 旧界面 废弃
/** 签到主页 */
@property (nonatomic, strong) UIView *signInView;

@property (nonatomic, strong) NSArray<UILabel *> *dayLabelArray;
@property (nonatomic, strong) NSArray<UILabel *> *daytitleArray;
@property (nonatomic, strong) UIView *line;





/** 累计特殊奖励 */
@property (nonatomic, strong) NSArray *specialRewardsArray;
/** 每日奖励 */
@property (nonatomic, strong) NSDictionary *normalRewardsDict;
/** 每月天数 */
@property (nonatomic, strong) NSString *days;
/** 累计签到天数 */
@property (nonatomic, strong) NSString *signDays;
/** 继续签到 */
@property (nonatomic, strong) NSString *continueSignDays;
/** 今日签到 */
@property (nonatomic, strong) NSString *isSign;



@end

@implementation FFSignInViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navBarBGAlpha = @"0.0";
    [self.navigationController.navigationBar setTintColor:[FFColorManager navigation_bar_white_color]];
    [self signInit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initDataSource {
    [super initDataSource];
}


- (void)initUserInterface {
    [super initUserInterface];
    
    self.navigationItem.title = @"";
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH / 2, 30)];
    titleLabel.text = @"签到";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [FFColorManager navigation_bar_white_color];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.navigationItem.titleView = titleLabel;

    [self.leftButton setImage:[FFImageManager General_back_white]];
    self.view.backgroundColor = RGBColor(227, 232, 244);
    [self.navigationController.navigationBar setTintColor:kWhiteColor];
    [self.navigationController.navigationBar setBarTintColor:kWhiteColor];
    self.navigationItem.leftBarButtonItem = self.leftButton;


    /** 添加上半部分背景 */
    self.topImageView = [UIImageView hyb_imageViewWithImage:@"Sign_top_image" superView:self.view constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(0);
        make.left.mas_equalTo(self.view).offset(0);
        make.right.mas_equalTo(self.view).offset(0);
        make.height.mas_equalTo(kScreenHeight * 0.5);
    }];
    self.topImageView.userInteractionEnabled = YES;


    /** 添加签到按钮 */
    self.signInButton = [UIButton hyb_buttonWithImage:@"Sing_button_image" superView:self.topImageView constraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topImageView).offset(-4);
        make.top.mas_equalTo(self.topImageView).offset(80);
    } touchUp:^(UIButton *sender) {
        [self respondsToSignInButton];
    }];
    [self.signInButton setTitle:@" 每日签到" forState:(UIControlStateNormal)];
    [self.signInButton setTitle:@" 已签到" forState:(UIControlStateSelected)];
    [self.signInButton setBackgroundImage:[UIImage imageNamed:@"Sign_button_back"] forState:(UIControlStateNormal)];

    /** 添加签到累计天数虚线 */
    self.singinLine = [UIImageView hyb_imageViewWithImage:@"Sign_day_line" superView:self.topImageView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.signInButton.mas_bottom).offset(66);
        make.left.mas_equalTo(self.topImageView).offset(10);
        make.right.mas_equalTo(self.topImageView).offset(-10);
    }];

    /** 添加累计奖励标识 */
    NSArray *titleArray = @[@"20",@"50",@"100",@"200"];
    NSMutableArray<UIButton *> *buttonArray = [NSMutableArray arrayWithCapacity:titleArray.count];
    for (int i = 0; i < titleArray.count; i++) {
        NSString *title = titleArray[i];
        UIButton *button = [UIButton hyb_buttonWithTitle:title superView:self.singinLine constraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.centerX.mas_equalTo(kScreenWidth / 5 * (i - 1.5));
        } touchUp:nil];
        [button setBackgroundImage:[UIImage imageNamed:@"Sign_day_back"] forState:(UIControlStateNormal)];
        button.userInteractionEnabled = NO;
        [buttonArray addObject:button];
    }
    self.signDayButtons = buttonArray;

    /** 添加累计天数 */
    titleArray = @[@"3天",@"7天",@"15天",@"本月"];
    NSMutableArray<UILabel *> *labelArray = [NSMutableArray arrayWithCapacity:titleArray.count];
    for (int i = 0; i < titleArray.count; i++) {
        NSString *title = titleArray[i];
        UILabel *label = [UILabel hyb_labelWithText:title font:15 superView:self.topImageView constraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(buttonArray[i].mas_centerX).offset(0);
            make.bottom.mas_equalTo(buttonArray[i].mas_top).offset(-12);
        }];
        label.textColor = kWhiteColor;
        label.font = [UIFont boldSystemFontOfSize:15];
        [labelArray addObject:label];
    }
    self.signDayLabels = labelArray;

    /** 添加下半部分背景 */
    self.bottomView = [UIView hyb_viewWithSuperView:self.view constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topImageView.mas_bottom).offset(-30);
        make.left.mas_equalTo(self.view).offset(12);
        make.bottom.mas_equalTo(self.view).offset(-14);
        make.right.mas_equalTo(self.view).offset(-12);
    }];
    self.bottomView.backgroundColor = kWhiteColor;
    self.bottomView.layer.cornerRadius = 8;
    self.bottomView.layer.shadowColor = RGBColor(227, 232, 242).CGColor;
    self.bottomView.layer.shadowOffset = CGSizeMake(0, 0);
    self.bottomView.layer.shadowOpacity = 1.f;

    /** 添加红色签到按钮 */
    self.redSigninButton = [UIButton hyb_buttonWithImage:@"Sign_red_button_normal" selectedImage:@"Sign_red_button_select" superView:self.view constraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.topImageView.mas_bottom).offset(-10);
        make.right.mas_equalTo(self.topImageView.mas_right).offset(-35);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    } touchUp:^(UIButton *sender) {
        [self respondsToSignInButton];
    }];

    /** 签到提示 */
    self.remindLabel = [UILabel hyb_labelWithFont:14 superView:self.bottomView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bottomView).offset(10);
        make.left.mas_equalTo(self.bottomView).offset(10);
        make.right.mas_equalTo(self.bottomView).offset(-10);
        make.height.mas_equalTo(45);
    }];
    self.remindLabel.textAlignment = NSTextAlignmentLeft;

    /** 签到说明 */
    self.signInDescriptionTitle = [UILabel hyb_labelWithText:@"签到说明" font:18 superView:self.bottomView constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.remindLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(self.bottomView).offset(10);
        make.right.mas_equalTo(self.bottomView).offset(-10);
    }];


    UILabel *lastTitleLabel;
    UILabel *lastContentLabel;
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:self.descriptionTitleArray.count];
    for (int i = 0; i < self.descriptionTitleArray.count; i++) {
        UILabel *titlelabel = [UILabel hyb_labelWithText:self.descriptionTitleArray[i] font:16 superView:self.bottomView constraints:^(MASConstraintMaker *make) {
            if (lastContentLabel) {
                make.top.mas_equalTo(lastContentLabel.mas_bottom).offset(10);
            } else {
                make.top.mas_equalTo(self.signInDescriptionTitle.mas_bottom).offset(10);
            }
            make.left.mas_equalTo(self.bottomView).offset(10);
            make.right.mas_equalTo(self.bottomView).offset(-10);
        }];
        UILabel *contentLabel = [UILabel hyb_labelWithText:self.descriptionContentArray[i] font:12 lines:0 superView:self.bottomView constraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titlelabel.mas_bottom).offset(4);
            make.left.mas_equalTo(self.bottomView).offset(10);
            make.right.mas_equalTo(self.bottomView).offset(-10);
        }];
        contentLabel.textColor = [FFColorManager textColorMiddle];

        lastTitleLabel = titleLabel;
        lastContentLabel = contentLabel;
        [mutableArray addObject:contentLabel];
    }

    self.descriptionContentLabels = mutableArray;

}

- (void)signInit {
    for (UILabel *label in self.dayLabelArray) {
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = RGBColor(100, 100, 100);
    }
    self.view.userInteractionEnabled = NO;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [FFUserModel signInitWithCompletion:^(NSDictionary *content, BOOL success) {
        syLog(@"sign init == %@",content);
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        self.view.userInteractionEnabled = YES;
        if (success) {
            //特殊奖励
            self.specialRewardsArray = content[@"data"][@"accum_bonus"];
            //每日奖励
            self.normalRewardsDict = content[@"data"][@"day_bonus"];
            //每月天数
            self.days = content[@"data"][@"days"];
            //累计签到
            self.signDays = content[@"data"][@"sign_counts"];
            //今日签到
            self.isSign = content[@"data"][@"today_is_sign"];
            //继续签到
            [self setContinueSignDay];

            self.remindLabel.attributedText = [self colocStringWithString1:[NSString stringWithFormat:@" %@ ",self.signDays] String2:self.continueSignDays];

        } else {
            [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
}



#pragma mark -  responds
- (void)respondsToLeftButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)respondsToSignInButton {
    [FFUserModel doSignWithCompletion:^(NSDictionary *content, BOOL success) {
        if (success) {
            syLog(@"sign === %@",content);
            NSInteger indx = self.signDays.integerValue;
            indx++;
            self.signDays = [NSString stringWithFormat:@"%ld",indx];
            [self setContinueSignDay];
            self.remindLabel.attributedText = [self colocStringWithString1:[NSString stringWithFormat:@" %@ ",self.signDays] String2:self.continueSignDays];
            self.isSign = @"1";
#warning  签到 统计
            [UIAlertController showAlertMessage:@"签到成功" dismissTime:0.8 dismissBlock:nil];
        } else {
            [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:nil];
        }
    }];
}

- (NSMutableAttributedString *)colocStringWithString1:(NSString *)string1 String2:(NSString *)string2 {
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:string1];
    [attributedString1 addAttribute:NSForegroundColorAttributeName value:[FFColorManager blue_dark] range:NSMakeRange(0, attributedString1.length)];
    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithString:@"本月已累计签到"];
    [resultString appendAttributedString:attributedString1];
    attributedString1 = [[NSMutableAttributedString alloc] initWithString:@"天,"];
    [resultString appendAttributedString:attributedString1];
    attributedString1 = [[NSMutableAttributedString alloc] initWithString:@"继续签到"];
    [resultString appendAttributedString:attributedString1];
    attributedString1 = [[NSMutableAttributedString alloc] initWithString:string2];
    [attributedString1 addAttribute:NSForegroundColorAttributeName value:[FFColorManager blue_dark] range:NSMakeRange(0, attributedString1.length)];
    [resultString appendAttributedString:attributedString1];
    attributedString1 = [[NSMutableAttributedString alloc] initWithString:@"天可获得额外奖励"];
    [resultString appendAttributedString:attributedString1];
    return resultString;
}

#pragma mark - setter
/** 签到数组 */
- (void)setSpecialRewardsArray:(NSArray *)specialRewardsArray {
    _specialRewardsArray = [specialRewardsArray copy];
    [_specialRewardsArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        self.daytitleArray[idx].text = [NSString stringWithFormat:@"%@天",obj[@"num"]];
        self.dayLabelArray[idx].text = [NSString stringWithFormat:@"%@",obj[@"bonus"]];
    }];

    self.self.descriptionContentLabels[1].text = [NSString stringWithFormat:@"累计签到%@天,额外获取%@金币,累计签到%@天,额外获取%@金币,累计签到%@天,额外获取%@金币,本月全部签到,额外获取%@金币.",(_specialRewardsArray[0][@"num"]),(_specialRewardsArray[0][@"bonus"]),(_specialRewardsArray[1][@"num"]),(_specialRewardsArray[1][@"bonus"]),(_specialRewardsArray[2][@"num"]),(_specialRewardsArray[2][@"bonus"]),(_specialRewardsArray[3][@"bonus"])];
}

/** 签到奖励 */
- (void)setNormalRewardsDict:(NSDictionary *)normalRewardsDict {
    _normalRewardsDict = [normalRewardsDict copy];
    self.descriptionContentLabels[0].text = [NSString stringWithFormat:@"普通用户每日签到随机获取%@金币,vip用户额外获得%@金币.",_normalRewardsDict[@"normal"],_normalRewardsDict[@"vip_extra"]];
}

/** 设置是否签到 */
- (void)setIsSign:(NSString *)isSign {
    if (isSign) {
        _isSign = [NSString stringWithFormat:@"%@",isSign];
        if (isSign.boolValue) {
            self.signInButton.userInteractionEnabled = NO;
            self.signInButton.selected = YES;
            self.redSigninButton.userInteractionEnabled = NO;
            self.redSigninButton.selected = YES;
        } else {
            self.signInButton.userInteractionEnabled = YES;
            self.signInButton.selected = NO;
            self.redSigninButton.userInteractionEnabled = YES;
            self.redSigninButton.selected = NO;
        }
    }
}


/** 设置继续签到天数 */
- (void)setContinueSignDay {
    if (self.specialRewardsArray) {
        NSInteger signDays = self.signDays.integerValue;
        NSInteger currentDay = 0;
        for (NSInteger i = 0; i < self.specialRewardsArray.count; i++) {
            NSString *day = self.self.specialRewardsArray[i][@"num"];
            currentDay = day.integerValue;
            if (signDays == currentDay) {
                self.dayLabelArray[i].backgroundColor = [FFColorManager blue_dark];
                self.dayLabelArray[i].textColor = [UIColor whiteColor];
            }
            if (i == (self.specialRewardsArray.count - 1)) {
                self.continueSignDays = @"0";
            }
            if (currentDay > signDays) {
                self.continueSignDays = [NSString stringWithFormat:@" %ld ",(currentDay - signDays)];
                break;
            }
        }
    }
}


#pragma mark - getter
- (NSArray *)descriptionTitleArray {
    if (!_descriptionTitleArray) {
        _descriptionTitleArray = @[@"1.每日签到",
                                   @"2.签到规则",
                                   @"3.累计签到奖励",
                                   @"4.签到金币未到账"];
    }
    return _descriptionTitleArray;
}

- (NSArray *)descriptionContentArray {
    if (!_descriptionContentArray) {
        _descriptionContentArray = @[@"普通用户每日签到随机获取3~10金币,vip用户额外获得66金币.",
                                     @"累计签到3天,额外获取20金币,累计签到7天,额外获取50金币,累计签到15天,额外获取100金币,本月全部签到,额外获取200金币.",
                                     @"签到界面展示本月内累计签到天数,本月签到天数只在本月有效,下个月累计签到天数清零,并重新计数.",
                                     @"请在24小时之内联系客户经理,客服确认信息后,后台会给您补发金币."];
    }
    return _descriptionContentArray;
}















@end



