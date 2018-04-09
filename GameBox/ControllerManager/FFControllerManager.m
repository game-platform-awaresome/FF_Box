//
//  FFControllerManager.m
//  GameBox
//
//  Created by 燚 on 2018/4/9.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFControllerManager.h"

static FFControllerManager *manager = nil;

@implementation FFControllerManager


+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [self new];
        }
    });
    return manager;
}


/** init */
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setPostStatusModel];
    }
    return self;
}

#pragma mark - method
- (void)setPostStatusModel {
    //    [[FFPostStatusModel sharedModel] setCallBackBlock:^(NSDictionary *content, BOOL success) {
    //        syLog(@"发车返回: %@",content);
    //        if (success) {
    //            [UIAlertController showAlertMessage:@"发车成功" dismissTime:0.7 dismissBlock:nil];
    //        } else {
    //            [UIAlertController showAlertMessage:[NSString stringWithFormat:@"发车失败 : %@",content[@"msg"]] dismissTime:0.7 dismissBlock:nil];
    //        }
    //    }];
}



#pragma mark - getter
- (UINavigationController *)rootNavController {
    if (!_rootNavController) {
        _rootNavController = [[UINavigationController alloc] initWithRootViewController:self.mainTabbarController];
    }
    return _rootNavController;
}

- (FFMainTabbarViewController *)mainTabbarController {
    if (!_mainTabbarController) {
        _mainTabbarController = [FFMainTabbarViewController new];
    }
    return _mainTabbarController;
}



@end












