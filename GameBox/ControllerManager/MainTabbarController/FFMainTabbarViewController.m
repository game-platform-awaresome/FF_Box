//
//  FFMainTabbarViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/10/30.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFMainTabbarViewController.h"
#import "FFCustomizeTabBar.h"
#import "FFControllerManager.h"
//#import "FFInviteFriendViewController.h"
//#import "FFLoginViewController.h"
//#import "ZCNavigationController+Smoonth.h"


@interface FFMainTabbarViewController () <FFCustomizeTabbarDelegate>


@property (nonatomic, strong) NSArray<UINavigationController *> *childVCs;


@end

@implementation FFMainTabbarViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initializeUserInterface];
        [self initializeDataSource];
    }
    return self;
}

- (void)initializeUserInterface {
    FFCustomizeTabBar *tabbar = [[FFCustomizeTabBar alloc] init];
    tabbar.customizeDelegate = self;
    [self setValue:tabbar forKey:@"tabBar"];
}

- (void)initializeDataSource {
//    NSArray *viewControllerNames = @[@"FFHomeViewController", @"FFOpenServiceViewController", @"FFDriveViewController", @"FFMineViewController"];
    NSArray *viewControllerNames = @[@"FFHomeViewController", @"FFOpenServiceViewController", @"FFDriveViewController", @"FFClassifyDetailViewController"];
    NSArray *titles = @[@"游戏", @"开服表", @"车站", @"我的"];
    NSArray *images = @[@"d_youxi_an", @"b_paihangbang_an-", @"Community_tab_image_an", @"c_wode_an"];
    NSArray *selectImages = @[@"d_youxi_liang", @"b_paihangbang_liang", @"Community_tab_image_liang", @"c_wode_liang"];
    //    NSArray *viewControllerNames = @[@"FFHomeViewController", @"FFRankListViewController", @"FFOpenServerViewController", @"FFNewMineViewController"];
    //    NSArray *titles = @[@"游戏", @"排行榜", @"开服表", @"我的"];

    //    NSArray *images = @[@"d_youxi_an", @"b_paihangbang_an-", @"a_libao_an", @"c_wode_an"];
    //    NSArray *selectImages = @[@"d_youxi_liang", @"b_paihangbang_liang", @"a_libao_liang", @"c_wode_liang"];

    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:titles.count];

    [viewControllerNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *viewController = nil;

        Class classname = NSClassFromString(obj);
        viewController = [[classname alloc] init];

        if (!viewController) {
            viewController = [[UIViewController alloc] init];
            syLog(@"%@ error",obj);
        }
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        //设置title
        viewController.navigationItem.title = titles[idx];
        viewController.navigationController.tabBarItem.title = titles[idx];
        viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:titles[idx] image:[[UIImage imageNamed:images[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectImages[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:NAVGATION_BAR_COLOR} forState:UIControlStateSelected];
        [viewControllers addObject:nav];
    }];
    self.viewControllers = viewControllers;
    self.childVCs = viewControllers;
    [FFControllerManager sharedManager].currentNavController = viewControllers.firstObject;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
//    [super tabBar:tabBar didSelectItem:item];

}

- (void)setSelectedViewController:(__kindof UIViewController *)selectedViewController {
    [super setSelectedViewController:selectedViewController];
    [FFControllerManager sharedManager].currentNavController = selectedViewController;
}

#pragma mark - delegate
- (void)CustomizeTabBar:(FFCustomizeTabBar *)tabBar didSelectCenterButton:(id)sender {
    syLog(@"tabbar click center button");
    //    UINavigationController *nav = (UINavigationController *)self.selectedViewController;
    //    nav.childViewControllers[0].hidesBottomBarWhenPushed = YES;
    //    FFInviteFriendViewController *vc = [FFInviteFriendViewController new];
    //    if ([vc initDataSource]) {
    //        [nav pushViewController:[FFInviteFriendViewController new] animated:YES];
    //    } else{
    //        [nav pushViewController:[FFLoginViewController new] animated:YES];
    //    }
    //    nav.childViewControllers[0].hidesBottomBarWhenPushed = NO;
}

#pragma mark - getter












@end
















