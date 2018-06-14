//
//  FFBasicViewController.h
//  GameBox
//
//  Created by 燚 on 2018/4/24.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FFTools/FFTools.h>
#import "FFControllerManager.h"
#import "FFGameModel.h"
#import "FFColorManager.h"
#import "FFImageManager.h"
#import "UIViewController+FFViewController.h"

#define pushViewController(className)     \
Class ControllerClass = NSClassFromString(className);\
if (ControllerClass) {\
    id vc = [[ControllerClass alloc] init];\
    [self pushViewController:vc];\
} else {\
    syLog(@"%s  error -> %@ not exist",__func__,className);\
}


#define BOX_MESSAGE(Message) [UIAlertController showAlertMessage:Message dismissTime:0.7 dismissBlock:nil]

typedef void(^EndOfNetWorkRequestBlock)(BOOL success);

@interface FFBasicViewController : UIViewController

/** End of network request block */
@property (nonatomic, strong) EndOfNetWorkRequestBlock endOfNetWorkRequestBlock;

@property (nonatomic, strong) UINavigationController *currentNav;


@property (nonatomic, assign) BOOL canRefresh;

/** float view */
@property (nonatomic, strong) UIImageView *floatImageView;
@property (nonatomic, assign) CGFloat floatImageViewSize;


@property (nonatomic, strong) CALayer *navLine;


/** initialize user interface */
- (void)initUserInterface;
/** initialize */
- (void)initDataSource;
- (CALayer *)creatLineWithFrame:(CGRect)frame;
- (void)customNavLine;


/** start waiting */
- (void)startWaiting;
/** stop waiting */
- (void)stopWaiting;

/** refresh data */
- (void)refreshData;
/** load more data */
- (void)loadMoreData;

/** hide tabbar when navgationcontroller pushed */
- (void)hideTabbar;
/** show tabbar when navgationcontroller pushed */
- (void)showTabbar;

/** push view controller hide tabbar */
- (void)pushViewController:(UIViewController *)vc HideTabbar:(BOOL)hideTabbar;
- (void)pushViewController:(UIViewController *)viewController;
- (void)returnShowTabbarPushViewController:(UIViewController *)viewController;
- (void)returnHideTabbarPushViewController:(UIViewController *)viewController;

- (void)showLoginViewController;
- (void)addFLoatView;
- (void)respondsToFloatImageViewTap:(UITapGestureRecognizer *)sender;
- (void)respondsToFloatImageViewPan:(UIPanGestureRecognizer *)sender;



@end






