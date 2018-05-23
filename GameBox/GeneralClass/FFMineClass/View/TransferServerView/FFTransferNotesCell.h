//
//  FFTransferNotesCell.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/22.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFTransferNotesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *tTitleLabel;

@property (nonatomic, strong) NSDictionary *dict;


@property (nonatomic, assign) BOOL showCell;

@end
