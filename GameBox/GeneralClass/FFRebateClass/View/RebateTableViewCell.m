//
//  RebateTableViewCell.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/6.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import "RebateTableViewCell.h"

@interface RebateTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *gameName;

@property (weak, nonatomic) IBOutlet UILabel *serverName;

@property (weak, nonatomic) IBOutlet UILabel *roleName;

@property (weak, nonatomic) IBOutlet UILabel *amount;

@property (weak, nonatomic) IBOutlet UIButton *applyButton;

@end


@implementation RebateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.applyButton.layer.borderColor = NAVGATION_BAR_COLOR.CGColor;
    self.applyButton.layer.borderWidth = 1;
    self.applyButton.layer.cornerRadius = 4;
    self.applyButton.layer.masksToBounds = YES;
    [self.applyButton setTitleColor:NAVGATION_BAR_COLOR forState:(UIControlStateNormal)];
}


#pragma mark - setter
- (void)setModel:(FFApplyRebateModel *)model {
    _model = model;
    self.gameName.text = _model.gameName;
    self.amount.text = [NSString stringWithFormat:@"%@",_model.gameCoin];
    self.userModel = _model.currentUserModel;
//    if (_model.userArray.count > 0) {
//        if (_userModel == nil) {
//            self.userModel = _model.userArray[0];
//        }
//    } else {
//        self.userModel = nil;
//    }
}

- (void)setUserModel:(FFApplyUserModel *)userModel {
    if (userModel == nil) {
        if (self.model.userArray && self.model.userArray.count > 0) {
            _userModel = self.model.userArray[0];
        }
    } else {
        _userModel = userModel;
    }
    self.serverName.text =_userModel.serverID;
    self.roleName.text = _userModel.roleName;
}

- (IBAction)ClickApplyButton:(id)sender {
    syLog(@"申请返利  %@",self.userModel);
    if (self.delegate && [self.delegate respondsToSelector:@selector(RebateTableViewCell:clickApplyButtonWithUserModel:)]) {
        [self.delegate RebateTableViewCell:self clickApplyButtonWithUserModel:self.userModel];
    }
}



@end














