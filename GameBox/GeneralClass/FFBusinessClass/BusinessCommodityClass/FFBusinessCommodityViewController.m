//
//  FFBusinessCommodityViewController.m
//  GameBox
//
//  Created by 燚 on 2018/6/15.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBusinessCommodityViewController.h"
#import "FFBusinessModel.h"
#import "FFCommodityHeaderView.h"
#import "FFCommodityCell.h"

#import <ZLPhotoActionSheet.h>
#import <ZLDefine.h>
#import <Photos/Photos.h>
#import <ZLPhotoModel.h>
#import <ZLPhotoManager.h>
#import <ZLProgressHUD.h>



#define CELL_IDE @"FFCommodityCell"

@interface FFBusinessCommodityViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) FFCommodityHeaderView *headerView;
@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, strong) UIView *foorView;


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZLPhotoActionSheet *actionSheet;
@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, strong) NSMutableArray<UIImage *> *lastSelectPhotos;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssets;
@property (nonatomic, assign) BOOL isOriginal;

@property (nonatomic, strong) NSMutableArray *imageArr;

@property (nonatomic, assign) BOOL isShowimage;

@end


static FFBusinessCommodityViewController *_controller;
@implementation FFBusinessCommodityViewController

+ (FFBusinessCommodityViewController *)sharedController {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_controller) {
            _controller = [[FFBusinessCommodityViewController alloc] init];
        }
    });
    return _controller;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (_isShowimage) {

    } else {

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initDataSource {

}

- (void)initUserInterface {
    [super initUserInterface];
    [self.leftButton setImage:[FFImageManager General_back_black]];
    self.navigationItem.leftBarButtonItem = self.leftButton;
    self.navigationItem.title = @"商品详情";

}

- (void)refreshData {
    [self startWaiting];
    [FFBusinessModel ProductInfoWithProductID:self.pid Completion:^(NSDictionary * _Nonnull content, BOOL success) {
        [self stopWaiting];
        syLog(@"product info ===  %@",content);
        if (success) {
            [[FFCommodityModel sharedModel] setInfoWithDict:CONTENT_DATA];
            [self setImageArr:[FFCommodityModel sharedModel].imageArray.mutableCopy];
            [self.headerView refreshData];
            [self.tableView reloadData];
            [self.view addSubview:self.tableView];
            [UIView animateWithDuration:0.3 animations:^{
                self.tableView.alpha = 1;
            }];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
            [UIAlertController showAlertMessage:content[@"msg"] dismissTime:0.7 dismissBlock:nil];
        }


    }];
}

#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [FFCommodityModel sharedModel].imageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FFCommodityCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDE forIndexPath:indexPath];
    cell.imageUrl = [FFCommodityModel sharedModel].imageArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [self.actionSheet previewPhotos:self.imageArr index:indexPath.row hideToolBar:YES complete:^(NSArray * _Nonnull photos) {

    }];
}

#pragma makr - responds
- (void)respondsToButButton {
    syLog(@"购买");
}

#pragma mark - setter
- (void)setPid:(NSString *)pid {
    _pid = [NSString stringWithFormat:@"%@",pid];
    syLog(@"pid === %@",pid);
    [self.tableView removeFromSuperview];
    self.tableView = nil;
    [self refreshData];
}

- (void)setImageArr:(NSMutableArray *)imageArr {
    _imageArr = [NSMutableArray arrayWithCapacity:imageArr.count];
    for (NSString *obj in imageArr) {
        [_imageArr addObject:GetDictForPreviewPhoto([NSURL URLWithString:obj], ZLPreviewPhotoTypeURLImage)];
    }
}

#pragma mark - getter
- (FFCommodityHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[FFCommodityHeaderView alloc] init];
    }
    return _headerView;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNAVIGATION_HEIGHT)];
        _tableView.alpha = 0;
        _tableView.estimatedRowHeight = kSCREEN_WIDTH / 9 * 16;
        _tableView.estimatedRowHeight = UITableViewAutomaticDimension;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:CELL_IDE bundle:nil] forCellReuseIdentifier:CELL_IDE];
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.foorView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


- (UIView *)foorView {
    if (!_foorView) {
        _foorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 100)];
        _foorView.backgroundColor = [FFColorManager navigation_bar_white_color];
        [_foorView addSubview:self.buyButton];
    }
    return _foorView;
}

- (UIButton *)buyButton {
    if (!_buyButton) {
        _buyButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _buyButton.frame = CGRectMake(10, 18, kSCREEN_WIDTH - 20, 44);
        _buyButton.backgroundColor = [FFColorManager blue_dark];
        _buyButton.layer.cornerRadius = 22;
        _buyButton.layer.masksToBounds = YES;
        [_buyButton setTitle:@"购买" forState:(UIControlStateNormal)];
        [_buyButton addTarget:self action:@selector(respondsToButButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _buyButton;
}


- (ZLPhotoActionSheet *)actionSheet {
    if (!_actionSheet) {
        _actionSheet = [[ZLPhotoActionSheet alloc] init];

        _actionSheet.sender = self;

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
            strongSelf.imagesArray = nil;
            strongSelf.isOriginal = nil;
            strongSelf.lastSelectAssets = nil;
            strongSelf.lastSelectPhotos = nil;

            strongSelf.imagesArray = images;
            strongSelf.isOriginal = isOriginal;
            strongSelf.lastSelectAssets = assets.mutableCopy;
            strongSelf.lastSelectPhotos = images.mutableCopy;
            [strongSelf.tableView reloadData];

        }];

        self.actionSheet.cancleBlock = ^{
            //        NSLog(@"取消选择图片");
            //            strongSelf.imagesArray = nil;
            //            strongSelf.isOriginal = nil;
            //            strongSelf.lastSelectAssets = nil;
            //            strongSelf.lastSelectPhotos = nil;
            //            [strongSelf.collectionView reloadData];
        };
    }
    return _actionSheet;
}

@end







