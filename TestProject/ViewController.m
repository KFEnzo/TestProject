//
//  ViewController.m
//  TestProject
//
//  Created by fandeng on 2018/7/3.
//  Copyright © 2018年 Jia. All rights reserved.
//

#import "ViewController.h"
#import "PendulumAnimationVC.h"
#import "VCModel.h"
#import "SectionModel.h"
#import "ChooseImageVC.h"
#import "PendulumAnimationRotateVC.h"
#import "TestTabAndNavVC.h"
#import "WKWebViewVC.h"
#import "BlocksViewController.h"
#import "WaterFallsFlowVC.h"
#import "TableNestedTableVC.h"
#import "AnimationTableVC.h"
#import "UIEventViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray <SectionModel *>*sections;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"测试";
    [self.view addSubview:self.tableView];
    self.sections = [NSMutableArray arrayWithCapacity:0];
    
    // 1
    NSArray *sectionTitles = @[@"UIDynamic",@"选择图片",@"动画",@"tabAndNavTest",@"SpeedDial",@"WKWebViewVC",@"Blocks",@"WaterFallsFlow",@"TableNestedTable",@"事件机制"];
    
    for (int i = 0; i < sectionTitles.count; i++) {
        [self insertSectionWithTitle:sectionTitles[i]];
    }
    // 2
    [self insertToSections:0 vcmodel:[self creatVCModelWithVCName:@"PendulumAnimationVC" VCTitle:@"钟摆动画"]];
    [self insertToSections:1 vcmodel:[self creatVCModelWithVCName:@"ChooseImageVC" VCTitle:@"选择图片"]];
    [self insertToSections:2 vcmodel:[self creatVCModelWithVCName:@"PendulumAnimationRotateVC" VCTitle:@"旋转钟摆动画"]];
    [self insertToSections:2 vcmodel:[self creatVCModelWithVCName:@"AnimationTableVC" VCTitle:@"简单动画列表"]];
    [self insertToSections:3 vcmodel:[self tabAndNavTest]];
    [self insertToSections:4 vcmodel:[self creatVCModelWithVCName:@"SpeedDialViewController" VCTitle:@"SpeedDialViewController"]];
    [self insertToSections:5 vcmodel:[self creatVCModelWithVCName:@"WKWebViewVC" VCTitle:@"WKWebViewVC"]];
    [self insertToSections:6 vcmodel:[self creatVCModelWithVCName:@"BlocksViewController" VCTitle:@"Blocks"]];
    [self insertToSections:7 vcmodel:[self creatVCModelWithVCName:@"WaterFallsFlowVC" VCTitle:@"WaterFallsFlow"]];
    [self insertToSections:8 vcmodel:[self creatVCModelWithVCName:@"TableNestedTableVC" VCTitle:@"TableNestedTable"]];
    [self insertToSections:9 vcmodel:[self creatVCModelWithVCName:@"UIEventViewController" VCTitle:@"事件机制"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.frame = self.view.bounds;
}

- (VCModel *)tabAndNavTest{
    VCModel *model = [[VCModel alloc] init];
    model.title = @"tabAndNavTest";
    TestTabAndNavVC *vc1 = [[TestTabAndNavVC alloc] init];
    TestTabAndNavVC *vc2 = [[TestTabAndNavVC alloc] init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    nav1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"vc1" image:nil tag:1];
    nav2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"vc2" image:nil tag:2];
    UITabBarController *tabVC = [[UITabBarController alloc] init];
    tabVC.viewControllers = @[vc1,vc2];
    vc1.tabBarVC = tabVC;
    vc2.tabBarVC = tabVC;
    model.vc = tabVC;
    return model;
}

#pragma mark - Custom Method
- (void)insertToSections:(NSInteger)section vcmodel:(VCModel *)vcmodel{
    SectionModel *model = self.sections[section];
    [model.VCModels addObject:vcmodel];
}

- (void)insertSectionWithTitle:(NSString *)sectionTitle{
    SectionModel *sectionOneModel = [[SectionModel alloc] init];
    sectionOneModel.sectionTitle = sectionTitle;
    sectionOneModel.VCModels = [NSMutableArray arrayWithCapacity:0];
    [self.sections addObject:sectionOneModel];
}
- (VCModel *)creatVCModelWithVCName:(NSString *)VCName VCTitle:(NSString *)VCTitle{
    VCModel *model = [[VCModel alloc] init];
    model.title = VCTitle;
    Class class = NSClassFromString(VCName);
    model.vc = [(UIViewController *)[class alloc] init];
    return model;
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sections[section].VCModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellID"];
    cell.textLabel.text = self.sections[indexPath.section].VCModels[indexPath.row].title;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.sections[section].sectionTitle;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc = self.sections[indexPath.section].VCModels[indexPath.row].vc;
    if ([vc isKindOfClass:[UITabBarController class]]) {
        [self presentViewController:vc animated:YES completion:nil];
    }else
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Get And Set
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCellID"];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
