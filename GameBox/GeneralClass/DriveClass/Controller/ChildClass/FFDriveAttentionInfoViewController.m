//
//  FFDriveAttentionInfoViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/18.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDriveAttentionInfoViewController.h"
#import "DriveInfoCell.h"


#define CELL_IDE @"DriveInfoCell"

@interface FFDriveAttentionInfoViewController ()

@end

@implementation FFDriveAttentionInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - getter
- (DynamicType)dynamicType {
    return attentionDynamic;
}



@end
