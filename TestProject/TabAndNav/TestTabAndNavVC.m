//
//  TestTabAndNavVC.m
//  TestProject
//
//  Created by fandeng on 2018/9/26.
//  Copyright © 2018年 Jia. All rights reserved.
//

#import "TestTabAndNavVC.h"

@interface TestTabAndNavVC ()

@end

@implementation TestTabAndNavVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *present = [[UIButton alloc] initWithFrame:CGRectMake(40, 40, 100, 40)];
    [present setTitle:@"present" forState:UIControlStateNormal];
    present.backgroundColor = [UIColor blueColor];
    [present addTarget:self action:@selector(presentedVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:present];
    
    UIButton *dismiss = [[UIButton alloc] initWithFrame:CGRectMake(180, 40, 100, 40)];
    [dismiss setTitle:@"dismiss" forState:UIControlStateNormal];
    dismiss.backgroundColor = [UIColor redColor];
    [dismiss addTarget:self action:@selector(dismissedVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismiss];
    
    [self addLabel];
}


- (void)addLabel{
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 100)];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:18];
    
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:@"你说你最爱丁香花,因为你的名字就是它，多么忧郁的花，多愁善感的人啊！"];
    
    //设置文字颜色以及字体、删除线
    NSDictionary * dict = @{
                            NSForegroundColorAttributeName:[UIColor redColor],
                            NSFontAttributeName:[UIFont systemFontOfSize:13],
                            NSStrikethroughStyleAttributeName:@"1"};
    
    //从下标0开始，长度为18的内容设置多个属性，dict里面写的就是设置的属性
    [str setAttributes:dict range:NSMakeRange(0, 18)];
    
    //设置背景颜色以及下划线
    NSDictionary * dict1 = @{
                             NSBackgroundColorAttributeName:[UIColor yellowColor],
                             NSUnderlineStyleAttributeName:@"1"};
    
    //从下标14开始，长度为6的内容添加多个属性，dict1里面写的就是添加的属性
    [str addAttributes:dict1 range:NSMakeRange(14, 6)];
    
    //从下标21开始，长度为2的内容添加字体属性，设置其字号为22
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22] range:NSMakeRange(21, 2)];
    
    label.attributedText = str;
    [self.view addSubview:label];
}


- (void)presentedVC{
    TestTabAndNavVC *vc1 = [[TestTabAndNavVC alloc] init];
    vc1.tabBarVC = self.tabBarVC;
    [self presentViewController:vc1 animated:YES completion:nil];
}

- (void)dismissedVC{
    UITabBarController *tabVC = self.tabBarVC;
    [tabVC.selectedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
