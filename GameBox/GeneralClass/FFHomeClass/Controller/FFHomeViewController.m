//
//  FFHomeViewController.m
//  GameBox
//
//  Created by 燚 on 2018/4/18.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFHomeViewController.h"
#import "FFRecommentViewController.h"

@interface FFHomeViewController ()

/** 4 sub-controllers */
@property (nonatomic, strong) FFRecommentViewController *recommentVC;



@end

@implementation FFHomeViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    syLog(@"home nav = %@",self.navigationController);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initUserInterface {
    [super initUserInterface];
    self.selectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.selectView];
    [self.view addSubview:self.scrollView];
}
 
- (void)initDataSource {
    self.selectView.headerTitleArray = @[@"推荐",@"新游",@"攻略",@"分类"];
    self.selectChildViewControllers = @[self.recommentVC,[UIViewController new],[UIViewController new],[UIViewController new]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.selectView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, 44);
    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.selectView.frame), kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.selectView.frame) - self.tabBarController.tabBar.frame.size.height);
    [self.scrollView setContentSize:CGSizeMake(kSCREEN_WIDTH * self.selectView.headerTitleArray.count, self.scrollView.frame.size.height)];
}


#pragma mark - getter
- (FFRecommentViewController *)recommentVC {
    if (!_recommentVC) {
        _recommentVC = [[FFRecommentViewController alloc] init];
    }
    return _recommentVC;
}







@end
