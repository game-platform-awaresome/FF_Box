//
//  FFDriveNumbersViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/29.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDriveNumbersViewController.h"
#import "FFDriveModel.h"
#import "FFDriveDetailInfoViewController.h"
#import "SYKeychain.h"
#import <FFTools/FFTools.h>

@interface FFDriveNumbersViewController () <UITableViewDelegate>


@end


@implementation FFDriveNumbersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}



#pragma mark - setter
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [super scrollViewDidScroll:scrollView];
    [self canScroll:scrollView];
}

#pragma mark - getter
- (DynamicType)dynamicType {
    return CheckUserDynamic;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.buid isEqualToString:SSKEYCHAIN_UID]) {
        syLog(@"删除动态");
        [UIAlertController showAlertControllerWithViewController:[FFControllerManager sharedManager].rootNavController alertControllerStyle:(UIAlertControllerStyleActionSheet) title:nil message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除动态" CallBackBlock:^(NSInteger btnIndex) {
            self.currentCellIndex = indexPath.row;
            [self deleteDynamics:btnIndex];
        } otherButtonTitles:nil];
    } else {
        [self pushDetailControllerWith:indexPath Comment:NO];
    }
}

- (void)deleteDynamics:(NSInteger)btnIndex {
    switch (btnIndex) {
        case 0:
            syLog(@"取消操作");
            break;
        case 1:
            syLog(@"删除动态");
            [self deleteMyDynamics];
            break;
        default:
            break;
    }
}

- (void)pushDetailControllerWith:(NSIndexPath *)indexPath Comment:(BOOL)isComment {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushDetailController" object:self.showArray[indexPath.row] userInfo:self.showArray[indexPath.row]];
}






@end










