
//
//  LiveHeartVC.m
//  TestProject
//
//  Created by jiaHS on 2020/6/15.
//  Copyright © 2020 Jia. All rights reserved.
//

#import "LiveHeartVC.h"
#import "LiveHeartView.h"

@interface LiveHeartVC ()

@end

@implementation LiveHeartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self showHeart];
}

- (void)showHeart {
    LiveHeartView *heart = [[LiveHeartView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.view addSubview:heart];
    CGPoint fountainSource = CGPointMake(self.view.frame.size.width - 80, self.view.bounds.size.height - 30 / 2.0 - 10);
    heart.center = fountainSource;
    [heart liveHeartAnimateInView:self.view];
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
