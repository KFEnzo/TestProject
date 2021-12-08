//
//  AnimationTableVC.m
//  TestProject
//
//  Created by jiaHS on 2020/6/14.
//  Copyright © 2020 Jia. All rights reserved.
//

#import "AnimationTableVC.h"

@interface AnimationTableVC ()<UITableViewDelegate,UITableViewDataSource>
/** 列表 */
@property (nonatomic, readwrite, strong) UITableView *tableView;
/** 标题数组 */
@property (nonatomic, readwrite, strong) NSArray *titles;
/** vc class */
@property (nonatomic, readwrite, strong) NSDictionary *classDict;
@end

@implementation AnimationTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"简单动画列表";
    self.titles = @[@"动画计算模式",@"图片循环转场动画",@"基础动画",@"关键帧动画",@"组动画",@"过渡动画",@"仿射变换",@"综合案例",@"直播点赞",@"烟花",@"雪花"];
    self.classDict = @{
        @"1" : @"AnimationCaculationModeVC",
        @"2" : @"TransitionVC",
        @"3" : @"BaseAnimationController",
        @"4" : @"KeyFrameAnimationController",
        @"5" : @"GroupAnimationController",
        @"6" : @"TransitionAnimationController",
        @"7" : @"AffineTransformController",
        @"8" : @"ComprehensiveCaseController",
        @"9" : @"LiveHeartVC",
        @"10" : @"FireworkVC",
        @"11" : @"SnowVC",
    };
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
//    [UIView animateKeyframesWithDuration:1 delay:1 options:UIViewKeyframeAnimationOptionRepeat animations:^{
//        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.1 animations:^{
//
//        }];
//    } completion:nil];
//
//    [UIView transitionWithView:[UIView new] duration:1 options:UIViewAnimationOptionCurveLinear animations:^{
//
//    } completion:^(BOOL finished) {
//
//    }];
//    [UIView transitionFromView:[UIView new] toView:[UIView new] duration:1 options:UIViewAnimationOptionCurveLinear completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = self.classDict[[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
    Class VCClass = NSClassFromString(className);
    UIViewController *vc = (UIViewController *)[[VCClass alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tableView;
}
@end
