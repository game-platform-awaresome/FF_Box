//
//  FFBasicViewController.h
//  GameBox
//
//  Created by 燚 on 2018/4/24.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FFTools/FFTools.h>
#import "FFWaitingManager.h"
#import "FFControllerManager.h"
#import "FFGameModel.h"

typedef void(^EndOfNetWorkRequestBlock)(BOOL success);

@interface FFBasicViewController : UIViewController

/** End of network request block */
@property (nonatomic, strong) EndOfNetWorkRequestBlock endOfNetWorkRequestBlock;

/** uinavigation left button  */
@property (nonatomic, strong) UIBarButtonItem *leftButton;
/** uinavigation rigth button */
@property (nonatomic, strong) UIBarButtonItem *rightButton;

/** initialize user interface */
- (void)initUserInterface;
/** initialize */
- (void)initDataSource;

/** responds to button */
- (void)respondsToRightButton;
- (void)respondsToLeftButton;

/** start waiting */
- (void)startWaiting;
/** stop waiting */
- (void)stopWaiting;

/** refresh data */
- (void)refreshData;
/** load more data */
- (void)loadMoreData;




@end
