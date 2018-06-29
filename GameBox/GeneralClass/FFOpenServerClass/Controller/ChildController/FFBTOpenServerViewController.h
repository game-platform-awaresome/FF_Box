//
//  FFBTOpenServerViewController.h
//  GameBox
//
//  Created by 燚 on 2018/5/18.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicViewController.h"
#import "FFBasicSelectViewController.h"
#import "FFBasicOpenServerController.h"
#import "FFOpenServerSelectView.h"
#import "FFBoxHandler.h"

@interface FFBTOpenServerViewController : FFBasicViewController

@property (nonatomic, assign) FFGameServersType gameServerType;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) FFOpenServerSelectView *selectView;

@property (nonatomic, strong) FFBasicOpenServerController *yesterdayOpenServeController;
@property (nonatomic, strong) FFBasicOpenServerController *todayOpenServerController;
@property (nonatomic, strong) FFBasicOpenServerController *tomorrowOpenserverController;

@end
