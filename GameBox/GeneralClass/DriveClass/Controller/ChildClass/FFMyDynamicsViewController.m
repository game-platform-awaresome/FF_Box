//
//  FFMyDynamicsViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/3/5.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFMyDynamicsViewController.h"
#import <FFTools/FFTools.h>

@interface FFMyDynamicsViewController () <UITableViewDelegate>


@end

@implementation FFMyDynamicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    syLog(@"删除我的动态");
    if ([self.buid isEqualToString:SSKEYCHAIN_UID]) {
        [UIAlertController showAlertControllerWithViewController:[FFControllerManager sharedManager].rootNavController alertControllerStyle:(UIAlertControllerStyleActionSheet) title:nil message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除动态" CallBackBlock:^(NSInteger btnIndex) {
            self.currentCellIndex = indexPath.row;
            [self deleteDynamics:btnIndex];
        } otherButtonTitles:nil];
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







#pragma mark - getter
- (DynamicType)dynamicType {
    return CheckUserDynamic;
}

- (NSString *)buid {
    return SSKEYCHAIN_UID;
}










@end
