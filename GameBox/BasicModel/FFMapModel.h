//
//  FFMapModel.h
//  GameBox
//
//  Created by 燚 on 2018/4/24.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicModel.h"

#define Map [FFMapModel map]

typedef void(^Completion)(void);

@interface FFMapModel : FFBasicModel

@property (nonatomic, strong) NSString *DOAMIN;
@property (nonatomic, strong) NSString *GAME_BOX_INSTALL_INFO;
@property (nonatomic, strong) NSString *GAME_BOX_START_INFO;
@property (nonatomic, strong) NSString *GAME_CHANNEL_DOWNLOAD;
@property (nonatomic, strong) NSString *GAME_CHECK_CLIENT;
@property (nonatomic, strong) NSString *GAME_CLASS;
@property (nonatomic, strong) NSString *GAME_CLASS_INFO;
@property (nonatomic, strong) NSString *GAME_COLLECT;
@property (nonatomic, strong) NSString *GAME_DOWNLOAD_RECORD;
@property (nonatomic, strong) NSString *GAME_ERROR_LOG;
@property (nonatomic, strong) NSString *GAME_GETALLNAME;
@property (nonatomic, strong) NSString *GAME_GETHOT;
@property (nonatomic, strong) NSString *GAME_GET_START_IMGS;
@property (nonatomic, strong) NSString *GAME_GONGLUE;
@property (nonatomic, strong) NSString *GAME_GRADE;
@property (nonatomic, strong) NSString *GAME_INDEX;
@property (nonatomic, strong) NSString *GAME_INFO;
@property (nonatomic, strong) NSString *GAME_INSTALL;
@property (nonatomic, strong) NSString *GAME_MY_COLLECT;
@property (nonatomic, strong) NSString *GAME_OPEN_SERVER;
@property (nonatomic, strong) NSString *GAME_PACK;
@property (nonatomic, strong) NSString *GAME_SEARCH_LIST;
@property (nonatomic, strong) NSString *GAME_TYPE;
@property (nonatomic, strong) NSString *GAME_UNINSTALL;
@property (nonatomic, strong) NSString *GAME_UPDATA;
@property (nonatomic, strong) NSString *INDEX_ARTICLE;
@property (nonatomic, strong) NSString *INDEX_SLIDE;
@property (nonatomic, strong) NSString *OPEN_SERVER;
@property (nonatomic, strong) NSString *PACKS_LINGQU;
@property (nonatomic, strong) NSString *PACKS_LIST;
@property (nonatomic, strong) NSString *PACKS_SLIDE;
@property (nonatomic, strong) NSString *USER_CHECKMSG;
@property (nonatomic, strong) NSString *USER_FINDPWD;
@property (nonatomic, strong) NSString *USER_LOGIN;
@property (nonatomic, strong) NSString *USER_MODIFYNN;
@property (nonatomic, strong) NSString *USER_MODIFYPWD;
@property (nonatomic, strong) NSString *USER_PACK;
@property (nonatomic, strong) NSString *USER_REGISTER;
@property (nonatomic, strong) NSString *USER_SENDMSG;
@property (nonatomic, strong) NSString *USER_UPLOAD;

//new
@property (nonatomic, strong) NSString *CHANGEGAME_APPLY;
@property (nonatomic, strong) NSString *CHANGEGAME_LOG;
@property (nonatomic, strong) NSString *COIN_INFO;
@property (nonatomic, strong) NSString *COIN_LOG;
@property (nonatomic, strong) NSString *COMMENT_COIN;
@property (nonatomic, strong) NSString *CUSTOMER_SERVICE;
@property (nonatomic, strong) NSString *DO_SIGN;
@property (nonatomic, strong) NSString *FREND_RECOM;
@property (nonatomic, strong) NSString *FRIEND_RECOM_INFO;
@property (nonatomic, strong) NSString *MY_COIN;
@property (nonatomic, strong) NSString *PAY_QUERY;
@property (nonatomic, strong) NSString *PAY_READY;
@property (nonatomic, strong) NSString *PAY_START;
@property (nonatomic, strong) NSString *PLAT_EXCHANGE;
@property (nonatomic, strong) NSString *PLAT_LOG;
@property (nonatomic, strong) NSString *REBATE_INFO;
@property (nonatomic, strong) NSString *REBATE_NOTICE;
@property (nonatomic, strong) NSString *REBATE_RECORD;
@property (nonatomic, strong) NSString *SIGN_INIT;
@property (nonatomic, strong) NSString *USER_CENTER;
@property (nonatomic, strong) NSString *VIP_OPTION;
@property (nonatomic, strong) NSString *CHANGEGAME_NOTICE;
@property (nonatomic, strong) NSString *REBATE_KNOW;
@property (nonatomic, strong) NSString *REBATE_APPLY;
@property (nonatomic, strong) NSString *USER_BIND_MOBILE;
@property (nonatomic, strong) NSString *USER_UNBIND_MOBILE;
@property (nonatomic, strong) NSString *MY_PRIZE;
@property (nonatomic, strong) NSString *APP_NOTICE;


//new
@property (nonatomic, strong) NSString *MESSAGE_UNREAD;
@property (nonatomic, strong) NSString *MESSAGE_LIST;
@property (nonatomic, strong) NSString *MESSAGE_INFO;
@property (nonatomic, strong) NSString *MESSAGE_DELETE;
@property (nonatomic, strong) NSString *GET_PATCH;
@property (nonatomic, strong) NSString *PLAT_REG_BONUS;


//new community
@property (nonatomic, strong) NSString *PUBLISH_DYNAMICS;
@property (nonatomic, strong) NSString *USER_DESC;
@property (nonatomic, strong) NSString *DYNAMICS_LIKE;
@property (nonatomic, strong) NSString *FOLLOW_LIST;
@property (nonatomic, strong) NSString *USER_EDIT;
@property (nonatomic, strong) NSString *COMMENT_LIKE;
@property (nonatomic, strong) NSString *GET_DYNAMICS;
@property (nonatomic, strong) NSString *COMMENT;
@property (nonatomic, strong) NSString *COMMENT_LIST;
@property (nonatomic, strong) NSString *COMMENT_DEL;

///
@property (nonatomic, strong) NSString *FOLLOW_OR_CANCEL;
@property (nonatomic, strong) NSString *DYNAMICS_WAP_INFO;
@property (nonatomic, strong) NSString *SHARE_DYNAMICS;

//
@property (nonatomic, strong) NSString *USER_NEW_UP;
@property (nonatomic, strong) NSString *USER_COMMENT_ZAN;

//取消赞踩接口
@property (nonatomic, strong) NSString *CANCEL_DYNAMICS_LIKE;
@property (nonatomic, strong) NSString *CANCEL_COMMENT_LIKE;

//
@property (nonatomic, strong) NSString *BOX_INIT;

//删除动态
@property (nonatomic, strong) NSString *DEL_DYNAMIC;
//评论数
@property (nonatomic, strong) NSString *COMMENT_COUNTS;
//礼包信息
@property (nonatomic, strong) NSString *PACKAGE_INFO;

//邀请排行榜
@property (nonatomic, strong) NSString *RANKING_LIST;
//接收奖励
@property (nonatomic, strong) NSString *RECEIVE_REWARD;
//用户协议
@property (nonatomic, strong) NSString *USER_AGREEMENT;

//
@property (nonatomic, strong) NSString *COMMENT_REPLY_LIST;
@property (nonatomic, strong) NSString *USER_RANKING;
@property (nonatomic, strong) NSString *RANKNOTICE;
@property (nonatomic, strong) NSString *USER_APP_LOGIN;

@property (nonatomic, strong) NSString *GAME_NEWINDEX;


+ (instancetype)map;

+ (void)getMapCompletion:(Completion)completion;


@end

