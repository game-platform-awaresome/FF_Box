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
#import "FFNavigationController.h"

@interface FFMainTabbarViewController () <FFCustomizeTabbarDelegate>

@property (nonatomic, strong) NSArray<UINavigationController *> *childVCs;
@property (nonatomic, strong) NSMutableArray <UIViewController *> *vcs;

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
                                     @"FFBusinessViewController",
                                     @"FFDriveController",
                                     @"FFMineViewController"];

    NSArray *titles = @[@"游戏", @"交易", @"车站", @"我的"];

    if (viewControllerNames.count != titles.count) {
        syLog(@"%s error : Array count number not equal",__func__);
        return;
    }

    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:titles.count];
    _vcs = [NSMutableArray arrayWithCapacity:titles.count];
    [viewControllerNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *viewController = nil;

        Class classname = NSClassFromString(obj);
        viewController = [[classname alloc] init];

        if (!viewController) {
            viewController = [[UIViewController alloc] init];
            syLog(@"%s error : %@ not exist",__func__,obj);
        }

        [_vcs addObject:viewController];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
        //设置title
        viewController.navigationItem.title = titles[idx];
        viewController.navigationController.tabBarItem.title = titles[idx];

        UIImage *normalImage = [self creatImageWith:idx Normal:YES];
        UIImage *selectImage = [self creatImageWith:idx Normal:NO];

        viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:titles[idx] image:[normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

        [viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[self tabbarItemColor]} forState:UIControlStateSelected];

        [viewControllers addObject:nav];
    }];

    self.viewControllers = viewControllers;
    self.childVCs = viewControllers;
    [FFControllerManager sharedManager].viewController = _vcs.firstObject;
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

- (UIColor *)tabbarItemColor {
    Class ColorManager = NSClassFromString(@"FFColorManager");
    SEL selector = NSSelectorFromString(@"tabbar_item_color");
    if ([ColorManager respondsToSelector:selector]) {
        IMP imp = [ColorManager methodForSelector:selector];
        UIColor *(*get_tabbar_item_color)(void) = (void *)imp;
        UIColor *tabbar_item_color = get_tabbar_item_color();
        if (!tabbar_item_color)  return [UIColor blackColor];
        return tabbar_item_color;
    } else {
        return [UIColor blackColor];
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
    [FFControllerManager sharedManager].viewController = _vcs[self.selectedIndex];
    [FFControllerManager sharedManager].currentNavController = selectedViewController;

}

#pragma mark - delegate
- (void)CustomizeTabBar:(FFCustomizeTabBar *)tabBar didSelectCenterButton:(id)sender {
    Class FFUserrModel = NSClassFromString(@"FFUserModel");
    SEL selector = NSSelectorFromString(@"currentUser");
    if ([FFUserrModel respondsToSelector:selector]) {
        IMP imp = [FFUserrModel methodForSelector:selector];
        id (*func)(void) = (void *)imp;
        id currentUser = func();
        if (currentUser) {
            NSNumber *number = [currentUser valueForKey:@"isLogin"];
            if (number != nil) {
                [self showInviteView:number.boolValue];
            } else {
                syLog(@"%s error -> isLogin not exist",__func__);
            }
        } else {
            syLog(@"%s error -> current not exist",__func__);
        }
    } else {
        syLog(@"%s error -> FFUserrModel not exist",__func__);
    }
}

- (void)showInviteView:(BOOL)show {
    NSString *className = show ? @"FFInviteFriendViewController" : @"FFLoginViewController";
    Class ViewController = NSClassFromString(className);
    if (ViewController) {
        id vc = [[ViewController alloc] init];
        UIViewController *topVc = [FFControllerManager sharedManager].currentNavController.topViewController;
        topVc.hidesBottomBarWhenPushed = YES;
        [[FFControllerManager sharedManager].currentNavController pushViewController:vc animated:YES];
        topVc.hidesBottomBarWhenPushed = NO;
    } else {
        syLog(@"%s error -> %@ not exist",__func__,className);
    }
}

#pragma mark - getter












@end















