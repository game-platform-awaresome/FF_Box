//
//  FFGameDetailFooterView.h
//  GameBox
//
//  Created by 燚 on 2018/5/21.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FFGameFooterView;

@protocol FFGameDetailFooterViewDelegate <NSObject>

/** 点击收藏按钮 */
- (void)FFGameDetailFooterView:(FFGameFooterView *)detailFooter clickCollecBtn:(UIButton *)sender;

/** 点击分享按钮 */
- (void)FFGameDetailFooterView:(FFGameFooterView *)detailFooter clickShareBtn:(UIButton *)sender;

/** 点击现在按钮 */
- (void)FFGameDetailFooterView:(FFGameFooterView *)detailFooter clickDownLoadBtn:(UIButton *)sender;

@end



@interface FFGameFooterView : UIView

@property (nonatomic, weak) id<FFGameDetailFooterViewDelegate> delegate;


- (void)refresh;


@end








