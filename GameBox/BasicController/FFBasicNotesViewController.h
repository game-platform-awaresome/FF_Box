//
//  FFBasicNotesViewController.h
//  GameBox
//
//  Created by 燚 on 2018/5/23.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFBasicNotesViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *showArray;

- (void)initUserInterface;

- (void)initDataSource;

- (void)getData;

- (NSString *)plistPath;



@end
