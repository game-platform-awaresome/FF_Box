//
//  GiftBagCell.h
//  GameBox
//
//  Created by 石燚 on 2017/4/11.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
@class FFpackageCell;

@protocol FFpackageCellDelegate <NSObject>

- (void)FFpackageCell:(FFpackageCell *)cell select:(NSInteger)idx;

@end

@interface FFpackageCell : UITableViewCell

/**< 礼包图片 */
@property (weak, nonatomic) IBOutlet UIImageView *gameLogo;

/**< 礼包名 */
@property (weak, nonatomic) IBOutlet UILabel *name;

/**< 礼包数 */
@property (weak, nonatomic) IBOutlet UILabel *packCounts;

/**< 礼包进度条(背景) */
@property (weak, nonatomic) IBOutlet UIView *packProgress;

/**< 领取按钮 */
@property (weak, nonatomic) IBOutlet UIButton *getBtn;

/**< 礼包进度百分比 */
@property (nonatomic, strong) UILabel * titlelabel;

/**< 礼包进图条 */
@property (nonatomic, strong) UIView * progressView;

/**< 礼包下标 */
@property (nonatomic, assign) NSInteger currentIdx;

/**< 礼包cell的代理 */
@property (nonatomic, weak) id<FFpackageCellDelegate> delegate;


@property (nonatomic, strong) NSDictionary *dict;


@end
