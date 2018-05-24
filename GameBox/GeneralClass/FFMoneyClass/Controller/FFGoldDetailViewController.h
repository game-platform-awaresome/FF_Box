//
//  FFGoldDetailViewController.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/21.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFBasicTableViewController.h"

@interface FFGoldDetailViewController : FFBasicTableViewController

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;

@end
