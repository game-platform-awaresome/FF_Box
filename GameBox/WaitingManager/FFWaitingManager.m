//
//  FFWaitIngManager.m
//  GameBox
//
//  Created by 燚 on 2018/4/24.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFWaitingManager.h"



@interface FFWaitingManager ()

@property (nonatomic, strong) MBProgressHUD *hud;


/** call method counting */
@property (nonatomic, assign) NSInteger statubarNumber;
@property (nonatomic, assign) NSInteger hudNumber;




@end


static FFWaitingManager *manager = nil;
@implementation FFWaitingManager

/** 简单单利 */
+ (instancetype)SharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[FFWaitingManager alloc] init];
        }
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.statubarNumber = 0;
        self.hudNumber = 0;
    }
    return self;
}

#pragma mark - hud
+ (void)startWaitingWithView:(UIView *)view {
    [FFWaitingManager SharedManager].hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
}

+ (void)startWaiting {
    [FFWaitingManager SharedManager].hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:YES];
}

+ (void)stopWatiting {
    [[FFWaitingManager SharedManager].hud hideAnimated:YES];
}


#pragma mark - statubar
+ (void)startStatubarWaiting {
    if ([FFWaitingManager SharedManager].statubarNumber <= 0) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        [FFWaitingManager SharedManager].statubarNumber = 0;
    }
    [FFWaitingManager SharedManager].statubarNumber++;
}

+ (void)stopStatubarWating {
    if ((--[FFWaitingManager SharedManager].statubarNumber) == 0) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } else if ([FFWaitingManager SharedManager].statubarNumber < 0) {
        [FFWaitingManager SharedManager].statubarNumber = 0;
    }
}








@end
