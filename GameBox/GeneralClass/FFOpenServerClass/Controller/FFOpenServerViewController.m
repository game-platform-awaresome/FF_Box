//
//  FFOpenServerViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/18.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFOpenServerViewController.h"
#import "FFBTOpenServerViewController.h"
#import "FFZKOpenServerViewController.h"
#import "FFBoxModel.h"

@interface FFOpenServerViewController ()

@property (nonatomic, strong) NSArray *selectControllerNames;

@end

@implementation FFOpenServerViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"开服表";
}

- (void)initDataSource {
    [self refreshData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:NOTI_SET_DISCOUNT_VIEW object:nil];
}

- (void)refreshData {
    self.homeSelectView.titleArray = [FFBoxModel sharedModel].discount_enabled.boolValue ? @[@"BT服",@"折扣"] : @[@"BT服"] ;
    self.selectChildViewControllers = [FFBoxModel sharedModel].discount_enabled.boolValue ?
    @[[FFBTOpenServerViewController new], [FFZKOpenServerViewController new]].mutableCopy:
    @[[FFBTOpenServerViewController new]].mutableCopy;
    [self initUserInterface];
}



- (void)addFLoatView {
    
}




@end
