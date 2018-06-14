//
//  FFDrivePostStatusViewController.m
//  FF_185_Game_Box
//
//  Created by 燚 on 2018/1/16.
//  Copyright © 2018年 Yi Shi. All rights reserved.
//

#import "FFDrivePostStatusViewController.h"
#import "ZLPhotoActionSheet.h"
#import <Photos/Photos.h>
#import "FFPostStatusImageCell.h"
#import "FFDriveModel.h"
#import "FFPostStatusModel.h"
#import "FFControllerManager.h"


#define CELL_IDE @"FFPostStatusImageCell"


@interface FFDrivePostStatusViewController ()<UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *remindLabel;

@property (nonatomic, strong) UILabel *remindLabel1;

@property (nonatomic, strong) UIView *imageContentView;

@property (nonatomic, strong) UIButton *hideButton;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) ZLPhotoActionSheet *actionSheet;
@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, strong) UIBarButtonItem *sendButton;

@property (nonatomic, strong) NSMutableArray<UIImage *> *lastSelectPhotos;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssets;


@property (nonatomic, assign) BOOL isOriginal;

@property (nonatomic, assign) BOOL isGif;

@end

@implementation FFDrivePostStatusViewController {
    CGRect textViewFrame;
    CGRect imageContentViewFrame;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navBarBGAlpha = @"1.0";
    [self.navigationController.navigationBar setTintColor:[FFColorManager navigation_bar_black_color]];
    [self.navigationController.navigationBar setBarTintColor:[FFColorManager navigation_bar_white_color]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initUserInterface {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = self.sendButton;
    self.navigationItem.title = @"发布状态";
    [self.view addSubview:self.hideButton];
    [self.view addSubview:self.remindLabel];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.remindLabel1];
    [self.view addSubview:self.collectionView];
}

- (void)initDataSource {
    textViewFrame = CGRectMake(0, kNAVIGATION_HEIGHT, kSCREEN_WIDTH, 120);
    imageContentViewFrame = CGRectMake(0, CGRectGetMaxY(self.remindLabel1.frame) + 8, kSCREEN_WIDTH, kSCREEN_WIDTH / 4 + 10);
}


#pragma mark - responds
- (void)respondsToTap:(UITapGestureRecognizer *)sender {
    [self.textView resignFirstResponder];
}

- (void)respondsToSendButton {
    if (self.textView.text.length == 0 && self.imagesArray.count == 0) {
        [UIAlertController showAlertMessage:@"请输入要发送的状态\n或者选择要发送的图片" dismissTime:0.7 dismissBlock:nil];
    } else {
        syLog(@"发送动态");
        [self.textView resignFirstResponder];
        if (_isGif) {
            [self postImageWith:self.lastSelectAssets];
        } else {
            [self postImageWith:self.imagesArray];
        }
    }
}

#pragma mark - 发布动态
- (void)postImageWith:(NSArray *)array {
    syLog(@"上传照片  : array === %@",array);
    if (self.textView.text.length == 0) {
        [UIAlertController showAlertMessage:@"内容不能为空" dismissTime:0.7 dismissBlock:nil];
        return;
    }
    [[FFPostStatusModel sharedModel] userUploadPortraitWithContent:self.textView.text Image:array];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)respondsToHideButton {
    [self.textView resignFirstResponder];
}

#pragma mark - collection view data source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.imagesArray.count < 4) {
        return self.imagesArray.count + 1;
    } else {
        return self.imagesArray.count;
    }

    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FFPostStatusImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDE forIndexPath:indexPath];

    if (indexPath.row + 1 > self.imagesArray.count) {
        cell.type = addImage;
    } else {
        cell.type = showImage;
        cell.imageView.image = self.imagesArray[indexPath.row];
        PHAsset *asset = self.lastSelectAssets[indexPath.row];
        cell.playImageView.hidden = !(asset.mediaType == PHAssetMediaTypeVideo);
    }
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    FFPostStatusImageCell *cell = (FFPostStatusImageCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.type == addImage) {
        [UIAlertController showAlertControllerWithViewController:self alertControllerStyle:(UIAlertControllerStyleActionSheet) title:nil message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil CallBackBlock:^(NSInteger btnIndex) {
            [self selectPhotoWith:btnIndex];
        } otherButtonTitles:@"相册",@"GIF",nil];
    } else {
        [self.actionSheet previewSelectedPhotos:self.lastSelectPhotos assets:self.lastSelectAssets index:indexPath.row isOriginal:self.isOriginal];
    }
}

- (void)selectPhotoWith:(NSUInteger)index {
    switch (index) {
        case 0:                             break;
        case 1: [self showPhotoLibrary];    break;
        case 2: [self showGifLibrary];      break;
        default:                            break;
    }
}

- (void)showPhotoLibrary {
    if (_isGif != NO) {
        self.imagesArray = nil;
        self.lastSelectAssets = nil;
        self.lastSelectPhotos = nil;
    }
    _isGif = NO;
    //设置照片最大选择数
    self.actionSheet.configuration.maxSelectCount = 4;
    self.actionSheet.configuration.allowSelectGif = NO;
    [self.actionSheet showPhotoLibrary];
}

- (void)showGifLibrary {
    self.actionSheet.configuration.maxSelectCount = 1;
    if (_isGif != YES) {
        self.imagesArray = nil;
        self.lastSelectAssets = nil;
        self.lastSelectPhotos = nil;
    }
    _isGif = YES;
    self.actionSheet.configuration.allowSelectGif = YES;
    [self.actionSheet showGifLibrary];
}


#pragma makr - text view delegate
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        self.remindLabel.hidden = YES;
    } else {
        self.remindLabel.hidden = NO;
    }
}

#pragma mark - getter
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:textViewFrame];
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.delegate = self;
        _textView.backgroundColor = [UIColor clearColor];

    }
    return _textView;
}

- (UILabel *)remindLabel {
    if (!_remindLabel) {
        _remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kNAVIGATION_HEIGHT + 8, 20, 20)];
        _remindLabel.text = @"  发表动态...";
        _remindLabel.font = [UIFont systemFontOfSize:15];
        _remindLabel.textColor = [UIColor lightGrayColor];
        [_remindLabel sizeToFit];
    }
    return _remindLabel;
}

- (UILabel *)remindLabel1 {
    if (!_remindLabel1) {
        _remindLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(textViewFrame), kSCREEN_WIDTH - 20, 30)];
        _remindLabel1.text = @"  普通图片可以发送4张. GIF 图片只能发送1张";
        _remindLabel1.font = [UIFont systemFontOfSize:13];
        _remindLabel1.textColor = [UIColor redColor];
        _remindLabel1.numberOfLines = 0;
        [_remindLabel1 sizeToFit];
    }
    return _remindLabel1;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((kSCREEN_WIDTH - 12) / 4, (kSCREEN_WIDTH - 12) / 4);
        layout.minimumInteritemSpacing = 1.5;
        layout.minimumLineSpacing = 1.5;
        layout.sectionInset = UIEdgeInsetsMake(3, 3, 3, 3);
        _collectionView = [[UICollectionView alloc] initWithFrame:imageContentViewFrame collectionViewLayout:layout];
        [_collectionView registerClass:[FFPostStatusImageCell class] forCellWithReuseIdentifier:CELL_IDE];
        _collectionView.backgroundColor = [UIColor whiteColor];

        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (UIButton *)hideButton {
    if (!_hideButton) {
        _hideButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _hideButton.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT);
        [_hideButton addTarget:self action:@selector(respondsToHideButton) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _hideButton;
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
        _actionSheet.configuration.allowTakePhotoInLibrary = YES;
        //设置在内部拍照按钮上实时显示相机俘获画面
        _actionSheet.configuration.showCaptureImageOnTakePhotoBtn = YES;
        //设置照片最大预览数
        _actionSheet.configuration.maxPreviewCount = 0;
        //设置照片最大选择数
        _actionSheet.configuration.maxSelectCount = 4;


        //设置允许选择的视频最大时长
        _actionSheet.configuration.maxVideoDuration = 1;
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
        _actionSheet.configuration.useSystemCamera = YES;
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
            [strongSelf.collectionView reloadData];

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

- (UIBarButtonItem *)sendButton {
    if (!_sendButton) {
        _sendButton = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:(UIBarButtonItemStyleDone) target:self action:@selector(respondsToSendButton)];
    }
    return _sendButton;
}


@end




















