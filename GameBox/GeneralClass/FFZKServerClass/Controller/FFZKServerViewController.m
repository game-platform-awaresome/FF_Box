//
//  FFZKServerViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/11.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFZKServerViewController.h"

@interface FFZKServerViewController ()

@end

@implementation FFZKServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - getter
- (FFGameServersType)type {
    return ZK_SERVERS;
}

- (NSArray *)selectButtonArray {
    return @[@"新游",@"活动",@"折扣",@"分类"];
}

- (NSArray *)selectImageArray {
    return @[[FFImageManager Home_new_game],
             [FFImageManager Home_activity],
             [FFImageManager Home_discount],
             [FFImageManager Home_classify]];
}





@end
