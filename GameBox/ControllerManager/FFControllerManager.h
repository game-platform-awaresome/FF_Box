//
//  FFControllerManager.h
//  GameBox
//
//  Created by 燚 on 2018/4/9.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>


#define Current_NavController ([FFControllerManager sharedManager].currentNavController)

@interface FFControllerManager : NSObject

/** Root Navigation Controller */
@property (nonatomic, strong) UINavigationController *rootNavController;
/** Current Navigation Controller */
@property (nonatomic, strong) UINavigationController *currentNavController;
/** Current View Controller */
@property (nonatomic, strong) UIViewController *viewController;
/** Main Tabbar Controller */
@property (nonatomic, strong) id mainTabbarController;


/** Shared Instance */
+ (instancetype)sharedManager;



@end





