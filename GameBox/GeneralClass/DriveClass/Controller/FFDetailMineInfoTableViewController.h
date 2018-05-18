//
//  FFDetailMineInfoTableViewController.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/2/1.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFDetailMineInfoTableViewController : UITableViewController

@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) NSString *uid;


+ (instancetype)controllerWithUid:(NSString *)uid Dict:(NSDictionary *)dict;

@end
