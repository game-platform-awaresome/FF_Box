//
//  FFReservationGameController.m
//  GameBox
//
//  Created by 燚 on 2018/6/5.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFReservationGameController.h"

@interface FFReservationGameController ()

@end

@implementation FFReservationGameController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)initUserInterface {
    [super initUserInterface];
    self.navigationItem.title = @"预约游戏";
}

- (FFBetaOrReservationType)type {
    return FFReservation;
}




@end










