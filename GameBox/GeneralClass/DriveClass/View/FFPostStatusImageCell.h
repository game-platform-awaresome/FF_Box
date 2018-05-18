//
//  FFPostStatusImageCell.h
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/24.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    showImage,
    addImage
} PostCellType;

@interface FFPostStatusImageCell : UICollectionViewCell

@property (nonatomic, assign) PostCellType type;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *playImageView;

@end
