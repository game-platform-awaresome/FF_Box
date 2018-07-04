//
//  FFCommodityHeaderView.m
//  GameBox
//
//  Created by 燚 on 2018/6/15.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFCommodityHeaderView.h"
#import "FFImageManager.h"
#import "FFColorManager.h"
#import <UIImageView+WebCache.h>

#define CommodityModel() [FFCommodityModel sharedModel]

@interface FFCommodityHeaderView ()

@property (nonatomic, strong) UIView *gameBackView;
@property (nonatomic, strong) UIImageView *gamelogoImageView;
@property (nonatomic, strong) UILabel *gameNameLabel;
@property (nonatomic, strong) UILabel *gameSizeLabel;

@property (nonatomic, strong) UIView *productBackView;
@property (nonatomic, strong) UILabel *serverLabel;
@property (nonatomic, strong) UILabel *systemLabel;
@property (nonatomic, strong) UILabel *creatTimeLabel;
@property (nonatomic, strong) UILabel *remindLabel;
@property (nonatomic, strong) UILabel *amountLabel;

@property (nonatomic, strong) UIView *descriptionBackView;
@property (nonatomic, strong) CALayer *desLine;
@property (nonatomic, strong) UILabel *desTitleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;




@end

@implementation FFCommodityHeaderView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    [self addSubview:self.gameBackView];
    [self addSubview:self.productBackView];
    [self addSubview:self.descriptionBackView];
}

- (CALayer *)lineLayerWithFrame:(CGRect)frame {
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = frame;
    layer.backgroundColor = [FFColorManager view_separa_line_color].CGColor;
    return layer;
}

- (void)refreshData {
    [self.desLine removeFromSuperlayer];
    self.desLine = nil;
    [self.gamelogoImageView sd_setImageWithURL:[NSURL URLWithString:CommodityModel().gameLogoUrl] placeholderImage:[FFImageManager gameLogoPlaceholderImage]];
    self.gameNameLabel.text = CommodityModel().gameName;
    self.gameSizeLabel.text = [NSString stringWithFormat:@"%@M",CommodityModel().gameSize];
    self.serverLabel.text = [NSString stringWithFormat:@"所在区服 : %@",CommodityModel().serverName];
    self.systemLabel.text = [NSString stringWithFormat:@"游戏平台 : %@",CommodityModel().system];
    self.creatTimeLabel.text = [NSString stringWithFormat:@"账号创建于%@,当前游戏已充值%@元",CommodityModel().creatTime,CommodityModel().payMoney];
    self.remindLabel.text = [NSString stringWithFormat:@"此账号已经过185官方审核,请放心购买."];
    self.amountLabel.text = [NSString stringWithFormat:@"%@元",CommodityModel().amount];
    [self setDesString:CommodityModel().pdescription];

    [self.descriptionBackView.layer addSublayer:self.desLine];
    self.bounds = CGRectMake(0, 0, kSCREEN_WIDTH, CGRectGetMaxY(self.descriptionBackView.frame));
}

- (void)setDesString:(NSString *)string {
    CGFloat height = [self calculateStringHeightWithString:string];
    CGRect frame = self.descriptionLabel.frame;
    frame.size.height = height + 3;
    self.descriptionLabel.frame = frame;
    self.descriptionBackView.frame = CGRectMake(0, CGRectGetMaxY(self.productBackView.frame), kSCREEN_WIDTH, CGRectGetMaxY(self.descriptionLabel.frame) + 10);
    self.descriptionLabel.text = string;
}
/** 计算文字高度 */
- (CGFloat)calculateStringHeightWithString:(NSString *)string {
    CGFloat Max_Height = 0;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize retSize = [string boundingRectWithSize:CGSizeMake(kSCREEN_WIDTH - 32, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    if (retSize.height > Max_Height) {
        Max_Height = retSize.height;
    }
    return Max_Height;
}

#pragma makr - getter
- (UIView *)gameBackView {
    if (!_gameBackView) {
        _gameBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 80)];
        _gameBackView.backgroundColor = [FFColorManager navigation_bar_white_color];
        [_gameBackView addSubview:self.gamelogoImageView];
        [_gameBackView addSubview:self.gameNameLabel];
        [_gameBackView addSubview:self.gameSizeLabel];
        [_gameBackView.layer addSublayer:[self lineLayerWithFrame:CGRectMake(0, 79, kSCREEN_WIDTH, 1)]];
    }
    return _gameBackView;
}

- (UIImageView *)gamelogoImageView {
    if (!_gamelogoImageView) {
        _gamelogoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 10, 60, 60)];
        _gamelogoImageView.layer.cornerRadius = 8;
        _gamelogoImageView.layer.masksToBounds = YES;
    }
    return _gamelogoImageView;
}

- (UILabel *)creatLabelWithFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = [FFColorManager textColorMiddle];
    return label;
}

- (UILabel *)gameNameLabel {
    if (!_gameNameLabel) {
        _gameNameLabel = [self creatLabelWithFrame:CGRectMake(CGRectGetMaxX(self.gamelogoImageView.frame) + 8, 10, kSCREEN_WIDTH / 2, 20)];
    }
    return _gameNameLabel;
}

- (UILabel *)gameSizeLabel {
    if (!_gameSizeLabel) {
        _gameSizeLabel = [self creatLabelWithFrame:CGRectMake(CGRectGetMaxX(self.gamelogoImageView.frame) + 8, 50, kSCREEN_WIDTH / 2, 20)];
    }
    return _gameSizeLabel;
}


- (UIView *)productBackView {
    if (!_productBackView) {
        _productBackView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.gameBackView.frame), kSCREEN_WIDTH, 130)];
        _productBackView.backgroundColor = [FFColorManager navigation_bar_white_color];

        [_productBackView addSubview:self.serverLabel];
        [_productBackView addSubview:self.systemLabel];
        [_productBackView addSubview:self.creatTimeLabel];
        [_productBackView addSubview:self.amountLabel];
        [_productBackView addSubview:self.remindLabel];

        [_productBackView.layer addSublayer:[self lineLayerWithFrame:CGRectMake(0, _productBackView.bounds.size.height - 1, kSCREEN_WIDTH, 1)]];
    }
    return _productBackView;
}

- (UILabel *)serverLabel {
    if (!_serverLabel) {
        _serverLabel = [self creatLabelWithFrame:CGRectMake(16, 10, kSCREEN_WIDTH / 2, 20)];
    }
    return _serverLabel;
}

- (UILabel *)systemLabel {
    if (!_systemLabel) {
        _systemLabel  = [self creatLabelWithFrame:CGRectMake(16, CGRectGetMaxY(self.serverLabel.frame) + 10, kSCREEN_WIDTH / 2, 20)];
    }
    return _systemLabel;
}

- (UILabel *)creatTimeLabel {
    if (!_creatTimeLabel) {
        _creatTimeLabel = [self creatLabelWithFrame:CGRectMake(16, CGRectGetMaxY(self.systemLabel.frame)+ 20, kSCREEN_WIDTH - 32, 20)];
        _creatTimeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _creatTimeLabel;
}

- (UILabel *)remindLabel {
    if (!_remindLabel) {
        _remindLabel = [self creatLabelWithFrame:CGRectMake(16, CGRectGetMaxY(self.creatTimeLabel.frame), kSCREEN_WIDTH - 32, 20)];
        _remindLabel.font = [UIFont systemFontOfSize:14];
        _remindLabel.textColor = [FFColorManager blue_dark];
    }
    return _remindLabel;
}

- (UILabel *)amountLabel {
    if (!_amountLabel) {
        _amountLabel = [self creatLabelWithFrame:CGRectMake(kSCREEN_WIDTH / 3 * 2 - 16 , 10, kSCREEN_WIDTH / 3, 20)];
        _amountLabel.textAlignment = NSTextAlignmentRight;
        _amountLabel.textColor = [UIColor redColor];
        _amountLabel.font = [UIFont systemFontOfSize:18];
    }
    return _amountLabel;
}

- (UIView *)descriptionBackView {
    if (!_descriptionBackView) {
        _descriptionBackView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.productBackView.frame), kSCREEN_WIDTH, 80)];
        [_descriptionBackView addSubview:self.desTitleLabel];
        [_descriptionBackView addSubview:self.descriptionLabel];

//        [_descriptionBackView.layer addSublayer:self.desLine];
    }
    return _descriptionBackView;
}

- (CALayer *)desLine {
    if (!_desLine) {
        _desLine = [self lineLayerWithFrame:CGRectMake(0, self.descriptionBackView.frame.size.height - 1, kSCREEN_WIDTH, 1)];
    }
    return _desLine;
}

- (UILabel *)desTitleLabel {
    if (!_desTitleLabel) {
        _desTitleLabel = [self creatLabelWithFrame:CGRectMake(16, 10, kSCREEN_WIDTH - 32, 44)];
        _desTitleLabel.text = @"详情描述 : ";
        _desTitleLabel.font = [UIFont systemFontOfSize:18];
        [_desTitleLabel sizeToFit];
        _desTitleLabel.center = CGPointMake(16 + _desTitleLabel.bounds.size.width / 2, 10 + _desTitleLabel.bounds.size.height / 2);
    }
    return _desTitleLabel;
}

- (UILabel *)descriptionLabel {
    if (!_descriptionLabel) {
        _descriptionLabel = [self creatLabelWithFrame:CGRectMake(16, CGRectGetMaxY(self.desTitleLabel.frame) + 10, kSCREEN_WIDTH - 32, 20)];
        _descriptionLabel.font = [UIFont systemFontOfSize:14];
        _descriptionLabel.numberOfLines = 0;
    }
    return _descriptionLabel;
}




@end



#pragma mark - model
static FFCommodityModel *_model = nil;
@implementation FFCommodityModel

+ (FFCommodityModel *)sharedModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_model) {
            _model = [[FFCommodityModel alloc] init];
        }
    });
    return _model;
}

- (void)setInfoWithDict:(NSDictionary *)dict {
    if ([dict isKindOfClass:[NSDictionary class]]) {
        self.account      = dict[@"account"];
        self.creatTime    = dict[@"account_cretime"];
        self.boxGameID    = dict[@"box_gameid"];
        self.pdescription = dict[@"desc"];
        self.gameLogoUrl  = dict[@"game_logo"];
        self.gameName     = dict[@"game_name"];
        self.imageArray   = dict[@"imgs"];
        self.payMoney     = dict[@"pay_money"];
        self.amount       = dict[@"price"];
        self.serverName   = dict[@"server_name"];
        self.gameSize     = dict[@"size"];
        self.system       = dict[@"system"];
        self.title        = dict[@"title"];
    }
}

- (void)setAccount:(NSString *)account {
    _account = [NSString stringWithFormat:@"%@",account];
}

- (void)setCreatTime:(NSString *)creatTime {
    _creatTime = [NSString stringWithFormat:@"%@",creatTime];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_creatTime.integerValue];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"YYYY年MM月dd日";
    _creatTime = [formatter stringFromDate:date];
}

- (void)setBoxGameID:(NSString *)boxGameID {
    _boxGameID = [NSString stringWithFormat:@"%@",boxGameID];
}

- (void)setPdescription:(NSString *)pdescription {
    _pdescription = [NSString stringWithFormat:@"%@",pdescription];
}

- (void)setGameLogoUrl:(NSString *)gameLogoUrl {
    _gameLogoUrl = [NSString stringWithFormat:@"%@",gameLogoUrl];
}

- (void)setGameName:(NSString *)gameName {
    _gameName = [NSString stringWithFormat:@"%@",gameName];
}

- (void)setImageArray:(NSArray *)imageArray {
    if ([imageArray isKindOfClass:[NSArray class]])  {
        _imageArray = imageArray;
        _heightDict = [NSMutableDictionary dictionaryWithCapacity:imageArray.count];
//        _heightArray = [NSMutableArray arrayWithCapacity:imageArray.count];
//        for (id obj in imageArray) {
//            [_heightArray addObject:[NSNumber numberWithFloat:200.f]];
//        }
    }
}

- (void)setPayMoney:(NSString *)payMoney {
    _payMoney = [NSString stringWithFormat:@"%@",payMoney];
}

- (void)setAmount:(NSString *)amount {
    _amount = [NSString stringWithFormat:@"%@",amount];
}

- (void)setServerName:(NSString *)serverName {
    _serverName = [NSString stringWithFormat:@"%@",serverName];
}

- (void)setGameSize:(NSString *)gameSize {
    _gameSize = [NSString stringWithFormat:@"%@",gameSize];
}

- (void)setSystem:(NSString *)system {
    _system = ([NSString stringWithFormat:@"%@",system].integerValue == 1) ? @"Android" : ([NSString stringWithFormat:@"%@",system].integerValue == 2) ? @"iOS" : @"双平台";
}

- (void)setTitle:(NSString *)title {
    _title = [NSString stringWithFormat:@"%@",title];
}


@end






