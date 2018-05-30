//
//  FFBTOpenServerViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/18.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBTOpenServerViewController.h"
#import "FFBasicOpenServerController.h"
#import "FFOpenServerSelectView.h"

#define COLLECTION_CELL_IDE @"OPENSERVERCOLLECTIONCELL"

@interface FFBTOpenServerViewController () <UICollectionViewDelegate, UICollectionViewDataSource, FFOpenServerSelectViewDelegate>


@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) FFBasicOpenServerController *yesterdayOpenServeController;
@property (nonatomic, strong) FFBasicOpenServerController *todayOpenServerController;
@property (nonatomic, strong) FFBasicOpenServerController *tomorrowOpenserverController;

@property (nonatomic, strong) FFOpenServerSelectView *selectView;

@end

@implementation FFBTOpenServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initDataSource {
    [super initDataSource];
    self.selectView.titleArray = @[@"今日开服",@"即将开服",@"已经开服"];
}

- (void)initUserInterface {
    [super initUserInterface];
    [self.view addSubview:self.selectView];
    [self.view addSubview:self.collectionView];
}

- (void)viewWillLayoutSubviews {
    self.selectView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 50);

    self.collectionView.frame = CGRectMake(0, CGRectGetMaxY(self.selectView.frame), kSCREEN_WIDTH, kSCREEN_HEIGHT - 44 - KSTATUBAR_HEIGHT - CGRectGetHeight(self.selectView.frame) - kTABBAR_HEIGHT);

    CGRect frame = CGRectMake(0, 0, kSCREEN_WIDTH, self.collectionView.frame.size.height);
    self.layout.itemSize = frame.size;
    self.todayOpenServerController.view.frame = frame;
    self.yesterdayOpenServeController.view.frame = frame;
    self.tomorrowOpenserverController.view.frame = frame;
}


#pragma mark  - select view delegate
- (void)FFOpenServerSelectView:(FFBasicSelectView *)view didSelectTitleWithIndex:(NSUInteger)idx {
    [self.collectionView setContentOffset:CGPointMake(idx * kSCREEN_WIDTH, 0)];
}

#pragma mark - collection view data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:COLLECTION_CELL_IDE forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            [cell addSubview:self.todayOpenServerController.view];
            self.todayOpenServerController.view.frame = cell.bounds;
            break;
        case 1: [cell addSubview:self.tomorrowOpenserverController.view];
            self.tomorrowOpenserverController.view.frame = cell.bounds;
            break;
        case 2: [cell addSubview:self.yesterdayOpenServeController.view];
            self.yesterdayOpenServeController.view.frame = cell.bounds;
            break;
        default: break;
    }
    cell.backgroundColor = [UIColor blackColor];

    return cell;
}


#pragma mark - getter
- (FFGameServersType)gameServerType {
    return BT_SERVERS;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:COLLECTION_CELL_IDE];
        _collectionView.pagingEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;

    }

    return _collectionView;
}

- (FFBasicOpenServerController *)yesterdayOpenServeController {
    if (!_yesterdayOpenServeController) {
        _yesterdayOpenServeController = [[FFBasicOpenServerController alloc] init];
        _yesterdayOpenServeController.gameServerType = self.gameServerType;
        _yesterdayOpenServeController.openServerType = FFOpenServerTypeAlready;
        [self addChildViewController:_yesterdayOpenServeController];
//        [_yesterdayOpenServeController didMoveToParentViewController:self];
    }
    return _yesterdayOpenServeController;
}

- (FFBasicOpenServerController *)todayOpenServerController {
    if (!_todayOpenServerController) {
        _todayOpenServerController = [[FFBasicOpenServerController alloc] init];
        _todayOpenServerController.gameServerType = self.gameServerType;
        _todayOpenServerController.openServerType = FFOpenServerTypeToday;
        [self addChildViewController:_todayOpenServerController];
//        [_todayOpenServerController didMoveToParentViewController:self];
    }
    return _todayOpenServerController;
}

- (FFBasicOpenServerController *)tomorrowOpenserverController {
    if (!_tomorrowOpenserverController) {
        _tomorrowOpenserverController = [[FFBasicOpenServerController alloc] init];
        _tomorrowOpenserverController.gameServerType = self.gameServerType;
        _tomorrowOpenserverController.openServerType = FFOpenServerTypeTomorrow;
        [self addChildViewController:_tomorrowOpenserverController];
//        [_tomorrowOpenserverController didMoveToParentViewController:self];
    }
    return _tomorrowOpenserverController;
}

- (FFOpenServerSelectView *)selectView {
    if (!_selectView) {
        _selectView = [[FFOpenServerSelectView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 50)];
        _selectView.delegate = self;
        _selectView.selectColor = [FFColorManager blue_dark];
        _selectView.normolColor = [FFColorManager textColorLight];
    }
    return _selectView;
}


@end



