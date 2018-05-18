//
//  FFBasicSSTableViewCell.m
//  GameBox
//
//  Created by 燚 on 2018/5/16.
//  Copyright © 2018年 Sans. All rights reserved.
//

#import "FFBasicSSTableViewCell.h"
#import "FFColorManager.h"


@interface FFBasicSSTableViewCell () <UIScrollViewDelegate>


@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) BOOL isAnimatining;
@property (nonatomic, strong) UIViewController *lastViewController;

/** child controllers */
@property (nonatomic, strong) NSArray<UIViewController *> *selectChildViewControllers;
@property (nonatomic, strong) NSArray<NSString *> *selectChildVCNames;

@end


static FFBasicSSTableViewCell *cell = nil;
@implementation FFBasicSSTableViewCell

+ (instancetype)cell {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (cell == nil) {
            cell = [[FFBasicSSTableViewCell alloc] initWithFrame:CGRectZero];
        }
    });
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUserInterface];
    }
    return self;
}

- (void)initUserInterface {
    self.backgroundColor = [UIColor whiteColor];

//    _canHorizontalScroll = YES;
    [self.contentView addSubview:self.scrollView];
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
//    syLog(@"cell frame === %@",NSStringFromCGRect(frame));

    self.scrollView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, frame.size.height);
    [self setChildeView];

}

- (void)setChildeView {
    if (self.dataArray.count > 0) {
        int i = 0;
        for (UIViewController *vc in self.dataArray) {
            vc.view.frame = CGRectMake(kSCREEN_WIDTH * i, 0, kSCREEN_WIDTH, self.frame.size.height);
            i++;
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - custom method
- (void)selectViewWithIndex:(NSUInteger)idx {
    [self childControllerAdd:self.selectChildViewControllers[idx]];
    [self.scrollView setContentOffset:CGPointMake(idx * kSCREEN_WIDTH, 0)];
}

#pragma mark - setter
- (void)setDataArray:(NSArray<FFBasicSSTableViewController *> *)dataArray {
    _dataArray = dataArray;
    self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH * dataArray.count, 0);

    self.selectChildViewControllers = dataArray;
    [self setChildeView];
    [self.scrollView addSubview:self.selectChildViewControllers[0].view];
}

- (void)setCanHorizontalScroll:(BOOL)canHorizontalScroll {
    _canHorizontalScroll = canHorizontalScroll;
    self.scrollView.scrollEnabled = _canHorizontalScroll;
}

#pragma mark - scroll view delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.scrollBlock && self.canHorizontalScroll) {
        self.scrollBlock(YES);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.scrollBlock && self.canHorizontalScroll) {
        self.scrollBlock(NO);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat x = scrollView.contentOffset.x;
    CGFloat index = x / kSCREEN_WIDTH;
    NSInteger afterIndex = index * 10000;
    NSInteger i = afterIndex / 10000;
    NSInteger other = afterIndex % 10000;

    if (i < self.selectChildViewControllers.count - 1 && other != 0) {
        [self childControllerAdd:self.selectChildViewControllers[i]];
        [self childControllerAdd:self.selectChildViewControllers[i + 1]];
    } else if (other == 0) {
        if (i > 0) {
            [self childControllerRemove:self.selectChildViewControllers[i - 1]];
            if (i != self.selectChildViewControllers.count - 1) {
                [self childControllerRemove:self.selectChildViewControllers[i + 1]];
            }
        } else {
            [self childControllerAdd:self.selectChildViewControllers[0]];
            [self childControllerRemove:self.selectChildViewControllers[i + 1]];
        }
    }

    if (self.scrolledBlock) {
        self.scrolledBlock(scrollView.contentOffset.x / scrollView.contentSize.width * kSCREEN_WIDTH);
    }
}

- (void)childControllerAdd:(UIViewController *)controller {
    [self.scrollView addSubview:controller.view];
}

- (void)childControllerRemove:(UIViewController *)controller {
    [controller.view removeFromSuperview];
    [controller removeFromParentViewController];
}



#pragma mark - getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];

        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [FFColorManager blue_dark];
    }
    return _scrollView;
}


@end








