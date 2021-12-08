//
//  TableNestedTableVC.m
//  TestProject
//
//  Created by jiaHS on 2020/4/14.
//  Copyright © 2020 Jia. All rights reserved.
//

#import "TableNestedTableVC.h"

@interface TableNestedTableVC ()<UITableViewDataSource,UITableViewDelegate>{
    CGFloat _subTableViewHeight;
    CGFloat _mainTableViewCount;
    BOOL _isCeiling;
}
/** 主table */
@property (nonatomic, readwrite, strong) UITableView *mainTableView;
/** 子table */
@property (nonatomic, readwrite, strong) UITableView *subTableView;
@end

@implementation TableNestedTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.mainTableView];
    _subTableViewHeight = SCREEN_HEIGHT - UINavigationBarHeight - 50;
    _mainTableViewCount = 10;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mainTableView.frame = self.view.bounds;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.mainTableView) {
        return _mainTableViewCount;
    }else if (tableView == self.subTableView) {
        return 30;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        if (indexPath.row == (_mainTableViewCount - 1)) {
            return _subTableViewHeight;
        }
        return 50;
    }else if (tableView == self.subTableView) {
        return 60;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (tableView == self.mainTableView) {
        if (indexPath.row == (_mainTableViewCount - 1)) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _subTableViewHeight)];
            self.subTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _subTableViewHeight);
            [cell addSubview:view];
            [view addSubview:self.subTableView];
        }
        cell.backgroundColor = [UIColor orangeColor];
    }else if (tableView == self.subTableView) {
        cell.backgroundColor = [UIColor greenColor];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.mainTableView) {
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        CGFloat maxOffsetY = scrollView.contentSize.height - scrollView.frame.size.height;
        if (_isCeiling) {
            if (contentOffsetY > floor(maxOffsetY)) {
                [scrollView setContentOffset:CGPointMake(0, maxOffsetY) animated:NO];
            }else {
                _isCeiling = NO;
            }
        }else {
            if (contentOffsetY >= floor(maxOffsetY)) {
                _isCeiling = YES;
            }else {
                _isCeiling = NO;
            }
        }
        if (contentOffsetY > 10) {
            self.mainTableView.bounces = NO;
        }else {
            self.mainTableView.bounces = YES;
        }
        
    }else if (scrollView == self.subTableView) {
        if (scrollView.contentOffset.y < 0) {
            _isCeiling = NO;
            [scrollView setContentOffset:CGPointZero animated:NO];
        }else {
            if (!_isCeiling) {
                [scrollView setContentOffset:CGPointZero animated:NO];
            }
        }
    }
}

#pragma mark - SET AND GET
- (UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] init];
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.backgroundColor = [UIColor redColor];
        [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _mainTableView;
}

- (UITableView *)subTableView {
    if (!_subTableView) {
        _subTableView = [[UITableView alloc] init];
        _subTableView.dataSource = self;
        _subTableView.delegate = self;
        _subTableView.backgroundColor = [UIColor blueColor];
        [_subTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        if (@available(iOS 11.0, *)) {
            _subTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _subTableView;
}

@end
