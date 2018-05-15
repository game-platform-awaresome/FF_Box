//
//  FFBTServerViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/10.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBTServerViewController.h"
#import "FFServersModel.h"
#import "FFBTServerHeaderView.h"
#import <UIImageView+WebCache.h>

//childe controller


#define CELL_IDE @"FFCustomizeCell"
#define CELL_SRCELL @"FFSRcommentCell"

@interface FFBTServerViewController () <FFBTServerHeaderViewDelegate>


@property (nonatomic, strong) NSArray *bannerArray;

@property (nonatomic, strong) FFServersModel *model;

@property (nonatomic, strong) FFBTServerHeaderView *tableHeaderView;

@property (nonatomic, strong) NSMutableArray * childController;

@end

@implementation FFBTServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setNavigationTitle:nil];
    [self resetTableView];
}


- (void)initDataSource {

}

#pragma mark - load data
- (void)refreshData {
    [self startWaiting];
    Reset_page;
    [FFGameModel GameServersWithType:self.type Page:New_page Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        if (success) {
            syLog(@"message  :  bt server data == %@",content);
            /** init net data */
            self.model.contentDataDict = CONTENT_DATA;
        } else {
            syLog(@"error : %s : %@",__func__,content);
        }

        /** set banner */
        self.tableHeaderView.bannerArray = self.model.bannerArray;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData {
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.model.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.model.sectionArray[section].type == SectionOfBoutique) ? 1 : self.model.sectionArray[section].gameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = nil;
    if (self.model.sectionArray[indexPath.section].type == SectionOfBoutique) {
        cell = [tableView dequeueReusableCellWithIdentifier:CELL_SRCELL forIndexPath:indexPath];
        [cell setValue:self.model.sectionArray[indexPath.section] forKey:@"model"];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE forIndexPath:indexPath];
        [cell setValue:self.model.sectionArray[indexPath.section].gameArray[indexPath.row] forKey:@"dict"];
    }

    [cell setValue:@3 forKey:@"selectionStyle"];
//    [cell setValue:self.showArray[indexPath.row] forKey:@"dict"];
    return cell;
}

#pragma mark - table veiw delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (self.model.sectionArray[indexPath.section].type == SectionOfBoutique) ? 120 : 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 30)];
    label.text = self.model.sectionArray[section].sectionHeaderTitle;
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.model.sectionArray[section].slidePic) {
        return 200;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.model.sectionArray[section].slidePic) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 200)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,self.model.sectionArray[section].slidePic]] placeholderImage:[UIImage imageNamed:@""]];
        return imageView;
    } else {
        return nil;
    }
}

#pragma mark - select header delegate
- (void)FFBTServerHeaderView:(FFBTServerHeaderView *)headerView didSelectImageWithInfo:(NSDictionary *)info {

}

- (void)FFBTServerHeaderView:(FFBTServerHeaderView *)headerView didSelectButtonWithInfo:(id)info {
    id vc = nil;
    if ([info isKindOfClass:[NSString class]]) {
        Class Controller = NSClassFromString(info);
        vc = [[Controller alloc] init];
    } else if ([info isKindOfClass:[NSNumber class]]) {
        vc = self.childController[((NSNumber *)info).integerValue];
    }
    [self pushViewController:vc];
}




#pragma mark - setter
- (void)setNavigationTitle:(NSString *)title {
    self.navigationItem.title = @"BT服";
}


#pragma mark - getter
- (FFGameServersType)type {
    return BT_SERVERS;
}

- (NSArray *)selectButtonArray {
    return @[@"新游",@"活动",@"满V",@"分类"];
}

- (NSArray *)selectImageArray {
    return @[[FFImageManager Home_new_game],
             [FFImageManager Home_activity],
             [FFImageManager Home_hight_vip],
             [FFImageManager Home_classify]];
}

- (NSArray *)selectControllerName {
    return @[@"FFBTNewGameController",
             @"FFGameGuideViewController",
             @"UIViewController",
             @"FFBTClassifyController"];
}

- (NSMutableArray *)childController {
    if (!_childController) {
        _childController = [NSMutableArray arrayWithCapacity:self.selectControllerName.count];
        for (NSString *className in self.selectControllerName) {
            Class Controller = NSClassFromString(className);
            id vc = [[Controller alloc] init];
            if (vc) {
                [_childController addObject:vc];
            } else {
                syLog(@"%s error : %@ controller is not exist",__func__,className);
                [_childController addObject:[UIViewController new]];
            }
        }
    }
    return _childController;
}

- (FFServersModel *)model {
    if (!_model) {
        _model = [[FFServersModel alloc] init];
    }
    return _model;
}

- (FFBTServerHeaderView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[FFBTServerHeaderView alloc] init];
        _tableHeaderView.backgroundColor = [FFColorManager blue_dark];
        _tableHeaderView.titleArray = self.selectButtonArray;
        _tableHeaderView.imageArray = self.selectImageArray;
        _tableHeaderView.controllerName = self.selectControllerName;
        _tableHeaderView.delegate = self;
    }
    return _tableHeaderView;
}

- (void)resetTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - kTABBAR_HEIGHT - KSTATUBAR_HEIGHT - 44) style:(UITableViewStyleGrouped)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.tableFooterView = [UIView new];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentScrollableAxes;
    } else {

    }
    self.tableView.mj_header = self.refreshHeader;
    self.tableView.mj_footer = self.refreshFooter;
    [self.view addSubview:self.tableView];
    BOX_REGISTER_CELL;
    [self.tableView registerClass:NSClassFromString(CELL_SRCELL) forCellReuseIdentifier:CELL_SRCELL];
    self.tableView.tableHeaderView = self.tableHeaderView;
}




@end






