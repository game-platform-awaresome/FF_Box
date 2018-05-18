//
//  FFDriveAllInfoViewController.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/11.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFDriveModel.h"
#import "FFViewFactory.h"
#import "MBProgressHUD.h"
#import "FFDynamicModel.h"
#import "FFControllerManager.h"

#define hud_add MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:YES]
#define hud_remove [hud hideAnimated:YES];

@interface FFDriveAllInfoViewController : UIViewController

/** table View */
@property (nonatomic, strong) UITableView *tableView;

/** table view data source */
@property (nonatomic, strong) NSMutableArray *showArray;

@property (nonatomic, assign) DynamicType dynamicType;

@property (assign, nonatomic) BOOL canScroll;

@property (nonatomic, strong) NSString *buid;

@property (nonatomic, strong) FFDynamicModel *model;

@property (nonatomic, assign) NSUInteger currentCellIndex;


- (void)initUserInterface;

- (void)initDataSource;

- (void)refreshNewData;

- (void)loadMoreData;

- (void)deleteMyDynamics;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)canScroll:(UIScrollView *)scrollView;
- (void)cheackShowArrayIsempty;


@end





