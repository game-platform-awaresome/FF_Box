//
//  FFApplyTransferView.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2017/11/9.
//  Copyright © 2017年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FFApplyTransferView;

@protocol FFApplyTransferViewDelegate <NSObject>

- (void)FFApplyTransferView:(FFApplyTransferView *)view clickSureButton:(NSDictionary *)info;

@end

@interface FFApplyTransferView : UIView


@property (nonatomic, weak) id<FFApplyTransferViewDelegate> delegate;


- (void)setAllTextfildNil;

@end
