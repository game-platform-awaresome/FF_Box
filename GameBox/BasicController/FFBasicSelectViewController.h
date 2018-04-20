//
//  FFBasicSelectViewController.h
//  GameBox
//
//  Created by 燚 on 2018/4/17.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFBasicSelectView.h"

@interface FFBasicSelectViewController : UIViewController <FFBasicSelectViewDelegate>

/** scroll view */
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL isAnimatining;
@property (nonatomic, strong) UIViewController *lastViewController;

/** select View */
@property (nonatomic, strong) FFBasicSelectView *selectView;
@property (nonatomic, assign) CGFloat selectViewHight;

/** child controllers */
@property (nonatomic, strong) NSArray<UIViewController *> *selectChildViewControllers;
@property (nonatomic, strong) NSArray<NSString *> *selectChildVCNames;
/** uinavigation left button  */
@property (nonatomic, strong) UIBarButtonItem *leftButton;
/** uinavigation rigth button */
@property (nonatomic, strong) UIBarButtonItem *rightButton;


//method
- (void)initUserInterface;
- (void)initDataSource;


- (void)childControllerAdd:(UIViewController *)controller;
- (void)childControllerRemove:(UIViewController *)controller;


@end
