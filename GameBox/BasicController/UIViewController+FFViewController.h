//
//  UIViewController+FFViewController.h
//  GameBox
//
//  Created by 燚 on 2018/6/14.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (FFViewController)

/** uinavigation left button  */
@property (nonatomic, strong) UIBarButtonItem *leftButton;
/** uinavigation rigth button */
@property (nonatomic, strong) UIBarButtonItem *rightButton;


- (void)respondsToRightButton;
- (void)respondsToLeftButton;



@end
