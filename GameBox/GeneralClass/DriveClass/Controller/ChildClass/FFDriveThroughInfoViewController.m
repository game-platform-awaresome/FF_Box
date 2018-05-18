//
//  FFThroughInfoViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/18.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDriveThroughInfoViewController.h"

@interface FFDriveThroughInfoViewController ()

@end

@implementation FFDriveThroughInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dynamicType = throughDynamic;
    // Do any additional setup after loading the view.
}

- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.title = [NSString stringWithFormat:@"穿越"];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAVIGATION_HEIGHT);
}


#pragma mark - getter
- (DynamicType)dynamicType {
    return throughDynamic;
}






@end
