//
//  FFBusinessRecordViewController.m
//  GameBox
//
//  Created by 燚 on 2018/6/12.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessRecordViewController.h"

@interface FFBusinessRecordViewController ()

@end

@implementation FFBusinessRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initDataSource {
    [super initDataSource];
    self.selectView.headerTitleArray = @[@"已购买",@"审核中",@"出售中",@"已出售",@"仓库中"];
    self.selectChildVCNames = @[@"FFBusinessBoughtRecordController",
                                @"FFBusinessUnderReviewController",
                                @"FFBusinessSellingController",
                                @"FFBusinessSoldController",
                                @"FFBusinessWarehouseController"];
}

- (void)initUserInterface {
    [super initUserInterface];
    [self.leftButton setImage:[FFImageManager General_back_black]];
    self.navigationItem.leftBarButtonItem = self.leftButton;
    self.navigationItem.title = @"交易记录";
    [self.view addSubview:self.selectView];
    [self.scrollView setScrollEnabled:NO];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.selectView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, 44);
    self.scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.selectView.frame), kSCREEN_WIDTH, kSCREEN_HEIGHT -  CGRectGetMaxY(self.selectView.frame));
    int i = 0;
    for (UIViewController *vc in self.selectChildViewControllers) {
        vc.view.frame = CGRectMake(i++ * kSCREEN_WIDTH, 0, kSCREEN_WIDTH, self.scrollView.bounds.size.height);
    }
}

- (UIViewController *)creatControllerWithString:(NSString *)controllerString {
    Class ControllerClass = NSClassFromString(controllerString);
    id viewController = [[ControllerClass alloc] init];
    if (viewController == nil) {
        viewController = [[UIViewController alloc] init];
        syLog(@"\n!\n%s error message : %@ is not exist \n!",__func__,controllerString);
    }
    return viewController;
}

#pragma mark - setter
- (void)setSelectChildVCNames:(NSArray *)selectChildVCNames {
    NSMutableArray *vcarray = [NSMutableArray arrayWithCapacity:selectChildVCNames.count];
    for (NSString *name in selectChildVCNames) {
        [vcarray addObject:[self creatControllerWithString:name]];
    }
    self.selectChildViewControllers = vcarray;
}







@end









