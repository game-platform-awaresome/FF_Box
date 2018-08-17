//
//  FFGameBusinessViewController.h
//  GameBox
//
//  Created by 燚 on 2018/8/17.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessViewController.h"

@interface FFGameBusinessViewController : FFBusinessViewController

+ (UINavigationController *)GameBusiness;

+ (FFGameBusinessViewController *)showWithGameName:(NSString *)gameName;

@end
