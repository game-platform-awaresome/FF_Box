//
//  FFH5ServerViewController.m
//  GameBox
//
//  Created by 燚 on 2018/7/17.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFH5ServerViewController.h"

@interface FFH5ServerViewController ()

@end

@implementation FFH5ServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self exchangeMethodWithClass1:@"SDK_ADImage"
                           Method1:@"showADImageWithDelegate:andStatus:"
                            Class2:@"H5Handler"
                           Method2:@"re_showADImageWithDelegate:andStatus:"];
    [self exchangeMethodWithClass1:@"LoginController"
                           Method1:@"showADPicView"
                            Class2:@"H5Handler"
                           Method2:@"re_showADPicView"];
    [self exchangeMethodWithClass1:@"LoginController"
                           Method1:@"showBingPhoneView"
                            Class2:@"H5Handler"
                           Method2:@"re_showBingPhoneView"];
    [self exchangeMethodWithClass1:@"LoginController"
                           Method1:@"showBindNameView"
                            Class2:@"H5Handler"
                           Method2:@"re_showBindNameView"];
}

- (void)exchangeMethodWithClass1:(NSString *)class1 Method1:(NSString *)method1 Class2:(NSString *)class2 Method2:(NSString *)method2 {
    Method originalM = class_getClassMethod(NSClassFromString(class1),
                                            NSSelectorFromString(method1));
    Method exchangeM = class_getClassMethod(NSClassFromString(class2),
                                            NSSelectorFromString(method2));
    method_exchangeImplementations(originalM, exchangeM);
}

#pragma mark - setter
- (void)setNavigationTitle:(NSString *)title {
    self.navigationItem.title = @"H5";
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 44 - KSTATUBAR_HEIGHT - kTABBAR_HEIGHT);
}

#pragma mark - responds
- (void)respondsToRightButton {
    m185Statistics(@"分类", self.type);
    pushViewController(@"FFH5ClassifyController");
}

- (void)FFBTServerHeaderView:(id)headerView  didSelectButtonWithInfo:(id)info {

    NSArray *buttonArray = @[@"新游",@"排行榜",@"赚金币",@"开服表"];
    NSString *message = ((NSNumber *)info).integerValue < buttonArray.count ? buttonArray[((NSNumber *)info).integerValue] : @"____";
    m185Statistics(message, self.type);

    id vc = nil;


    if ([info isKindOfClass:[NSString class]]) {
        if ([info isEqualToString:@"FFH5EarngoldViewController"]) {
            [UIAlertController showAlertMessage:@"暂时未开放,敬请期待." dismissTime:0.8 dismissBlock:nil];
            return;
        }

        Class Controller = NSClassFromString(info);
        vc = [[Controller alloc] init];
        [self pushViewController:vc];

    }


    if ([info isKindOfClass:[NSNumber class]]) {
        NSNumber *number = (NSNumber *)info;
        if (number.integerValue == 2) {
            [UIAlertController showAlertMessage:@"暂时未开放,敬请期待." dismissTime:0.8 dismissBlock:nil];
            return;
        }

        NSArray *vcs = [self valueForKey:@"childController"];
        if (vcs) {
            vc = vcs[((NSNumber *)info).integerValue];
            [self pushViewController:vc];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    [cell setValue:@YES forKey:@"isH5Game"];
    return cell;
}

#pragma mark - getter
- (FFGameServersType)type {
    return H5_SERVERS;
}

- (NSArray *)selectButtonArray {
    return @[@"新游",@"排行榜",@"赚金币",@"开服表"];
}

- (NSArray *)selectImageArray {
    return @[[FFImageManager Home_new_game],
             [FFImageManager Home_activity],
             [FFImageManager Home_earn_gold],
             [FFImageManager Home_classify]];
}

- (NSArray *)selectControllerName {
    return @[@"FFH5NewGameController",
             @"FFH5RankViewController",
             @"FFH5EarngoldViewController",
             @"FFH5OpenServerViewController"];
}





@end



