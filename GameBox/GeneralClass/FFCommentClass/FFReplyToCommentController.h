//
//  FFReplyToCommentController.h
//  GameBox
//
//  Created by 燚 on 2018/5/23.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicViewController.h"

typedef void(^ReplyCommentBlock)(NSDictionary *content, BOOL success);

@interface FFReplyToCommentController : FFBasicViewController

@property (nonatomic, strong) NSDictionary *commentDict;
@property (nonatomic, strong) ReplyCommentBlock completion;

+ (instancetype)replyCommentWithCommentDict:(NSDictionary *)dict Completion:(ReplyCommentBlock)completion;

@end
