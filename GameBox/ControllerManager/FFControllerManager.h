//
//  FFControllerManager.h
//  GameBox
//
//  Created by 燚 on 2018/4/9.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFMainTabbarViewController.h"

#define Current_NavController ([FFControllerManager sharedManager].currentNavController)

@interface FFControllerManager : NSObject

/** Root Navigation Controller */
@property (nonatomic, strong) UINavigationController *rootNavController;
/** Current Navigation Controller */
@property (nonatomic, strong) UINavigationController *currentNavController;
/** Main Tabbar Controller */
@property (nonatomic, strong) FFMainTabbarViewController *mainTabbarController;


/** Shared Instance */
+ (instancetype)sharedManager;




@end





