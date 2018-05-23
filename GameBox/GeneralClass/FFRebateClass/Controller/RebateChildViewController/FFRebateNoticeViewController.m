//
//  FFRebateNoticeViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/2.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFRebateNoticeViewController.h"
#import "FFRebateModel.h"

@interface FFRebateNoticeViewController ()

@end

@implementation FFRebateNoticeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
    [self initDataSource];
}

- (void)initUserInterface {
    [super initUserInterface];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"返利须知";
}

- (void)initDataSource {
    [FFRebateModel rebateNoticeWithCompletion:^(NSDictionary *content, BOOL success) {
        syLog(@"rebate notice ==  %@",content);
        if (success) {
            self.showArray = content[@"data"];
            [self.showArray writeToFile:[self plistPath] atomically:YES];
            [self.tableView reloadData];
        }
    }];
}

- (void)getData {
    syLog(@"set data");
    self.showArray = [NSArray arrayWithContentsOfFile:[self plistPath]];
    if (self.showArray == nil) {
        syLog(@"start download transfer data");
        [self initDataSource];
    }
}


- (NSString *)plistPath {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"FFApplyNote.plist"];
    return filePath;
}





@end









