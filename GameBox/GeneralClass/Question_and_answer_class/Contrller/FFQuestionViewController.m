//
//  FFQuestionViewController.m
//  GameBox
//
//  Created by 燚 on 2018/9/13.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFQuestionViewController.h"
#import <Masonry/Masonry.h>
#import "UIViewController+FFViewController.h"
#import "FFQuestionGameHeaderView.h"

@interface FFQuestionViewController ()
<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) id game;
@property (nonatomic, strong) NSString *game_id;

@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) NSMutableArray    *showArray;
@property (nonatomic, strong) NSMutableArray    *questionTitleArray;


@property (nonatomic, strong) UIView            *questionFooterView;



@end

@implementation FFQuestionViewController

+ (instancetype)QuestionViewControllerWithGame:(id)game {
    FFQuestionViewController *controller = [[FFQuestionViewController alloc] init];
    controller.game = game;
    return controller;
}

#pragma mark - Life cycle
- (void)viewWillAppear:(BOOL)animated {
    
    self.navBarBGAlpha = @"1.0";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)initDataSource {
    [super initDataSource];

    _questionTitleArray = @[@"星期1什么活动",@"星期2什么活动",@"星期3什么活动",@"星期4什么活动",@"星期5什么活动"].mutableCopy;
}

- (void)initUserInterface {
    [super initUserInterface];
    self.view.ff_size = CGSizeMake(kScreenWidth, kScreenHeight);
    self.navigationItem.title = @"游戏问答";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"须知" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToRightButton)];

    //footer view
    self.questionFooterView = [UIView ff_viewWithSuperView:self.view constraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).mas_offset(0);
        make.left.mas_equalTo(self.view).mas_offset(0);
        make.right.mas_equalTo(self.view).mas_offset(0);
        make.height.mas_equalTo(60);
    }];
    self.questionFooterView.backgroundColor = fWhiteColor;

    //question button
    UIButton *questionFooterButton  = [UIButton ff_buttonWithTitle:@"我要请教" SuperView:self.questionFooterView Constraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(CGPointZero);
        make.size.mas_equalTo(CGSizeMake(fScreenWidth * 0.8, 44));
    } TouchUp:^(UIButton *sender) {
        [self respondsToquestionButton];
    }];
    questionFooterButton.layer.cornerRadius = 22;
    questionFooterButton.layer.masksToBounds = YES;
    questionFooterButton.backgroundColor = [FFColorManager blue_dark];

    //table view
    self.tableView = [UITableView ff_tableViewWithSuperView:self.view
                                                   Delegate:self
                                                      Style:(UITableViewStylePlain)
                                             SeparatorStyle:(UITableViewCellSeparatorStyleNone)
                                                Constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).mas_offset(0);
        make.bottom.mas_equalTo(self.questionFooterView.mas_top).mas_offset(0);
        make.left.mas_equalTo(self.view).mas_offset(0);
        make.right.mas_equalTo(self.view).mas_offset(0);
    }];
    self.tableView.backgroundColor = fWhiteColor;
    self.tableView.tableHeaderView = [FFQuestionGameHeaderView new];


}

- (void)refreshData {

}

#pragma mark - responds
- (void)respondsToRightButton {
    syLog(@"须知");
}

- (void)respondsToQuestionWithSection:(NSUInteger)section {
    syLog(@"section === %ld",section);
}

- (void)respondsToquestionButton  {
    syLog(@"请教问题");
}


#pragma mark - tableview data source and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.questionTitleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_uideasdfasd"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell_uideasdfasd"];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self respondsToQuestionWithSection:indexPath.section];
}

#define section_heigth 44
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section_heigth;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fScreenWidth, section_heigth)];
    view.backgroundColor = fWhiteColor;
    [view ff_addTapGestureWithCallback:^(UITapGestureRecognizer *sender) {
        [self respondsToQuestionWithSection:section];
    }];

    UIImageView *logoImage = [UIImageView ff_imageViewWithImage:nil superView:view onstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(view).mas_offset(10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    logoImage.backgroundColor = fOrangeColor;

    UILabel *titleLabel = [UILabel ff_labelWithFont:15 superView:view constraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view).mas_equalTo(0);
        make.bottom.mas_equalTo(view).mas_equalTo(0);
        make.left.mas_equalTo(view).mas_offset(50);
        make.right.mas_lessThanOrEqualTo(view).mas_offset(-10);
    }];
    titleLabel.text = self.questionTitleArray[section];
    titleLabel.textColor = [FFColorManager textColorDark];

    return view;
}



#pragma mark - setter
- (void)setGame:(id)game {
    _game = game;
    if ([game isKindOfClass:[NSString class]]) {
        self.game_id = game;
    } else if ([game isKindOfClass:[NSDictionary class]]) {
        self.game_id = game[@"gid"] ?: game[@"id"];
    }
}


- (void)setGame_id:(NSString *)game_id {
    _game_id = game_id;
    [self refreshData];
}











@end











