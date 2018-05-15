//
//  FFBTServerViewController.h
//  GameBox
//
//  Created by 燚 on 2018/5/10.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicTableViewController.h"
#import "FFServersModel.h"


typedef void(^PushViewControllerBlock)(UIViewController *vc);


@interface FFBTServerViewController : FFBasicTableViewController

@property (nonatomic, assign) FFGameServersType type;

@property (nonatomic, strong) NSArray *selectButtonArray;
@property (nonatomic, strong) NSArray *selectImageArray;
@property (nonatomic, strong) NSArray *selectControllerName;

@property (nonatomic, strong) PushViewControllerBlock pushBlock;


- (void)setNavigationTitle:(NSString *)title;


@end
