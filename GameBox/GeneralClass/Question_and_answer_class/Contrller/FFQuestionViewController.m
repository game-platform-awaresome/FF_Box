//
//  FFQuestionViewController.m
//  GameBox
//
//  Created by 燚 on 2018/9/13.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFQuestionViewController.h"
#import <Masonry/Masonry.h>

@interface FFQuestionViewController ()
<UITableViewDelegate,
UITableViewDataSource>

@property (nonatomic, strong) id game;
@property (nonatomic, strong) NSString *game_id;

@property (nonatomic, strong) UITableView       *tableView;
@property (nonatomic, strong) NSMutableArray    *showArray;



@end

@implementation FFQuestionViewController

+ (instancetype)QuestionViewControllerWithGame:(id)game {
    FFQuestionViewController *controller = [[FFQuestionViewController alloc] init];
    controller.game = game;
    return controller;
}

#pragma mark - Life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarBGAlpha = @"0.0";
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
}

- (void)initUserInterface {
    [super initUserInterface];
    self.view.ff_size = CGSizeMake(kScreenWidth, kScreenHeight);

    self.tableView = [UITableView ff_tableViewWithSuperView:self.view
                                                   Delegate:self
                                                      Style:(UITableViewStylePlain)
                                             SeparatorStyle:(UITableViewCellSeparatorStyleNone)
                                                Constraints:^(MASConstraintMaker *make) {
                                                    make.edges.mas_equalTo(self.view);

    }];
    self.tableView.backgroundColor = kOrangeColor;

}

- (void)refreshData {

}



#pragma mark - tableview data source and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    return nil;
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











