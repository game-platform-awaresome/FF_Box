//
//  FFBusinessProductController.m
//  GameBox
//
//  Created by 燚 on 2018/6/14.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessProductController.h"
#import "UIViewController+FFViewController.h"
#import "FFImageManager.h"
#import "FFColorManager.h"
#import "ZLPhotoActionSheet.h"
#import "FFPostStatusImageCell.h"
#import <FFTools/FFTools.h>
#import "FFBusinessProductDetailViewController.h"
#import "FFBusinessModel.h"
#import "FFWaitingManager.h"
#import <UIImageView+WebCache.h>
#import "FFBusinessBuyModel.h"

#define CELL_IDE @"FFPostStatusImageCell"

#define Show_message(message) [UIAlertController showAlertMessage:message dismissTime:0.7 dismissBlock:nil];

#define text_view_holder_string @"请详细描述当前角色的等级、装备、资源等角色信息，可以使您更快完成交易（200字内）"

typedef enum : NSUInteger {
    FFBusinessPickerTypeSystem = 1,
    FFBusinessPickerTypeTime
} FFBusinessPikcerType;


void respondsToSystemPicker(NSString *system);
void respondsToTimePicker(NSString *time);

@interface FFBusinessPikcerContorller : UIViewController

@property (nonatomic, strong) NSArray *systemArray;
@property (nonatomic, strong) NSDictionary *systemDict;


+ (void)PickerWithType:(FFBusinessPikcerType)type;
  
@end


@interface FFBusinessProductController () <UITextFieldDelegate,UITextViewDelegate>


@property (nonatomic, assign) BOOL isOriginal;

@property (nonatomic, assign) BOOL isRequest;

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, assign) NSInteger hudNumber;


@property (nonatomic, assign) BOOL editGameImage;
@property (nonatomic, assign) BOOL editTradeImage;

@end


static BOOL FFBusinessEditGameImage = NO;
static BOOL FFBusinessEditTradeImage = NO;

@implementation FFBusinessProductController


+ (instancetype)init {
    return [[UIStoryboard storyboardWithName:@"MyStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"FFBusinessProductController"];
}

static FFBusinessProductController *controller = nil;
+ (instancetype)initwithGameName:(NSString *)gameName Account:(NSString *)account {
    if (controller == nil) {
        controller = [self init];
    }
    FFBusinessEditGameImage = YES;
    FFBusinessEditTradeImage = YES;
    controller.isEdit = NO;
    controller.postType = NO;
    controller.gameName = gameName;
    controller.account = account;
    controller.productInfo = nil;
    controller.gameCollectionView.imagesArray = nil;
    controller.tradeCollectionView.imagesArray = nil;
    [controller.tableView reloadData];
    return controller;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.gameNameLabel.text = self.gameName;
    self.sdkAccountLabel.text = self.account;
    self.timeLabel.text = self.time;
    self.amountTF.placeholder = [NSString stringWithFormat:@"不能低于 %@",[FFBusinessBuyModel sharedModel].productAmountLimit];
    if (self.productInfo != nil) {
        [self setInfoWith:self.productInfo];
        self.productInfo = nil;
    }

    self.selectPicButton.hidden = !self.isEdit;
    self.selectTradeButton.hidden = !self.isEdit;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self initUserInterface];
}

- (void)initDataSource {
    [self.gameCollectionView registerClass:NSClassFromString(CELL_IDE) forCellWithReuseIdentifier:CELL_IDE];
    [self.gameCollectionView setCollectionViewLayout:self.gameCollectionView.layout];
    self.gameCollectionView.delegate = self.gameCollectionView;
    self.gameCollectionView.dataSource = self.gameCollectionView;
    [self.tradeCollectionView registerClass:NSClassFromString(CELL_IDE) forCellWithReuseIdentifier:CELL_IDE];
    [self.tradeCollectionView setCollectionViewLayout:self.tradeCollectionView.layout];
    self.tradeCollectionView.delegate = self.tradeCollectionView;
    self.tradeCollectionView.dataSource = self.tradeCollectionView;
}

- (void)initUserInterface {
    self.navigationItem.title = @"出售商品";
    [self.leftButton setImage:[FFImageManager General_back_black]];
    self.navigationItem.leftBarButtonItem = self.leftButton;
    self.gameNameLabel.text = @"游戏";
    self.sdkAccountLabel.text = @"SDK 账号";
    self.sellButton.backgroundColor = [FFColorManager blue_dark];
    self.sellButton.layer.cornerRadius = self.sellButton.bounds.size.height / 2;
    self.sellButton.layer.masksToBounds = YES;
    self.productTitleTF.delegate = self;
    self.productDetailTextView.layer.cornerRadius = 8;
    self.productDetailTextView.layer.masksToBounds = YES;
    self.productDetailTextView.layer.borderWidth = 1;
    self.productDetailTextView.layer.borderColor = [FFColorManager view_separa_line_color].CGColor;
}

#pragma makr - responds
- (IBAction)respondsToSelectPicButton:(id)sender {
    [UIAlertController showAlertControllerWithViewController:self alertControllerStyle:(UIAlertControllerStyleAlert) title:nil message:@"点击后将清除之前的所有图片" cancelButtonTitle:@"取消" destructiveButtonTitle:nil CallBackBlock:^(NSInteger btnIndex) {
        if (btnIndex == 1) {
            [self.gameCollectionView showPhotoLibrary];
        }
    } otherButtonTitles:@"确定", nil];
}

- (IBAction)respondsToSelectTradeButton:(id)sender {
    [UIAlertController showAlertControllerWithViewController:self alertControllerStyle:(UIAlertControllerStyleAlert) title:nil message:@"点击后将清除之前的所有图片" cancelButtonTitle:@"取消" destructiveButtonTitle:nil CallBackBlock:^(NSInteger btnIndex) {
        if (btnIndex == 1) {
            [self.tradeCollectionView showPhotoLibrary];
        }
    } otherButtonTitles:@"确定", nil];
}


- (IBAction)respondsToSellButton:(id)sender {
    syLog(@"提交订单 !!!!!");
    if (_isRequest) {
        return;
    }

    _isRequest = YES;

    if (self.gameNameLabel.text.length < 1) {
        Show_message(@"游戏名称有误");
        _isRequest = NO;
        return;
    }
    if (self.sdkAccountLabel.text.length < 1) {
        Show_message(@"账号有误");
        _isRequest = NO;
        return;
    }
    if (self.serverTF.text.length < 1) {
        Show_message(@"区服有误");
        _isRequest = NO;
        return;
    }
    if (self.systemLabel.text.length < 1) {
        Show_message(@"平台有误");
        _isRequest = NO;
        return;
    }
    if (self.amountTF.text.length < 1) {
        Show_message(@"请输入价格");
        _isRequest = NO;
        return;
    }

    if (self.amountTF.text.floatValue < [FFBusinessBuyModel sharedModel].productAmountLimit.floatValue) {
        NSString *message = [NSString stringWithFormat:@"价格不能小于%@元",[FFBusinessBuyModel sharedModel].productAmountLimit];
        Show_message(message);
        _isRequest = NO;
        return;
    }

    if (self.productTitleTF.text.length < 1) {
        Show_message(@"请输入商品标题");
        _isRequest = NO;
        return;
    }

    if (self.productDetailTextView.text.length < 1 || [self.productDetailTextView.text isEqualToString:text_view_holder_string]) {
        Show_message(@"请输入商品描述");
        _isRequest = NO;
        return;
    }


    if (FFBusinessEditGameImage) {
        if (self.gameCollectionView.imagesArray.count < 2 || self.gameCollectionView.imagesArray.count > 7) {
            Show_message(@"请选择2-7张游戏截图上传");
            _isRequest = NO;
            return;
        }
    }

    if (FFBusinessEditTradeImage) {
        if (self.tradeCollectionView.imagesArray.count < 2 || self.tradeCollectionView.imagesArray.count > 7) {
            Show_message(@"请选择2-7张充值记录截图上传");
            _isRequest = NO;
            return;
        }
    }


    FFBusinessSystemType type = [self.systemLabel.text isEqualToString:@"iOS"] ? FFBusinessSystemTypeIOS : [self.systemLabel.text isEqualToString:@"Android"] ? FFBusinessSystemTypeAndroid : FFBusinessSystemTypeAll;

    if (self.postType) {
        //上架商品
        syLog(@"上架商品?????");
        [self startWaiting];
        [FFBusinessModel dropOnProductWithProductID:self.productID Title:self.productTitleTF.text Price:self.amountTF.text Description:self.productDetailTextView.text SystemType:type ServerName:self.serverTF.text EndTime:self.timeLabel.text Images:self.gameCollectionView.imagesArray TradeImgs:self.tradeCollectionView.imagesArray Completion:^(NSDictionary * _Nonnull content, BOOL success) {
            [self stopWaiting];
            self.isRequest = NO;
            if (success) {
                [UIAlertController showAlertControllerWithViewController:self alertControllerStyle:(UIAlertControllerStyleAlert) title:@"商品发布成功" message:@"商品进入审核阶段,需通过客服审核后才会展示,预计1-3天.如审核失败会告知您原因." cancelButtonTitle:@"确定" destructiveButtonTitle:nil CallBackBlock:^(NSInteger btnIndex) {
                    [self.navigationController popViewControllerAnimated:YES];
                } otherButtonTitles: nil];
            } else {
                Show_message(content[@"msg"]);
            }
        }];

    } else {
        [self startWaiting];
        //卖出商品
        [FFBusinessModel sellProductWithAppID:self.appid Title:self.productTitleTF.text SDKUsername:self.sdkAccountLabel.text Price:self.amountTF.text Description:self.productDetailTextView.text SystemType:type ServerName:self.serverTF.text EndTime:self.timeLabel.text Images:self.gameCollectionView.imagesArray TradeImgs:self.tradeCollectionView.imagesArray Completion:^(NSDictionary * _Nonnull content, BOOL success) {

            [self stopWaiting];

            self.isRequest = NO;

            if (success) {
                [UIAlertController showAlertControllerWithViewController:self alertControllerStyle:(UIAlertControllerStyleAlert) title:@"商品发布成功" message:@"商品进入审核阶段,需通过客服审核后才会展示,预计1-3天.如审核失败会告知您原因." cancelButtonTitle:@"确定" destructiveButtonTitle:nil CallBackBlock:^(NSInteger btnIndex) {
                    [self.navigationController popViewControllerAnimated:YES];
                } otherButtonTitles: nil];
            } else {
                Show_message(content[@"msg"]);
            }
        }];
    }
}

- (void)hideKeyBoard {
    [self.serverTF resignFirstResponder];
    [self.amountTF resignFirstResponder];
    [self.productTitleTF resignFirstResponder];
    [self.productDetailTextView resignFirstResponder];
}

void respondsToSystemPicker(NSString *system) {
    controller.systemLabel.text = system;
}

void respondsToTimePicker(NSString *time) {
    controller.time = time;
    controller.timeLabel.text = time;
}

#pragma mark - text filed delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//限制用户名和密码长度
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.productTitleTF) {
        if (range.length == 1 && string.length == 0) {
            return YES;
        } else if (self.productTitleTF.text.length >= 20) {
            self.productTitleTF.text = [textField.text substringToIndex:20];
            return NO;
        }
    }
    return YES;
}

#pragma mark - text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:text_view_holder_string]) {
        textView.text = @"";
    } 
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""] || textView.text.length == 0) {
        textView.text = text_view_holder_string;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView == self.productDetailTextView) {
        if (self.productDetailTextView.text.length >= 200) {
            self.productDetailTextView.text = [textView.text substringToIndex:200];
        }
    }
}

#pragma mark - table view
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    syLog(@"indexpat == %@",indexPath);
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self hideKeyBoard];
    switch (indexPath.row) {
        case 2:
            [self.serverTF becomeFirstResponder];
            break;
        case 3:
            [FFBusinessPikcerContorller PickerWithType:(FFBusinessPickerTypeSystem)];
            break;
        case 4:
            [self.amountTF becomeFirstResponder];
            break;
        case 5:
            [self.productTitleTF becomeFirstResponder];
            break;
        case 6:
            [FFBusinessPikcerContorller PickerWithType:(FFBusinessPickerTypeTime)];
            break;
        case 7:
//            [self showProductDetailController];
            break;
        default:
            break;
    }
}

/*
- (void)showProductDetailController {
    [self.navigationController pushViewController:[FFBusinessProductDetailViewController controllerWithContent:self.productDetailLabel.text CompletBlock:^(NSString *detailString) {
        syLog(@"detail string === %@",detailString);
        self.productDetailLabel.text = detailString;
    }] animated:YES];
}
*/




#pragma mark - setter
- (void)setAccount:(NSString *)account {
    _account = account;
    self.sdkAccountLabel.text = account;
}

- (void)setGameName:(NSString *)gameName {
    _gameName = gameName;
    self.gameNameLabel.text = gameName;
}

- (void)setSystemArray:(NSArray *)systemArray {
    _systemArray = systemArray;
    self.systemLabel.text = (systemArray.count > 1) ? ([NSString stringWithFormat:@"%@",systemArray.firstObject].integerValue == 1) ? @"Android" : ([NSString stringWithFormat:@"%@",systemArray.firstObject].integerValue == 2) ? @"iOS" : @"双平台" : @"双平台";
}

- (void)setProductInfo:(NSDictionary *)productInfo {
    _productInfo = productInfo;
}

- (void)setPostType:(BOOL)postType {
    _postType = postType;
    FFBusinessEditGameImage = !postType;
    FFBusinessEditTradeImage = !postType;
}

- (void)setInfoWith:(NSDictionary *)productInfo {
    if (productInfo != nil) {

        self.productID = [NSString stringWithFormat:@"%@",productInfo[@"productID"]];

        self.account = productInfo[@"account"];
        self.gameName = productInfo[@"game_name"];
        self.serverTF.text = [NSString stringWithFormat:@"%@",productInfo[@"server_name"]];
        self.systemLabel.text = ([NSString stringWithFormat:@"%@",productInfo[@"system"]].integerValue == 2) ? @"iOS" : ([NSString stringWithFormat:@"%@",productInfo[@"system"]].integerValue == 1) ? @"Android" : @"双平台";
        self.systemArray = productInfo[@"system_enabled"];
        self.amountTF.text = [NSString stringWithFormat:@"%@",productInfo[@"price"]];
        self.productTitleTF.text = [NSString stringWithFormat:@"%@",productInfo[@"title"]];
        self.productDetailTextView.text = [NSString stringWithFormat:@"%@",productInfo[@"desc"]];

        self.gameCollectionView.imagesName = productInfo[@"imgs"];
        self.gameCollectionView.isEdit = self.isEdit;
        [self.gameCollectionView reloadData];
        self.tradeCollectionView.imagesName = productInfo[@"trade_imgs"];
        self.tradeCollectionView.isEdit = self.isEdit;
        [self.tradeCollectionView reloadData];
    } else {

    }
}

- (void)setIsEdit:(BOOL)isEdit {
    _isEdit = isEdit;
    self.gameCollectionView.isEdit = isEdit;
    self.tradeCollectionView.isEdit = isEdit;
    if (isEdit) {
        self.selectPicButton.hidden = NO;
        self.selectTradeButton.hidden = NO;
    } else {
        self.selectPicButton.hidden = YES;
        self.selectTradeButton.hidden = YES;
    }
}

#pragma mark - getter
- (NSString *)time {
    if (!_time) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"YYYY-MM-dd";
        _time = [formatter stringFromDate:[NSDate dateWithTimeInterval:24 * 60 * 60 sinceDate:[NSDate date]]];
    }
    return _time;
}


#pragma mark - hud
- (void)startWaiting {
    if (self.hudNumber <= 0) {
        self.hud.removeFromSuperViewOnHide = YES;
        [[FFControllerManager sharedManager].rootNavController.view addSubview:self.hud];
        [self.hud showAnimated:YES];
        self.hudNumber = 0;
        [FFWaitingManager startStatubarWaiting];
    }
    self.hudNumber++;
}

- (void)stopWaiting {
    self.hudNumber--;
    if (self.hudNumber <= 0) {
        self.hud.removeFromSuperViewOnHide = YES;
        [self.hud hideAnimated:YES];
        self.hudNumber = 0;
        [FFWaitingManager stopStatubarWating];
    }
}

#pragma mark - getter
- (MBProgressHUD *)hud {
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:[FFControllerManager sharedManager].rootNavController.view];
    }
    return _hud;
}



@end


@interface FFBusinessPikcerContorller ()<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, assign) FFBusinessPikcerType type;
@property (nonatomic, strong) UIPickerView *systemPickView;
@property (nonatomic, strong) UIDatePicker *datePickerView;


@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIButton *cancelButton;


@end

@implementation FFBusinessPikcerContorller


+ (void)PickerWithType:(FFBusinessPikcerType)type {
    FFBusinessPikcerContorller *Pickcontroller = [[self alloc] init];
    Pickcontroller.systemArray = controller.systemArray;
    Pickcontroller.type = type;
    [Pickcontroller.window makeKeyAndVisible];
}

- (void)removeAllPicker {
    [self.cancelButton removeFromSuperview];
    [self.sureButton removeFromSuperview];
    [self.systemPickView removeFromSuperview];
    [self.datePickerView removeFromSuperview];
}

#pragma mark - responds
- (void)respondsToSureButton {
    syLog(@"确认修改");
    [self respondsToCancelWindow];

    switch (self.type) {
        case FFBusinessPickerTypeSystem: {
            NSInteger row = [self.systemPickView selectedRowInComponent:0];
            respondsToSystemPicker(self.systemArray[row]);
        }
            break;
        case FFBusinessPickerTypeTime: {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"YYYY-MM-dd";
            NSString *content = [formatter stringFromDate:self.datePickerView.date];
            respondsToTimePicker(content);
        }
            break;

        default:
            break;
    }
}

- (void)respondsToCancelWindow {
    [self.window resignKeyWindow];
    self.window = nil;
}




#pragma mark - picker view delegate and data source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == self.systemPickView) {
        return 1;
    } else {
        return 0;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.systemArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.systemArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

}


#pragma mark - setter
- (void)setType:(FFBusinessPikcerType)type {
    _type = type;
    [self removeAllPicker];
    switch (type) {
        case FFBusinessPickerTypeSystem: {
            [self.view addSubview:self.cancelButton];
            [self.view addSubview:self.systemPickView];
            [self.view addSubview:self.sureButton];
        }
            break;
        case FFBusinessPickerTypeTime:
            [self.view addSubview:self.cancelButton];
            [self.view addSubview:self.datePickerView];
            [self.view addSubview:self.sureButton];
            break;

        default:
            break;
    }
}

- (void)setSystemArray:(NSArray *)systemArray {
    NSMutableArray *muArray = [NSMutableArray arrayWithCapacity:systemArray.count];
    for (NSString *obj in systemArray) {
        [muArray addObject:self.systemDict[[NSString stringWithFormat:@"%@",obj]]];
    }
    _systemArray = muArray.copy;
}


#pragma mark - getter
- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
        _window.rootViewController = self;
        _window.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    }
    return _window;
}

- (UIPickerView *)systemPickView {
    if (!_systemPickView) {
        _systemPickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.618)];
        _systemPickView.delegate = self;
        _systemPickView.dataSource = self;
        _systemPickView.backgroundColor = [UIColor whiteColor];
        _systemPickView.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 2);
    }
    return _systemPickView;
}

- (UIDatePicker *)datePickerView {
    if (!_datePickerView) {
        _datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH * 0.618)];
        _datePickerView.datePickerMode = UIDatePickerModeDate;
        _datePickerView.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 2);
        _datePickerView.backgroundColor = [UIColor whiteColor];
        _datePickerView.minimumDate = [NSDate dateWithTimeInterval:24 * 60 * 60 sinceDate:[NSDate date]];
        _datePickerView.maximumDate = [NSDate distantFuture];
    }
    return _datePickerView;
}

//- (NSArray *)systemArray {
//    if (!_systemArray) {
//        _systemArray = @[@"iOS",@"Android"];
//    }
//    return _systemArray;
//}

- (NSDictionary *)systemDict {
    if (!_systemDict) {
        _systemDict = @{@"1":@"Android",@"2":@"iOS",@"3":@"双平台"};
    }
    return _systemDict;
}

- (UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _sureButton.bounds = CGRectMake(0, 0, kSCREEN_WIDTH * 0.9, 44);
        _sureButton.center = CGPointMake(kSCREEN_WIDTH / 2, kSCREEN_HEIGHT / 2 + kSCREEN_WIDTH * 0.618 / 2 + 50);
        _sureButton.layer.cornerRadius = 8;
        _sureButton.layer.masksToBounds = YES;
        _sureButton.backgroundColor = NAVGATION_BAR_COLOR;
        [_sureButton setTitle:@"确定" forState:(UIControlStateNormal)];
        [_sureButton addTarget:self action:@selector(respondsToSureButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _sureButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _cancelButton.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT / 2);
        [_cancelButton addTarget:self action:@selector(respondsToCancelWindow) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _cancelButton;
}


@end




/** ============================================================================= */
@interface FFBusinessSelectImageCollectionView ()

@property (nonatomic, strong) ZLPhotoActionSheet *actionSheet;
@property (nonatomic, strong) NSMutableArray *netImageArray;

@end


@implementation FFBusinessSelectImageCollectionView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self registerClass:NSClassFromString(CELL_IDE) forCellWithReuseIdentifier:CELL_IDE];
        [self setCollectionViewLayout:self.layout];
    }
    return self;
}


#pragma mark - data source
/** 不调 代理不走下面的方法 ????? */

//- (NSInteger)numberOfSections {
//    [super numberOfSections];
//    return 1;
//}

//- (NSInteger)numberOfItemsInSection:(NSInteger)section {
//    [super numberOfItemsInSection:section];
//    return _isEdit ? self.imagesName.count : (self.imagesArray.count < 7) ? self.imagesArray.count + 1 :  self.imagesArray.count;
//}
//
//- (UICollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    [super cellForItemAtIndexPath:indexPath];
//    FFPostStatusImageCell *cell = [self dequeueReusableCellWithReuseIdentifier:CELL_IDE forIndexPath:indexPath];
//    if (_isEdit) {
//        cell.type = showImage;
//        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.imagesName[indexPath.row]]]];
//    } else {
//        if (indexPath.row + 1 > self.imagesArray.count) {
//            cell.type = addImage;
//        } else {
//            cell.type = showImage;
//            cell.imageView.image = self.imagesArray[indexPath.row];
//            PHAsset *asset = self.lastSelectAssets[indexPath.row];
//            cell.playImageView.hidden = !(asset.mediaType == PHAssetMediaTypeVideo);
//        }
//    }
//    return cell;
//}

#pragma mark - collectionview dele
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _isEdit ? self.imagesName.count : (self.imagesArray.count < 7) ? self.imagesArray.count + 1 :  self.imagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

        FFPostStatusImageCell *cell = [self dequeueReusableCellWithReuseIdentifier:CELL_IDE forIndexPath:indexPath];
        if (_isEdit) {
            cell.type = showImage;
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.imagesName[indexPath.row]]]];
        } else {
            if (indexPath.row + 1 > self.imagesArray.count) {
                cell.type = addImage;
            } else {
                cell.type = showImage;
                cell.imageView.image = self.imagesArray[indexPath.row];
                PHAsset *asset = self.lastSelectAssets[indexPath.row];
                cell.playImageView.hidden = !(asset.mediaType == PHAssetMediaTypeVideo);
            }
        }
        return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_isEdit) {
        if (_netImageArray.count > 0) {
            [self.actionSheet previewPhotos:_netImageArray index:indexPath.row hideToolBar:YES complete:^(NSArray * _Nonnull photos) {

            }];
        }

    } else {
        FFPostStatusImageCell *cell = (FFPostStatusImageCell *)[self cellForItemAtIndexPath:indexPath];
        if (cell.type == addImage) {
            [self showPhotoLibrary];
        } else {
            [self.actionSheet previewSelectedPhotos:self.lastSelectPhotos assets:self.lastSelectAssets index:indexPath.row isOriginal:self.isOriginal];
        }
    }
}

- (void)showPhotoLibrary {

    self.imagesArray = nil;
    self.lastSelectAssets = nil;
    self.lastSelectPhotos = nil;

    //设置照片最大选择数
    self.actionSheet.configuration.maxSelectCount = 7;
    self.actionSheet.configuration.allowSelectGif = NO;
    [self.actionSheet showPhotoLibrary];
}


#pragma mark - setter
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.layout.itemSize = CGSizeMake((self.bounds.size.width - 12) / 3, (self.bounds.size.width - 12) / 3);
}

- (void)setImagesName:(NSArray *)imagesName {
    _imagesName = imagesName;
    _netImageArray = [NSMutableArray arrayWithCapacity:imagesName.count];
    for (NSString *obj in imagesName) {
        [_netImageArray addObject:GetDictForPreviewPhoto([NSURL URLWithString:obj], ZLPreviewPhotoTypeURLImage)];
    }
}

#pragma mark - getter
- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = CGSizeMake((self.bounds.size.width - 12) / 3, (self.bounds.size.width - 12) / 3);
        _layout.minimumInteritemSpacing = 2;
        _layout.minimumLineSpacing = 2;
        _layout.sectionInset = UIEdgeInsetsMake(3, 3, 3, 3);
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

- (ZLPhotoActionSheet *)actionSheet {
    if (!_actionSheet) {
        _actionSheet = [[ZLPhotoActionSheet alloc] init];

        _actionSheet.sender = [FFControllerManager sharedManager].rootNavController;

        _actionSheet.configuration.sortAscending = 0;
        _actionSheet.configuration.allowSelectImage = YES;
        _actionSheet.configuration.allowSelectGif = YES;
        _actionSheet.configuration.allowSelectVideo = NO;
        _actionSheet.configuration.allowSelectLivePhoto = NO;
        _actionSheet.configuration.allowForceTouch = YES;
        _actionSheet.configuration.allowSlideSelect = NO;
        _actionSheet.configuration.allowMixSelect = NO;
        _actionSheet.configuration.allowDragSelect = NO;

        //设置相册内部显示拍照按钮
        _actionSheet.configuration.allowTakePhotoInLibrary = NO;
        //设置在内部拍照按钮上实时显示相机俘获画面
        _actionSheet.configuration.showCaptureImageOnTakePhotoBtn = YES;
        //设置照片最大预览数
        _actionSheet.configuration.maxPreviewCount = 0;
        //设置照片最大选择数
        _actionSheet.configuration.maxSelectCount = 7;


        //设置允许选择的视频最大时长
        _actionSheet.configuration.maxVideoDuration = 0;
        //设置照片cell弧度
        _actionSheet.configuration.cellCornerRadio = 4;
        //单选模式是否显示选择按钮
        //    actionSheet.configuration.showSelectBtn = YES;
        //是否在选择图片后直接进入编辑界面
        //        actionSheet.configuration.editAfterSelectThumbnailImage = self.editAfterSelectImageSwitch.isOn;
        //是否保存编辑后的图片
        //    actionSheet.configuration.saveNewImageAfterEdit = NO;
        //设置编辑比例
        //    actionSheet.configuration.clipRatios = @[GetClipRatio(7, 1)];
        //是否在已选择照片上显示遮罩层
        //        actionSheet.configuration.showSelectedMask = self.maskSwitch.isOn;
        //颜色，状态栏样式
        //            actionSheet.configuration.selectedMaskColor = [UIColor purpleColor];
        _actionSheet.configuration.navBarColor = NAVGATION_BAR_COLOR;
        //    actionSheet.configuration.navTitleColor = [UIColor blackColor];
        //        _actionSheet.configuration.bottomBtnsNormalTitleColor = [UIColor blueColor];
        //        _actionSheet.configuration.bottomBtnsDisableBgColor = [UIColor whiteColor];
        _actionSheet.configuration.bottomViewBgColor = NAVGATION_BAR_COLOR;
        //    actionSheet.configuration.statusBarStyle = UIStatusBarStyleDefault;
        //是否允许框架解析图片
        _actionSheet.configuration.shouldAnialysisAsset = YES;
        //框架语言
        _actionSheet.configuration.languageType = ZLLanguageChineseSimplified;

        //是否使用系统相机
        _actionSheet.configuration.useSystemCamera = NO;
        _actionSheet.configuration.sessionPreset = ZLCaptureSessionPreset1920x1080;
        //        _actionSheet.configuration.exportVideoType = ZLExportVideoTypeMp4;
        _actionSheet.configuration.allowRecordVideo = NO;

        zl_weakify(self);
        [self.actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
            zl_strongify(weakSelf);
            //            strongSelf.imagesArray = nil;
            strongSelf.isOriginal = nil;
            strongSelf.lastSelectAssets = nil;
            strongSelf.lastSelectPhotos = nil;
            strongSelf.imagesArray = nil;

            strongSelf.imagesArray = images;
            strongSelf.isOriginal = isOriginal;
            strongSelf.lastSelectAssets = assets.mutableCopy;
            strongSelf.lastSelectPhotos = images.mutableCopy;
            strongSelf.isEdit = NO;

            if (self == controller.gameCollectionView) {
                FFBusinessEditGameImage = YES;
            }

            if (self == controller.tradeCollectionView) {
                FFBusinessEditTradeImage = YES;
            }

            [strongSelf reloadData];
        }];

        self.actionSheet.cancleBlock = ^{

        };
    }
    return _actionSheet;
}


@end











