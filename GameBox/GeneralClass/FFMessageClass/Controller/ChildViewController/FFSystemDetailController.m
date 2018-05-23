//
//  FFSystemDetailController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/12/21.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "FFSystemDetailController.h"
#import "FFSystemDetailView.h"
#import "FFMyNewsModel.h"
#import "FFViewFactory.h"

@interface FFSystemDetailController ()

@property (nonatomic, strong) FFSystemDetailView *detailView;

@end

@implementation FFSystemDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUserInterface];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"消息详情";
    [self.view addSubview:self.detailView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.detailView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), kSCREEN_WIDTH, kSCREEN_HEIGHT);
}
- (IBAction)respondsToReceiveButton:(UIButton *)sender {
    syLog(@"领取");
    START_NET_WORK;
    [FFMyNewsModel receiveAwardWithMessAgeId:self.detailView.dict[@"id"] WithUrl:self.detailView.dict[@"api_url"] Completion:^(NSDictionary *content, BOOL success) {
        START_NET_WORK;
        if (success) {
            BOX_MESSAGE(@"领取成功");
            self.dict = _dict;
        } else {
            BOX_MESSAGE(content[@"msg"]);
        }
    }];
}

#pragma mark - setter
- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    self.detailView.title = dict[@"title"];
    self.detailView.showReceiveButton = dict[@"action"];
    START_NET_WORK;
    [FFMyNewsModel messageDetailWithMessageID:dict[@"id"] Completion:^(NSDictionary *content, BOOL success) {
        syLog(@"message ==== %@",content);
        STOP_NET_WORK;
        if (success) {
            if ([(content[@"data"]) isKindOfClass:[NSDictionary class]]) {
                self.detailView.dict = content[@"data"];
            }
        } else {
            BOX_MESSAGE(content[@"msg"]);
        }
    }];
}

#pragma mark - getter
- (FFSystemDetailView *)detailView {
    if (!_detailView) {
        _detailView = [[UINib nibWithNibName:@"FFSystemDetailView" bundle:nil] instantiateWithOwner:nil options:nil].lastObject;
    }
    return _detailView;
}

@end






