//
//  FFSettingViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/8.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFSettingViewController.h"
#import <SDImageCache.h>
#import "FFBoxModel.h"
#import "FFUserModel.h"
#import <FFTools/FFTools.h>
#import "FFColorManager.h"

#define CELLIDE @"SettingCell"

@interface FFSettingViewController () <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray<NSArray *> *showArray;


/** table Footer */
@property (nonatomic, strong) UIView *tableFooter;

/** 退出登录 */
@property (nonatomic, strong) UIButton *logoutBtn;

/** 是否打开通知 */
@property (nonatomic, assign) BOOL isOpenNotifi;

/** 缓存大小 */
@property (nonatomic, assign) CGFloat cache;


@end

@implementation FFSettingViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarBGAlpha = @"1.0";
    [self.navigationController.navigationBar setTintColor:[FFColorManager navigation_bar_black_color]];
    //检查是否已经登录
    self.tableView.tableFooterView = ([FFUserModel currentUser].isLogin) ? self.tableFooter : [UIView new];

    //检查消息通知是否打开
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0f) {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone == setting.types) {
            _isOpenNotifi = NO;
        } else {
            _isOpenNotifi = YES;
        }
    }
    //检查缓存
    _cache = [self folderSizeAtPath:@""];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterFace];
}

- (void)initUserInterFace {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"设置";
    [self.view addSubview:self.tableView];
}

#pragma mark - responds
/** 退出登录 */
- (void)respondsToLogoutBtn {
    [FFUserModel signOut];
    self.tableView.tableFooterView = [UIView new];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINVIEW_LOGIN_SUCCESS" object:nil];
    [UIAlertController showAlertMessage:@"退出登录" dismissTime:0.7 dismissBlock:nil];
}

- (void)respondsToWifiSwitch:(UISwitch *)sender {
//    if (sender.on) {
//
//    } else {
//        BOX_MESSAGE(@"仅用WIFI下载已关闭");
//    }
//    SAVEOBJECT_AT_USERDEFAULTS([NSNumber numberWithBool:sender.on], WIFIDOWNLOAD);
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.showArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.showArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLIDE];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:CELLIDE];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.showArray[indexPath.section][indexPath.row];
//    cell.backgroundColor = RGBCOLOR(228, 217, 219);
    cell.backgroundColor = [UIColor whiteColor];

    if (indexPath.section == 0) {
        cell.accessoryView = nil;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2lfM",_cache];

    } else if (indexPath.section == 1 && indexPath.row == 0) {
        if (_isOpenNotifi) {
            cell.detailTextLabel.text = @"已打开";
        } else {
            cell.detailTextLabel.text = @"已关闭";
        }
        cell.accessoryView = nil;

    } else if (indexPath.section == 2) {

        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"当前版本:%@",[infoDic objectForKey:@"CFBundleShortVersionString"]];
        cell.accessoryView = nil;
    }

    return cell;
}

#pragma mark - tableViewDeleagte
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 120, 30)];
    label.backgroundColor = BACKGROUND_COLOR;
    label.font = [UIFont systemFontOfSize:13];

    switch (section) {
        case 0:
            label.text = @"    通用";
            break;
        case 1:
            label.text = @"    消息通知 : 请在 系统设置 -> 通知 中进行相关设置";
            break;
        case 2:
            label.text = @"    版本";
            break;
        default:
            break;
    }
    return label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            [self clearCache:@""];
            _cache = [self folderSizeAtPath:@""];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
            break;
        }
        case 1: {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            break;
        }
        case 2: {
            [self cheackVersion];
            break;
        }


        default:
            break;
    }
}

#pragma mark - up date
//检查版本更新
- (void)cheackVersion {
    [FFBoxModel checkBoxVersionCompletion:^(NSDictionary *content, BOOL success) {
        NSString *update = content[@"data"];
        if ([update isKindOfClass:[NSNull class]] || update == nil || update.length == 0) {
            [UIAlertController showAlertMessage:@"当前为最新版本" dismissTime:0.7 dismissBlock:nil];
        } else {
            [self boxUpdateWithUrl:update];
        }
    }];
}

- (void)boxUpdateWithUrl:(NSString *)url {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil  message:@"游戏有更新,前往更新" preferredStyle:UIAlertControllerStyleAlert];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }]];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
//        _tableView.backgroundColor = RGBCOLOR(228, 217, 219);
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _tableView;
}

- (UIView *)tableFooter {
    if (!_tableFooter) {
        _tableFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 150)];
//        _tableFooter.backgroundColor = RGBCOLOR(228, 217, 219);
        _tableFooter.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 1)];
        line.backgroundColor = BACKGROUND_COLOR;
        [_tableFooter addSubview:line];
        [_tableFooter addSubview:self.logoutBtn];
    }
    return _tableFooter;
}

- (UIButton *)logoutBtn {
    if (!_logoutBtn) {
        _logoutBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _logoutBtn.frame = CGRectMake(kSCREEN_WIDTH * 0.1, 60, kSCREEN_WIDTH * 0.8, 44);
        _logoutBtn.backgroundColor = [FFColorManager blue_dark];
        [_logoutBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_logoutBtn setTitle:@"退出登录" forState:(UIControlStateNormal)];
        [_logoutBtn addTarget:self action:@selector(respondsToLogoutBtn) forControlEvents:(UIControlEventTouchUpInside)];
        _logoutBtn.layer.cornerRadius = 8;
        _logoutBtn.layer.masksToBounds = YES;
    }
    return _logoutBtn;
}

- (NSArray *)showArray {
    if (!_showArray) {
        _showArray = @[@[@"清空缓存"],
                       @[@"消息通知"],
                       @[@"检测更新"]];
    }
    return _showArray;
}

#pragma mark - cache
//计算文件大小
- (long long)fileSizeAtPath:(NSString *)path {
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size;
    }
    return 0;
}

- (float)folderSizeAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    cachePath = [cachePath stringByAppendingPathComponent:path];
    long long folderSize = 0;
    if ([fileManager fileExistsAtPath:cachePath])
    {
        NSArray *childerFiles=[fileManager subpathsAtPath:cachePath];
        for (NSString *fileName in childerFiles)
        {
            NSString * fileAbsolutePath = [cachePath stringByAppendingPathComponent:fileName];
            long long size= [self fileSizeAtPath:fileAbsolutePath];
            folderSize += size;
        }
        //SDWebImage框架自身计算缓存的实现
        folderSize += [[SDImageCache sharedImageCache] getSize];
        return folderSize/1024.0/1024.0;
    }
    return 0;
}

//清楚缓存
- (void)clearCache:(NSString *)path {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    cachePath = [cachePath stringByAppendingPathComponent:path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:cachePath]) {
        NSArray *childerFiles = [fileManager subpathsAtPath:cachePath];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *fileAbsolutePath=[cachePath stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:fileAbsolutePath error:nil];
        }
    }
}






@end

