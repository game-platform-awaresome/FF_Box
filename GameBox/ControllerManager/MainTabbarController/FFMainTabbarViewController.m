//
//  FFMainTabbarViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/10/30.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFMainTabbarViewController.h"
#import "FFControllerManager.h"
#import "FFCustomizeTabBar.h"

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
    Class TabbarClass = NSClassFromString(@"FFCustomizeTabBar");
    if (TabbarClass) {
        id tabbar = [[TabbarClass alloc] init];
        [tabbar setValue:self forKey:@"customizeDelegate"];
        [self setValue:tabbar forKey:@"tabBar"];
    } else {
        syLog(@"custom tabbar error : custom tabbar not exist");
    }
}

- (void)initializeDataSource {
    NSArray *viewControllerNames = @[@"FFHomeViewController",
                                     @"FFOpenServiceViewController",
                                     @"FFDriveViewController",
                                     @"FFClassifyDetailViewController"];

    NSArray *titles = @[@"游戏", @"开服表", @"车站", @"我的"];

    if (viewControllerNames.count != titles.count) {
        syLog(@"%s error : Array count number not equal",__func__);
        return;
    }

    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:titles.count];
    [viewControllerNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *viewController = nil;

        Class classname = NSClassFromString(obj);
        viewController = [[classname alloc] init];

        if (!viewController) {
            viewController = [[UIViewController alloc] init];
            syLog(@"%s error : %@ not exist",__func__,obj);
        }
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        //设置title
        viewController.navigationItem.title = titles[idx];
        viewController.navigationController.tabBarItem.title = titles[idx];

        UIImage *normalImage = [self creatImageWith:idx Normal:YES];
        UIImage *selectImage = [self creatImageWith:idx Normal:NO];

        viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:titles[idx] image:[normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

        [viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:NAVGATION_BAR_COLOR} forState:UIControlStateSelected];

        [viewControllers addObject:nav];
    }];

    self.viewControllers = viewControllers;
    self.childVCs = viewControllers;
    [FFControllerManager sharedManager].currentNavController = viewControllers.firstObject;
}


- (UIImage *)creatImageWith:(NSUInteger)idx Normal:(BOOL)Normal {
    Class ImageManager = NSClassFromString(@"FFImageManager");
    SEL selector = Normal ? NSSelectorFromString([NSString stringWithFormat:@"Tabbar_%ld_Normal",idx]) : NSSelectorFromString([NSString stringWithFormat:@"Tabbar_%ld_Select",idx]);
    if ([ImageManager respondsToSelector:selector]) {
        IMP imp = [ImageManager methodForSelector:selector];
        UIImage *(*func)(void) = (void *)imp;
        UIImage *image = func();
        if (!image) syLog(@"Tabbar image error : index == %ld image is null",idx);
        return image;
    } else {
        syLog(@"\n ! \n tabbar iamge error :  %s not exist \n ! \n",sel_getName(selector));
        return nil;
    }
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















