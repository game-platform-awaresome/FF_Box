//
//  FFBasicSelectViewController.h
//  GameBox
//
//  Created by 燚 on 2018/4/17.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFBasicSelectView.h"

@interface FFBasicSelectViewController : UIViewController

/** scroll view */
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL isAnimatining;
@property (nonatomic, strong) UIViewController *lastViewController;

/** select View */
@property (nonatomic, strong) FFBasicSelectView *selectView;

/** child controllers */
@property (nonatomic, strong) NSArray<UIViewController *> *selectChildViewControllers;
/** uinavigation left button  */
@property (nonatomic, strong) UIBarButtonItem *leftButton;
/** uinavigation rigth button */
@property (nonatomic, strong) UIBarButtonItem *rightButton;





@end
