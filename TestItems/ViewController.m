//
//  ViewController.m
//  TestItems
//
//  Created by 燚 on 2018/9/13.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "ViewController.h"
#import <FFTools/FFTools.h>
#import "FFQuestionViewController.h"
#import <Masonry.h>

@interface ViewController ()




@end

@implementation ViewController



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setTintColor:fBlackColor];
    [self.navigationController.navigationBar setBarTintColor:ff_RGBColor(144, 144, 242)];
    //    [self.navigationController.navigationBar setBackgroundColor:ff_RGBColor(144, 144, 144)];
    [self.navigationController.navigationBar setShadowImage:[UIColor ff_imageWithColor:[UIColor clearColor] size:CGSizeMake(fScreenWidth, 1)]];
    //        [self.navigationController.navigationBar setBackgroundImage:[UIColor ff_imageWithColor:ff_RGBColor(242, 242, 242) size:CGSizeMake(fScreenWidth, 44)] forBarMetrics:(UIBarMetricsDefault)];
    self.navBarBGAlpha = @"1.0";
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    self.title = @"单元测试";
    UIButton *test1Button = [UIButton ff_buttonWithTitle:@"测试回答问题" SuperView:self.view Constraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointZero);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth * 0.8, 44));
    } TouchUp:^(UIButton *sender) {
        [[self navigationController] pushViewController:[FFQuestionViewController QuestionViewControllerWithGame:@"21"] animated:YES];
    }];
    test1Button.backgroundColor = [UIColor blueColor];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}









@end




















