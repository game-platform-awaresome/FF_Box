//
//  FFBusinessSellProductController.m
//  GameBox
//
//  Created by 燚 on 2018/6/14.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessSellProductController.h"

@interface FFBusinessSellProductController ()

@end

static FFBusinessSellProductController *controller = nil;
@implementation FFBusinessSellProductController

+ (FFBusinessSellProductController *)sharedController {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (controller == nil) {
            controller = [[FFBusinessSellProductController alloc] init];
        }
    });
    return controller;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}









@end









