//
//  FFBusinessProductController.h
//  GameBox
//
//  Created by 燚 on 2018/6/14.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface FFBusinessSelectImageCollectionView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, strong) NSArray *imagesName;

@property (nonatomic, strong) NSMutableArray<UIImage *> *lastSelectPhotos;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssets;

@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, assign) BOOL isOriginal;

- (void)showPhotoLibrary;

@end





@interface FFBusinessProductController : UITableViewController


@property (weak, nonatomic) IBOutlet UILabel *gameNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sdkAccountLabel;
@property (weak, nonatomic) IBOutlet UITextField *serverTF;
@property (weak, nonatomic) IBOutlet UILabel *systemLabel;
@property (weak, nonatomic) IBOutlet UITextField *amountTF;
@property (weak, nonatomic) IBOutlet UITextField *productTitleTF;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *sellButton;

//@property (weak, nonatomic) IBOutlet UITextView *productDetailText;
//@property (weak, nonatomic) IBOutlet UILabel *productDetailLabel;

@property (weak, nonatomic) IBOutlet UITextView *productDetailTextView;

@property (weak, nonatomic) IBOutlet UIButton *selectPicButton;
@property (weak, nonatomic) IBOutlet FFBusinessSelectImageCollectionView *tradeCollectionView;

@property (weak, nonatomic) IBOutlet UIButton *selectTradeButton;
@property (weak, nonatomic) IBOutlet FFBusinessSelectImageCollectionView *gameCollectionView;


@property (nonatomic, strong) NSString *gameName;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *appid;
@property (nonatomic, strong) NSString *productID;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSArray *systemArray;

@property (nonatomic, strong) NSDictionary *productInfo;

@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, assign) BOOL postType;


+ (instancetype)init;
+ (instancetype)initwithGameName:(NSString *)gameName Account:(NSString *)account;




@end
