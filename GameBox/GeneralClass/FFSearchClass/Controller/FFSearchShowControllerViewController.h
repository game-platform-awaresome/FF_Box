//
//  FFSearchShowControllerViewController.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/16.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFSearchResultController.h"
#import "FFSearchModel.h"

@class FFSearchShowControllerViewController;

@protocol FFSearchShowDelegate <NSObject>

- (void)FFSearchShowControllerViewController:(FFSearchShowControllerViewController *)controller didSelectRow:(id)info;

@end

@interface FFSearchShowControllerViewController : UIViewController


//加载在controller的下标
@property (nonatomic, assign) NSInteger currentParentController;

+ (instancetype)SharedController;

+ (void)showSearchControllerWith:(UIViewController *)parentController;

+ (void)hideSearchController;



@end
