//
//  BusinessCustomerCell.m
//  GameBox
//
//  Created by 燚 on 2018/6/20.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "BusinessCustomerCell.h"
#import "FFColorManager.h"

@interface BusinessCustomerCell ()

@property (weak, nonatomic) IBOutlet UILabel *customerLabel;
@property (weak, nonatomic) IBOutlet UILabel *remindLabel;
@property (weak, nonatomic) IBOutlet UILabel *QQLabel;


@end


@implementation BusinessCustomerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.customerLabel.layer.cornerRadius = 8;
    self.remindLabel.layer.cornerRadius = self.remindLabel.bounds.size.height / 2;
    self.remindLabel.layer.borderColor = [FFColorManager blue_dark].CGColor;
    self.remindLabel.layer.borderWidth = 1;
    self.remindLabel.layer.masksToBounds = YES;
}



- (void)setQq:(NSString *)qq {
    self.QQLabel.text = [NSString stringWithFormat:@"QQ : %@",qq];
}









@end
