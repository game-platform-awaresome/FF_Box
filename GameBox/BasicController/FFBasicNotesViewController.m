//
//  FFBasicNotesViewController.m
//  GameBox
//
//  Created by 燚 on 2018/5/23.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicNotesViewController.h"
#import "FFTransferNotesCell.h"
#import "FFUserModel.h"

#define ARROW_TAG 20065
#define CELL_IDE @"FFTransferNotesCell"

@interface FFBasicNotesViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation FFBasicNotesViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
    [self initDataSource];
}

- (void)initUserInterface {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"转游须知";
    [self.view addSubview:self.tableView];
}


- (void)initDataSource {
    syLog(@"download transfer data");
    [FFUserModel transferGameoticeCompletion:^(NSDictionary *content, BOOL success) {
        if (success) {
            self.showArray = content[@"data"];
            [self.showArray writeToFile:[self plistPath] atomically:YES];
            [self.tableView reloadData];
        }
    }];
}

- (void)getData {
    syLog(@"set data");
    self.showArray = [NSArray arrayWithContentsOfFile:[self plistPath]].mutableCopy;
    syLog(@"transfer note == %@",self.showArray);
    if (self.showArray == nil) {
        syLog(@"start download transfer data");
        [self initDataSource];
    }
}

- (NSString *)plistPath {
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"FFTransferNote.plist"];
    return filePath;
}


#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.showArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFTransferNotesCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.dict = self.showArray[indexPath.section];
    cell.backgroundColor = BACKGROUND_COLOR;

    return cell;
}

#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 60)];
    view.backgroundColor = [UIColor whiteColor];


    CALayer *layer1 = [[CALayer alloc] init];
    layer1.frame = CGRectMake(0, 59, kSCREEN_WIDTH, 1);
    layer1.backgroundColor = [UIColor lightGrayColor].CGColor;
    [view.layer addSublayer:layer1];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 60)];
    label.text = [NSString stringWithFormat:@"    %@",self.showArray[section][@"title"]];
    [view addSubview:label];

    UIButton *arrow = [UIButton buttonWithType:(UIButtonTypeCustom)];
    arrow.frame = CGRectMake(kSCREEN_WIDTH - 60, 0, 44, 44);
    arrow.center = CGPointMake(arrow.center.x, 30);
    [arrow setImage:[UIImage imageNamed:@"New_transfer_note_arrow"] forState:(UIControlStateNormal)];
    arrow.tag = ARROW_TAG + section;
    arrow.userInteractionEnabled = NO;
    FFTransferNotesCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    if (cell.showCell) {
        arrow.transform = CGAffineTransformMakeRotation(M_PI / 2);
    } else {
        arrow.transform = CGAffineTransformIdentity;
    }
    [view addSubview:arrow];

    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = view.bounds;
    button.tag = 10086 + section;
    [button addTarget:self action:@selector(respondsToSectionButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [view addSubview:button];

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFTransferNotesCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.showCell) {
        return tableView.rowHeight;
    }  else {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];
    FFTransferNotesCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.showCell = !cell.showCell;

    UIButton *arrow = [self.view viewWithTag:indexPath.section + ARROW_TAG];
    if (cell.showCell) {
        [UIView animateWithDuration:0.3 animations:^{
            arrow.transform = CGAffineTransformMakeRotation(M_PI / 2);
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            arrow.transform = CGAffineTransformIdentity;
        }];
    }
    [tableView endUpdates];
}

#pragma mark - responds
- (void)respondsToSectionButton:(UIButton *)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:(sender.tag - 10086)];

    [self.tableView beginUpdates];
    FFTransferNotesCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.showCell = !cell.showCell;

    UIButton *arrow = [self.view viewWithTag:(sender.tag - 10086) + ARROW_TAG];
    if (cell.showCell) {
        [UIView animateWithDuration:0.3 animations:^{
            arrow.transform = CGAffineTransformMakeRotation(M_PI / 2);
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            arrow.transform = CGAffineTransformIdentity;
        }];
    }
    [self.tableView endUpdates];
}




#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), kSCREEN_WIDTH, kSCREEN_HEIGHT - CGRectGetMaxY(self.navigationController.navigationBar.frame)) style:(UITableViewStylePlain)];

        [_tableView registerNib:[UINib nibWithNibName:CELL_IDE bundle:nil] forCellReuseIdentifier:CELL_IDE];

        _tableView.delegate = self;
        _tableView.dataSource = self;

        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 80;
        _tableView.rowHeight = UITableViewAutomaticDimension;

    }
    return _tableView;
}








@end
