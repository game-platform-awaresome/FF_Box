//
//  FFGameDetailGuideModel.h
//  GameBox
//
//  Created by 燚 on 2018/8/20.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GuideDetailModel ([FFGameDetailGuideModel sharedModel])

typedef void(^respondsToLikeButton)(NSDictionary *dict,NSIndexPath *indexPath);
typedef void(^respondsToDislikeButton)(NSDictionary *dict,NSIndexPath *indexPath);
typedef void(^respondsToSharedButton)(NSDictionary *dict,NSIndexPath *indexPath);

@interface FFGameDetailGuideModel : NSObject

@property (nonatomic, strong) respondsToLikeButton      likeButton;
@property (nonatomic, strong) respondsToDislikeButton   dislikeButton;
@property (nonatomic, strong) respondsToSharedButton    sharedBuntton;


+ (FFGameDetailGuideModel *)sharedModel;



@end
