//
//  FFPromiseCell.h
//  GameBox
//
//  Created by 燚 on 2018/5/29.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FFPromiseCell;

@protocol FFPromiseCellDelegate <NSObject>

- (void)FFPromiseCell:(FFPromiseCell *)cell clickQQButtonWithString:(NSString *)qq;

@end

@interface FFPromiseCell : UITableViewCell

@property (nonatomic, weak) id<FFPromiseCellDelegate> delegate;
@property (nonatomic, strong) NSDictionary *dict;


@end
