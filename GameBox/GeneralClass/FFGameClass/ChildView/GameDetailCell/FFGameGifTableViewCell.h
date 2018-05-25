//
//  GifTableViewCell.h
//  GameBox
//
//  Created by 石燚 on 2017/5/27.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAnimatedImageView.h"

@class FLAnimatedImageView;

@interface FFGameGifTableViewCell : UITableViewCell

/** gif图片 */
@property (nonatomic, strong) FLAnimatedImageView *gifImageView;

/** gif图片地址 */
@property (nonatomic, strong) NSString *gifUrl;

/** 是否加载 gif 图片 */
@property (nonatomic, assign) BOOL isLoadGif;

/** 提示字符 */
@property (nonatomic, strong) UILabel *label;


@end
