//
//  FFBusinessNoticeViewController.m
//  GameBox
//
//  Created by 燚 on 2018/6/12.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessNoticeViewController.h"
#import <WebKit/WebKit.h>
#import "FFMapModel.h"

@interface FFBusinessNoticeViewController ()

@end

@implementation FFBusinessNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarBGAlpha = @"1.0";
}

- (void)initUserInterface {
    [super initUserInterface];
    [self.leftButton setImage:[FFImageManager General_back_black]];
    self.navigationItem.leftBarButtonItem = self.leftButton;
    self.webURL = Map.TRADE_NOTES_H5;
}







@end










