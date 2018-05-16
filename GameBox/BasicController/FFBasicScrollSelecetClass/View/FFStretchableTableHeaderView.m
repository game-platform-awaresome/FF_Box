//
//  StretchableTableHeaderView.m
//  StretchableTableHeaderView
//

#import "FFStretchableTableHeaderView.h"

@interface FFStretchableTableHeaderView() {
    CGRect initialFrame;
    CGFloat defaultViewHeight;
}


@end


@implementation FFStretchableTableHeaderView

- (void)stretchHeaderForTableView:(UITableView*)tableView withView:(UIView*)view {
    _tableView = tableView;
    _view = view;
    
    initialFrame       = _view.frame;
    defaultViewHeight  = initialFrame.size.height;
    
    UIView *emptyTableHeaderView = [[UIView alloc] initWithFrame:initialFrame];
    _tableView.tableHeaderView = emptyTableHeaderView;
    
    [_tableView addSubview:_view];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView{
    CGRect f = _view.frame;
    f.size.width = _tableView.frame.size.width;
    _view.frame = f;
    
    if(scrollView.contentOffset.y < 0) {
        CGFloat offsetY = (scrollView.contentOffset.y + scrollView.contentInset.top) * -1;
        initialFrame.origin.y = offsetY * -1;
        initialFrame.size.height = defaultViewHeight + offsetY;
        _view.frame = initialFrame;
    }
}

- (void)resizeView {
    initialFrame.size.width = _tableView.frame.size.width;
    _view.frame = initialFrame;
}


@end
