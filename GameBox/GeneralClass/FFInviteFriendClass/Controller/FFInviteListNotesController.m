//
//  FFInviteListNotesController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/4/10.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFInviteListNotesController.h"
#import "FFInviteModel.h"
#import <FFTools/FFTools.h>

@interface FFInviteListNotesController ()

@end

@implementation FFInviteListNotesController



- (void)initUserInterface {
    [super initUserInterface];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"邀请排行榜须知";
}

- (void)initDataSource {
    [FFInviteModel getNoticeWithBlock:^(BOOL success, NSDictionary *content) {
        REQUEST_STATUS;
        if (success && status.integerValue == 1) {
            self.showArray = content[@"data"];
            [self.showArray writeToFile:[self plistPath] atomically:YES];
            [self.tableView reloadData];
        } else {
            [UIAlertController showAlertMessage:@"网络不知道飞哪去了." dismissTime:0.7 dismissBlock:nil];
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
    NSString *filePath = [path stringByAppendingPathComponent:@"InviteList.plist"];
    return filePath;
}

@end
