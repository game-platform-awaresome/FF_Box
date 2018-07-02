//
//  FFBusinessBoughtRecordController.m
//  GameBox
//
//  Created by 燚 on 2018/6/20.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessBoughtRecordController.h"
#import "FFBusinessModel.h"
#import "FFBusinessSellRecordCell.h"

#define CELL_IDE @"FFBusinessSellRecordCell"

@interface FFBusinessBoughtRecordController ()

@property (nonatomic, strong) UIView *remindeHeader;


@end

@implementation FFBusinessBoughtRecordController

- (void)initUserInterface {
    [super initUserInterface];
    self.tableView.tableHeaderView = self.remindeHeader;
}


- (void)refreshData {
    [self startWaiting];
    [FFBusinessModel userButRecordWithType:(FFBusinessUserBuyTypeAll) Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        if (success) {
            NSArray *array = CONTENT_DATA;
            if ([array isKindOfClass:[NSArray class]]) {
                self.showArray = array.mutableCopy;
            } else {
                [UIAlertController showAlertMessage:@"暂无购买记录" dismissTime:0.7 dismissBlock:nil];
            }
        } else {
            [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:nil];
        }
        syLog(@"user sell === %@",content);
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        [self.tableView reloadData];
    }];
}

- (void)loadMoreData {
    [self.refreshFooter endRefreshingWithNoMoreData];
}




#pragma mark - getter
- (BOOL)isBuy {
    return YES;
}

- (UIView *)remindeHeader {
    if (!_remindeHeader) {
        _remindeHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 70)];
        _remindeHeader.backgroundColor = [FFColorManager navigation_bar_white_color];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, kSCREEN_WIDTH - 16, 70)];
        label.text = @"交易成功后账号密码将会以短信的形式发送给您，请注意查收，如果长时间未收到请及时联系客服进行沟通";
        label.textColor = [FFColorManager blue_dark];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:13];
        [label sizeToFit];
        label.frame = CGRectMake(8, 8, kSCREEN_WIDTH - 16, label.bounds.size.height);

        _remindeHeader.frame = CGRectMake(0, 0, kSCREEN_WIDTH, label.bounds.size.height + 16);

        [_remindeHeader addSubview:label];
        [_remindeHeader.layer addSublayer:[self creatLineWithFrame:CGRectMake(0, _remindeHeader.bounds.size.height - 1, kSCREEN_WIDTH, 1)]];
    }
    return _remindeHeader;
}




@end











