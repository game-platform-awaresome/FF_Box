//
//  FFDriveController.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/8.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFSelectHeaderView.h"
#import "FFDriveModel.h"

#import "FFDrivePostStatusViewController.h"
#import <FFTools/FFTools.h>

#import "FFDriveThroughInfoViewController.h"

@interface FFDriveController : UIViewController

@property (nonatomic, strong) FFSelectHeaderView *selectHeaderView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray<UIViewController *> *fChildControllers;
@property (nonatomic, strong) UIButton *postStatusButton;
@property (nonatomic, strong) UIBarButtonItem *throughtBarbutton;
@property (nonatomic, strong) FFDriveThroughInfoViewController *throughtViewController;


- (void)initUserInterface;

- (void)initDataSource;

- (void)setFchildControllerWithClassNames:(NSArray *)classNames;

- (void)addSubViews;

@end




