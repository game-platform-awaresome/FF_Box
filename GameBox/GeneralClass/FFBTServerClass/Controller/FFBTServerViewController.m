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
#import "FFSRcommentCell.h"
#import "FFBoxModel.h"
#import "FFWebViewController.h"

#import "FFSearchController.h"
//childe controller

#import "FFRankListViewController.h"


#import "UIView+HYBMasonryKit.h"
#import "UILabel+HYBMasonryKit.h"
#import "FFGameListBaseCell.h"
#import "FFGameViewController.h"

#import "FFBTClassifyController.h"


#define CELL_IDE @"FFCustomizeCell"
#define CELL_SRCELL @"FFSRcommentCell"


#define Section_Footer_tag 20086

@interface FFBTServerViewController () <FFBTServerHeaderViewDelegate,FFSRcommentCellDelegate>


@property (nonatomic, strong) NSArray *bannerArray;

@property (nonatomic, strong) FFServersModel *model;

@property (nonatomic, strong) FFBTServerHeaderView *tableHeaderView;

@property (nonatomic, strong) NSMutableArray * childController;

@property (nonatomic, assign) NSUInteger selectFotterImageIdx;

@property (nonatomic, strong) NSString *topGameName;

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

//    [FFGameListBaseCell registCellToTabelView:self.tableView];
//    [FFGameListBaseCell registCellToTabelView:self.tableView WithIdentifier]
}

#pragma mark - load data
- (void)refreshData {
    [self startWaiting];
    syLog(@"%s",__func__);
    Reset_page;
    [FFGameModel GameServersWithType:self.type Page:New_page Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        syLog(@"game ========= %@",content);
        if (success) {
            self.model.contentDataDict = CONTENT_DATA;
            self.topGameName = [NSString stringWithFormat:@"%@",CONTENT_DATA[@"topgame"] ?: @" "];
        } else {
            self.topGameName = @" ";
            self.tableView.tableHeaderView = [UIView new];
            [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:nil];
        }

        /** set banner */

        if (self.model.bannerArray != nil && self.model.bannerArray.count > 0) {
            self.tableHeaderView.bannerArray = self.model.bannerArray;
        }

        if ((self.tableHeaderView.bannerArray != nil && self.tableHeaderView.bannerArray.count > 0) || self.model.sectionArray.count > 0) {
            self.tableView.tableHeaderView = self.tableHeaderView;
        } else {
            self.tableView.tableHeaderView = [UIView new];
        }

        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)loadMoreData {
    [FFGameModel GameServersWithType:self.type Page:Next_page Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        if (success) {
            NSArray *gameArray = content[@"data"][@"gamelist"];
            if (gameArray != nil && gameArray.count > 0) {

                [self.model.gameRecomment.gameArray addObjectsFromArray:gameArray];
                [self.tableView reloadData];

                [self.tableView.mj_footer endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        } else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }

        /** set banner */

    }];
}

#pragma mark - responds
- (void)respondsToSectionFooterImage:(NSUInteger)sender {
    NSString *gid = self.model.sectionArray[(sender)].slideGid;
    if (gid != nil && gid.integerValue > 0) {
        Class FFGameViewController = NSClassFromString(@"FFGameViewController");
        SEL selector = NSSelectorFromString(@"sharedController");
        if ([FFGameViewController respondsToSelector:selector]) {
            IMP imp = [FFGameViewController methodForSelector:selector];
            UIViewController *(*func)(void) = (void *)imp;
            UIViewController *vc = func();
            if (vc) {
                [vc setValue:gid forKey:@"gid"];
                [self pushViewController:vc];
            } else {
                syLog(@"\n ! %s \n present error :  %s not exist \n ! \n",__func__,sel_getName(selector));
            }
        } else {
            syLog(@"\n ! %s \n present error :  %s not exist \n ! \n",__func__,sel_getName(selector));
        }
    } else {
        syLog(@"gid error -> game not exist %@",gid);
    }

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
        ((FFSRcommentCell *)cell).delegate = self;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:GamelistBaseCellIDE];
        if (!cell) {
            cell = [[FFGameListBaseCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:GamelistBaseCellIDE];
        }
        [cell setValue:self.model.sectionArray[indexPath.section].gameArray[indexPath.row] forKey:@"dict"];

        [cell setValue:@"Home_cell_BT" forKey:@"rigthButtonImage"];
        
    }
    [cell setValue:@3 forKey:@"selectionStyle"];
    return cell;
}

#pragma mark - table veiw delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (self.model.sectionArray[indexPath.section].type == SectionOfBoutique) ? 140 : 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {


    UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40)];
    backview.backgroundColor = [FFColorManager navigation_bar_white_color];

    CGFloat font = 16;
    if (section == 0) {
        font = 18;
    }


    UILabel *titleLabel = [UILabel hyb_labelWithText:[NSString stringWithFormat:@"%@",self.model.sectionArray[section].sectionHeaderTitle] font:font superView:backview constraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backview).offset(10);
        make.top.mas_equalTo(backview).offset(0);
        make.height.mas_equalTo(40);
    }];
    titleLabel.backgroundColor = [FFColorManager navigation_bar_white_color];



    if (section == 0) {
        UIFont *font = [UIFont boldSystemFontOfSize:18];

        UILabel *dian = [UILabel hyb_labelWithText:@" • " font:18 superView:backview constraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(titleLabel.mas_right).offset(1);
            make.top.mas_equalTo(backview).offset(0);
            make.height.mas_equalTo(40);
        }];
        dian.font = font;

        UILabel *huobao = [UILabel hyb_labelWithText:@"火爆" font:18 superView:backview constraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(dian.mas_right).offset(1);
            make.top.mas_equalTo(backview).offset(0);
            make.height.mas_equalTo(40);
        }];
        [huobao setTextColor:kRedColor];
        huobao.font = font;

        UIButton *button = [UIButton hyb_buttonWithTitle:@" 游戏分类" superView:backview constraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(backview).offset(-10);
            make.top.mas_equalTo(backview).offset(0);
            make.height.mas_equalTo(40);
        } touchUp:^(UIButton *sender) {
            [self respondsToRightButton];
        }];
        [button setImage:[UIImage imageNamed:@"Home_classify_button"] forState:(UIControlStateNormal)];
        [button setTitleColor:[FFColorManager blue_dark] forState:(UIControlStateNormal)];
        button.titleLabel.font = [UIFont systemFontOfSize:17];


        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kSCREEN_WIDTH - 20, 1)];
        line.backgroundColor = [FFColorManager view_separa_line_color];
        [backview addSubview:line];
    }



    return backview;
}


#define Section_FooterHeight kSCREEN_WIDTH * 334 / 750
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.model.sectionArray[section].slidePic) {
        return Section_FooterHeight;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    if (self.model.sectionArray[section].slidePic) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, Section_FooterHeight)];
        view.backgroundColor = [UIColor whiteColor];

        UIImageView *imageView = [UIImageView hyb_imageViewWithSuperView:view constraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(view).offset(10);
            make.right.mas_equalTo(view).offset(-10);
            make.top.mas_equalTo(view).offset(0);
            make.bottom.mas_equalTo(view).offset(0);
        } onTaped:^(UITapGestureRecognizer *sender) {
            [self respondsToSectionFooterImage:section];
        }];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:IMAGEURL,self.model.sectionArray[section].slidePic]] placeholderImage:[UIImage imageNamed:@"1111"]];
        imageView.layer.cornerRadius = 8;
        imageView.layer.masksToBounds = YES;
        return view;

    } else {
        return nil;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = self.model.sectionArray[indexPath.section].gameArray[indexPath.row];
    [self pushViewController:[FFGameViewController showWithGameID:dict]];
}



#pragma mark - select header delegate
- (void)FFBTServerHeaderView:(FFBTServerHeaderView *)headerView didSelectImageWithInfo:(NSDictionary *)info {
    syLog(@" banner ====%@",info);
    NSString *type = info[@"type"];
    if (type.integerValue == 1) {
        NSString *gid = [NSString stringWithFormat:@"%@",info[@"gid"]];
        if (gid != nil && gid.integerValue > 0) {
            Class FFGameViewController = NSClassFromString(@"FFGameViewController");
            SEL selector = NSSelectorFromString(@"sharedController");
            if ([FFGameViewController respondsToSelector:selector]) {
                IMP imp = [FFGameViewController methodForSelector:selector];
                UIViewController *(*func)(void) = (void *)imp;
                UIViewController *vc = func();
                if (vc) {
                    [vc setValue:gid forKey:@"gid"];
                    [self pushViewController:vc];
                } else {
                    syLog(@"\n ! %s \n present error :  %s not exist \n ! \n",__func__,sel_getName(selector));
                }
            } else {
                syLog(@"\n ! %s \n present error :  %s not exist \n ! \n",__func__,sel_getName(selector));
            }
        } else {
            syLog(@"gid error -> game not exist %@",gid);
        }
    } else {
        FFWebViewController *webView = [FFWebViewController new];
        [webView setWebURL:info[@"url"]];
        [self pushViewController:webView];
    }
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

- (void)FFBTServerHeaderView:(FFBTServerHeaderView *)headerView didSelectSearchViewWithInfo:(id)info {
    syLog(@"搜索!!!!!!!!!!!!");
    switch (self.type) {
        case BT_SERVERS:{
            pushViewController(@"FFBTClassifyController");
            vc ? [vc setValue:self.topGameName forKey:@"topGameName"] : 0;

//            [self pushViewController:vc];

//            FFBTClassifyController *vc = [[FFBTClassifyController alloc] init];
//            vc.topGameName = self.topGameName;
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case ZK_SERVERS:{
            pushViewController(@"FFZKClassifyController");
            vc ? [vc setValue:self.topGameName forKey:@"topGameName"] : 0;
        }
            break;
        case H5_SERVERS:{
            pushViewController(@"FFH5ClassifyController");
            vc ? [vc setValue:self.topGameName forKey:@"topGameName"] : 0;
        }
            break;
        default:
            break;
    }

//    FFSearchController *searchVC = [[FFSearchController alloc] init];
//    searchVC.ServerType = self.type;
//    self.hidesBottomBarWhenPushed = YES;
//    [self pushViewController:searchVC];
}

#pragma mark -  scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;

    if (offset > 0) {
        if (self.tableHeaderView.isAddView) {
            return;
        }
        self.tableHeaderView.isAddView = YES;
        self.tableHeaderView.isAddHeader = NO;
        [self.view addSubview:self.tableHeaderView.searchView];

        [UIView animateWithDuration:0.15 animations:^{
            self.tableHeaderView.searchScrollImage.alpha = 1;
            self.tableHeaderView.searchView.layer.cornerRadius = 22;
            self.tableHeaderView.searchView.frame = self.tableHeaderView.searchScrollFrame;
        }];
    } else {
        if (self.tableHeaderView.isAddHeader) {
            return;
        }
        self.tableHeaderView.isAddHeader = YES;
        self.tableHeaderView.isAddView = NO;

        [self.tableHeaderView addSubview:self.tableHeaderView.searchView];
        [UIView animateWithDuration:0.15 animations:^{
            self.tableHeaderView.searchScrollImage.alpha = 0;
            self.tableHeaderView.searchView.layer.cornerRadius = 8;
            self.tableHeaderView.searchView.frame = self.tableHeaderView.searchHeaderFrame;
        }];
    }
}



#pragma mark - cell delegate
- (void)FFSRcommentCell:(FFSRcommentCell *)cell didSelectItemInfo:(id)info {
    syLog(@"cell  === %@",info);
    if ([info isKindOfClass:[NSDictionary class]]) {
        NSString *gid = [NSString stringWithFormat:@"%@",(info[@"id"]) ? info[@"id"] : info[@"gid"]];
        if (gid.length && gid.integerValue > 0) {
            Class FFGameViewController = NSClassFromString(@"FFGameViewController");
            SEL selector = NSSelectorFromString(@"sharedController");
            if ([FFGameViewController respondsToSelector:selector]) {
                IMP imp = [FFGameViewController methodForSelector:selector];
                UIViewController *(*func)(void) = (void *)imp;
                UIViewController *vc = func();
                if (vc) {
                    [vc setValue:gid forKey:@"gid"];
                    [self pushViewController:vc];
                } else {
                    syLog(@"\n ! %s \n present error :  %s not exist \n ! \n",__func__,sel_getName(selector));
                }
            } else {
                syLog(@"\n ! %s \n present error :  %s not exist \n ! \n",__func__,sel_getName(selector));
            }
        }
    }
}

#pragma mark - responds
/** 跳转分类 */ 
- (void)respondsToRightButton {
    pushViewController(@"FFBTClassifyController");
}

#pragma mark - setter
- (void)setNavigationTitle:(NSString *)title {
    self.navigationItem.title = @"BT服";
}

- (void)setTopGameName:(NSString *)topGameName {
    _topGameName = topGameName;
    [self.tableHeaderView.searchTitleButton setTitle:topGameName forState:(UIControlStateNormal)];
}


#pragma mark - getter
- (FFGameServersType)type {
    return BT_SERVERS;
}

- (NSArray *)selectButtonArray {
    return @[@"新游",@"排行榜",@"送满V",@"开服表"];
}

- (NSArray *)selectImageArray {
    return @[[FFImageManager Home_new_game],
             [FFImageManager Home_activity],
             [FFImageManager Home_hight_vip],
             [FFImageManager Home_classify]];
}

- (NSArray *)selectControllerName {
    return @[@"FFBTNewGameController",
             @"FFRankListViewController",
             @"FFHeightVipController",
             @"FFBTOpenServerViewController"];
    /** FFBTClassifyController */
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
        _tableHeaderView.backgroundColor = [UIColor whiteColor];
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
//    self.tableView.backgroundColor = [FFColorManager tableview_background_color];
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.tableFooterView = [UIView new];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentScrollableAxes;
    } else {

    }
    self.tableView.backgroundColor = [FFColorManager navigation_bar_white_color];
    self.tableView.mj_header = self.refreshHeader;
    self.tableView.mj_footer = self.refreshFooter;
    [self.view addSubview:self.tableView];
    [self registCell];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)registCell {
    [self.tableView registerClass:[FFSRcommentCell class] forCellReuseIdentifier:CELL_SRCELL];
    [self.tableView registerClass:[FFGameListBaseCell class] forCellReuseIdentifier:GamelistBaseCellIDE];
    self.tableView.tableHeaderView = self.tableHeaderView;
}




@end






