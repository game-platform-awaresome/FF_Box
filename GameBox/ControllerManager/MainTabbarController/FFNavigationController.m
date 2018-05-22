//
//  FFNavigationController.m
//  GameBox
//
//  Created by 燚 on 2018/5/21.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFNavigationController.h"

@interface FFNavigationController ()

@end

@implementation FFNavigationController



- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    self.topViewController.hidesBottomBarWhenPushed = YES;
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:animated];
}

//- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
//    self.viewControllers.count < 2;
//
//}




@end
