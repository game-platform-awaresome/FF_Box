//
//  FFBasicSSSelectView.h
//  GameBox
//
//  Created by 燚 on 2018/5/17.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void(^SelectIndexBlock)(NSUInteger idx);
@interface FFBasicSSSelectView : UIView


@property (nonatomic, strong) NSArray<NSString *> *titleArray;

@property (nonatomic, strong) UIColor *headerLineColor;
@property (nonatomic, strong) UIColor *footerLineColor;

@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectColor;

@property (nonatomic, strong) UIColor *cursorColor;
@property (nonatomic, strong) SelectIndexBlock selectBlock;


- (instancetype)initWithFrame:(CGRect)frame;


- (void)setButtonSubscriptWithIdx:(NSUInteger)idx Title:(NSString *)title;



@end


@interface FFBasicSSSelectView (Deprecated)

- (instancetype)init __attribute__((deprecated("This method is not supported.")));
- (instancetype)new __attribute__((deprecated("This method is not supported.")));

@end
