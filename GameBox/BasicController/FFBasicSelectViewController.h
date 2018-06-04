//
//  FFBasicSelectViewController.h
//  GameBox
//
//  Created by 燚 on 2018/4/17.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicViewController.h"
#import "FFBasicSelectView.h"

@interface FFBasicSelectViewController : FFBasicViewController <FFBasicSelectViewDelegate>

/** scroll view */
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL isAnimatining;
@property (nonatomic, strong) UIViewController *lastViewController;

/** select View */
@property (nonatomic, strong) FFBasicSelectView *selectView;
@property (nonatomic, assign) CGFloat selectViewHight;
@property (nonatomic, assign) CGRect SelectViewFrame;

/** child controllers */
@property (nonatomic, strong) NSMutableArray<UIViewController *> *selectChildViewControllers;
@property (nonatomic, strong) NSArray<NSString *> *selectChildVCNames;


- (void)childControllerAdd:(UIViewController *)controller;
- (void)childControllerRemove:(UIViewController *)controller;





@end












