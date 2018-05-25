//
//  FFSignInViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/23.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFSignInViewController.h"
#import "FFUserModel.h"

@interface FFSignInViewController ()

/** 签到主页 */
@property (nonatomic, strong) UIView *signInView;
/** 签到按钮 */
@property (nonatomic, strong) UIButton *signInButton;
@property (nonatomic, strong) UILabel *remindLabel;
@property (nonatomic, strong) NSArray<UILabel *> *dayLabelArray;
@property (nonatomic, strong) NSArray<UILabel *> *daytitleArray;
@property (nonatomic, strong) UIView *line;

/** 签到说明 */
@property (nonatomic, strong) UILabel *signInDescriptionTitle;
@property (nonatomic, strong) UIView *signInDescriptionDetail;
/** 签到说明1 */
@property (nonatomic, strong) UILabel *descriptionTitle1;
@property (nonatomic, strong) UILabel *descriptionDetail1;
/** 签到说明2 */
@property (nonatomic, strong) UILabel *descriptionTitle2;
@property (nonatomic, strong) UILabel *descriptionDetail2;
/** 签到说明3 */
@property (nonatomic, strong) UILabel *descriptionTitle3;
@property (nonatomic, strong) UILabel *descriptionDetail3;
/** 签到说明4 */
@property (nonatomic, strong) UILabel *descriptionTitle4;
@property (nonatomic, strong) UILabel *descriptionDetail4;

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
    self.navBarBGAlpha = @"1.0";
    [self signInit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}


- (void)initUserInterface {

    self.navigationItem.title = @"签到";
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.signInView];
    [self.view addSubview:self.signInDescriptionTitle];
    [self.view addSubview:self.signInDescriptionDetail];

    self.remindLabel.attributedText = [self colocStringWithString1:@" 0 " String2:@" 0 "];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, CGRectGetMaxY(self.navigationController.navigationBar.frame))];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
}

- (void)signInit {
    for (UILabel *label in self.dayLabelArray) {
        label.backgroundColor = [UIColor whiteColor];
//        label.textColor = RGBCOLOR(<#r#>, <#g#>, <#b#>);
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
    //    [self.navigationController popViewControllerAnimated:YES];

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

    self.descriptionDetail2.text = [NSString stringWithFormat:@"累计签到%@天,额外获取%@金币,累计签到%@天,额外获取%@金币,累计签到%@天,额外获取%@金币,本月全部签到,额外获取%@金币.",(_specialRewardsArray[0][@"num"]),(_specialRewardsArray[0][@"bonus"]),(_specialRewardsArray[1][@"num"]),(_specialRewardsArray[1][@"bonus"]),(_specialRewardsArray[2][@"num"]),(_specialRewardsArray[2][@"bonus"]),(_specialRewardsArray[3][@"bonus"])];
}

/** 签到奖励 */
- (void)setNormalRewardsDict:(NSDictionary *)normalRewardsDict {
    _normalRewardsDict = [normalRewardsDict copy];
    self.descriptionDetail1.text = [NSString stringWithFormat:@"普通用户每日签到随机获取%@金币,vip用户额外获得%@金币.",_normalRewardsDict[@"normal"],_normalRewardsDict[@"vip_extra"]];
}

/** 设置是否签到 */
- (void)setIsSign:(NSString *)isSign {
    if (isSign) {
        _isSign = [NSString stringWithFormat:@"%@",isSign];
        if (isSign.boolValue) {
            self.signInButton.userInteractionEnabled = NO;
            self.signInButton.backgroundColor = [UIColor whiteColor];
            self.signInButton.selected = YES;
        } else {
            self.signInButton.userInteractionEnabled = YES;
            self.signInButton.selected = NO;
            self.signInButton.backgroundColor = [FFColorManager blue_dark];
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
- (UIView *)signInView {
    if (!_signInView) {
        _signInView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), kSCREEN_WIDTH, kSCREEN_HEIGHT * 0.33)];
        _signInView.backgroundColor = [UIColor whiteColor];
        [_signInView addSubview:self.signInButton];
        [_signInView addSubview:self.remindLabel];
        [_signInView addSubview:self.line];
        for (UILabel *label in self.dayLabelArray) {
            [_signInView addSubview:label];
        }
        for (UILabel *label in self.daytitleArray) {
            [_signInView addSubview:label];
        }
    }
    return _signInView;
}

- (UIButton *)signInButton {
    if (!_signInButton) {
        _signInButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _signInButton.bounds = CGRectMake(0, 0, kSCREEN_WIDTH / 3, kSCREEN_WIDTH * 0.17);
        _signInButton.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_WIDTH * 0.17);
        _signInButton.layer.cornerRadius = kSCREEN_WIDTH * 0.085;
        [_signInButton addTarget:self action:@selector(respondsToSignInButton) forControlEvents:(UIControlEventTouchUpInside)];

        [_signInButton setTitle:@"签到" forState:(UIControlStateNormal)];
        [_signInButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _signInButton.layer.borderColor = [FFColorManager blue_dark].CGColor;

        [_signInButton setTitle:@"已签到" forState:(UIControlStateSelected)];
        [_signInButton setTitleColor:[FFColorManager blue_dark] forState:(UIControlStateSelected)];

        _signInButton.backgroundColor = [UIColor whiteColor];
        _signInButton.titleLabel.font = [UIFont systemFontOfSize:30];
        //        _signInButton.backgroundColor = RGBCOLOR(251, 193, 92);
        _signInButton.layer.masksToBounds = YES;
        _signInButton.layer.borderWidth = 3;
    }
    return _signInButton;
}

- (UILabel *)remindLabel {
    if (!_remindLabel) {
        _remindLabel = [[UILabel alloc] init];
        _remindLabel.bounds = CGRectMake(0, 0, kSCREEN_WIDTH, 30);
        CGFloat y = (CGRectGetMinY(self.dayLabelArray.lastObject.frame) + CGRectGetMaxY(self.signInButton.frame)) / 2;
        _remindLabel.font = [UIFont systemFontOfSize:14];
        _remindLabel.textAlignment = NSTextAlignmentCenter;
        _remindLabel.center = CGPointMake(kSCREEN_WIDTH / 2, y);
        //        _remindLabel.text = @"本月已累计签到2天,继续签到1天可获得额外奖励";
    }
    return _remindLabel;
}

- (NSArray<UILabel *> *)dayLabelArray {
    if (!_dayLabelArray) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];
        NSArray *titleArray = @[@"3天",@"7天",@"15天",@"本月"];
        [titleArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {

            UILabel *label = [[UILabel alloc] init];
            label.bounds = CGRectMake(0, 0, kSCREEN_WIDTH / 8, kSCREEN_WIDTH / 8);
            label.center = CGPointMake(kSCREEN_WIDTH / 5 * (idx + 1), kSCREEN_WIDTH * 0.426);
            label.text = obj;
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [FFColorManager blue_dark];
            label.backgroundColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:16];
            label.layer.cornerRadius = kSCREEN_WIDTH / 16;
            label.layer.masksToBounds = YES;
            label.layer.borderColor = [FFColorManager blue_dark].CGColor;
            label.layer.borderWidth = 2;


            [array addObject:label];
        }];
        _dayLabelArray = [array copy];
    }
    return _dayLabelArray;
}

- (NSArray<UILabel *> *)daytitleArray {
    if (!_daytitleArray) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];
        NSArray *titleArray = @[@"3天",@"7天",@"15天",@"本月"];

        [titleArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {

            UILabel *label = [[UILabel alloc] init];
            label.bounds = CGRectMake(0, 0, kSCREEN_WIDTH / 7, 20);
            label.center = CGPointMake(kSCREEN_WIDTH / 5 * (idx + 1), CGRectGetMaxY(self.dayLabelArray[0].frame) + 13);
            label.text = obj;
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor darkGrayColor];
            label.backgroundColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:13];

            [array addObject:label];
        }];
        _daytitleArray = [array copy];
    }
    return _daytitleArray;
}

- (UIView *)line {
    if (!_line) {
        CGFloat x = CGRectGetMidX(self.dayLabelArray.firstObject.frame) - 1;
        CGFloat y = CGRectGetMidY(self.dayLabelArray.firstObject.frame);
        CGFloat width = CGRectGetMidX(self.dayLabelArray.lastObject.frame) - x;
        CGFloat height = 3;
        _line = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _line.backgroundColor = [FFColorManager blue_dark];
    }
    return _line;
}

- (UILabel *)signInDescriptionTitle {
    if (!_signInDescriptionTitle) {
        _signInDescriptionTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.signInView.frame) + 10, kSCREEN_WIDTH, 44)];
        _signInDescriptionTitle.textAlignment = NSTextAlignmentLeft;
        _signInDescriptionTitle.backgroundColor = [UIColor whiteColor];
        _signInDescriptionTitle.text = @"    签到说明:";
        _signInDescriptionTitle.font = [UIFont systemFontOfSize:18];
    }
    return _signInDescriptionTitle;
}

- (UIView *)signInDescriptionDetail {
    if (!_signInDescriptionDetail) {
        _signInDescriptionDetail = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.signInDescriptionTitle.frame) + 3, kSCREEN_WIDTH, kSCREEN_HEIGHT - (CGRectGetMaxY(self.signInDescriptionTitle.frame) + 3))];
        _signInDescriptionDetail.backgroundColor = [UIColor whiteColor];
        [_signInDescriptionDetail addSubview:self.descriptionTitle1];
        [_signInDescriptionDetail addSubview:self.descriptionTitle2];
        [_signInDescriptionDetail addSubview:self.descriptionTitle3];
        [_signInDescriptionDetail addSubview:self.descriptionTitle4];
        [_signInDescriptionDetail addSubview:self.descriptionDetail1];
        [_signInDescriptionDetail addSubview:self.descriptionDetail2];
        [_signInDescriptionDetail addSubview:self.descriptionDetail3];
        [_signInDescriptionDetail addSubview:self.descriptionDetail4];
    }
    return _signInDescriptionDetail;
}

- (UILabel *)descriptionTitle1 {
    if (!_descriptionTitle1) {
        _descriptionTitle1 = [[UILabel alloc] init];
        _descriptionTitle1.frame = CGRectMake(20, 0, kSCREEN_WIDTH - 40, 30);
        _descriptionTitle1.text = @"1.每日签到";
    }
    return _descriptionTitle1;
}

- (UILabel *)descriptionDetail1 {
    if (!_descriptionDetail1) {
        _descriptionDetail1 = [[UILabel alloc] init];
        _descriptionDetail1.frame = CGRectMake(20, CGRectGetMaxY(self.descriptionTitle1.frame), kSCREEN_WIDTH - 40, 60);
        _descriptionDetail1.textColor = [UIColor lightGrayColor];
        _descriptionDetail1.text = @"普通用户每日签到随机获取3~10金币,vip用户额外获得66金币.";
        _descriptionDetail1.numberOfLines = 0;
        _descriptionDetail1.font = [UIFont systemFontOfSize:14];
        [_descriptionDetail1 sizeToFit];
    }
    return _descriptionDetail1;
}

- (UILabel *)descriptionTitle2 {
    if (!_descriptionTitle2) {
        _descriptionTitle2 = [[UILabel alloc] init];
        _descriptionTitle2.frame = CGRectMake(20, CGRectGetMaxY(self.descriptionDetail1.frame), kSCREEN_WIDTH - 40, 30);
        _descriptionTitle2.text = @"2.累计签到奖励";
    }
    return _descriptionTitle2;
}

- (UILabel *)descriptionDetail2 {
    if (!_descriptionDetail2) {
        _descriptionDetail2 = [[UILabel alloc] init];
        _descriptionDetail2.frame = CGRectMake(20, CGRectGetMaxY(self.descriptionTitle2.frame), kSCREEN_WIDTH - 40, 60);
        _descriptionDetail2.textColor = [UIColor lightGrayColor];
        _descriptionDetail2.text = @"累计签到3天,额外获取20金币,累计签到7天,额外获取50金币,累计签到15天,额外获取100金币,本月全部签到,额外获取200金币.";
        _descriptionDetail2.numberOfLines = 0;
        _descriptionDetail2.font = [UIFont systemFontOfSize:14];
        [_descriptionDetail2 sizeToFit];
    }
    return _descriptionDetail2;
}

- (UILabel *)descriptionTitle3 {
    if (!_descriptionTitle3) {
        _descriptionTitle3 = [[UILabel alloc] init];
        _descriptionTitle3.frame = CGRectMake(20, CGRectGetMaxY(self.descriptionDetail2.frame), kSCREEN_WIDTH - 40, 30);
        _descriptionTitle3.text = @"3.签到规则";
    }
    return _descriptionTitle3;
}

- (UILabel *)descriptionDetail3 {
    if (!_descriptionDetail3) {
        _descriptionDetail3 = [[UILabel alloc] init];
        _descriptionDetail3.frame = CGRectMake(20, CGRectGetMaxY(self.descriptionTitle3.frame), kSCREEN_WIDTH - 40, 60);
        _descriptionDetail3.textColor = [UIColor lightGrayColor];
        _descriptionDetail3.text = @"签到界面展示本月内累计签到天数,本月签到天数只在本月有效,下个月累计签到天数清零,并重新计数.";
        _descriptionDetail3.numberOfLines = 0;
        _descriptionDetail3.font = [UIFont systemFontOfSize:14];
        [_descriptionDetail3 sizeToFit];
    }
    return _descriptionDetail3;
}

- (UILabel *)descriptionTitle4 {
    if (!_descriptionTitle4) {
        _descriptionTitle4 = [[UILabel alloc] init];
        _descriptionTitle4.frame = CGRectMake(20, CGRectGetMaxY(self.descriptionDetail3.frame), kSCREEN_WIDTH - 40, 30);
        _descriptionTitle4.text = @"4.签到金币未到账";
    }
    return _descriptionTitle4;
}

- (UILabel *)descriptionDetail4 {
    if (!_descriptionDetail4) {
        _descriptionDetail4 = [[UILabel alloc] init];
        _descriptionDetail4.frame = CGRectMake(20, CGRectGetMaxY(self.descriptionTitle4.frame), kSCREEN_WIDTH - 40, 60);
        _descriptionDetail4.textColor = [UIColor lightGrayColor];
        _descriptionDetail4.text = @"请在24小时之内联系客户经理,客服确认信息后,后台会给您补发金币.";
        _descriptionDetail4.numberOfLines = 0;
        _descriptionDetail4.font = [UIFont systemFontOfSize:14];
        [_descriptionDetail4 sizeToFit];
    }
    return _descriptionDetail4;
}






@end



