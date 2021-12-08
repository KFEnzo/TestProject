//
//  UIEventViewController.m
//  TestProject
//
//  Created by jiaHS on 2020/7/20.
//  Copyright © 2020 Jia. All rights reserved.
//

#import "UIEventViewController.h"

@interface UIEventViewController ()<UIGestureRecognizerDelegate>

@end

@implementation UIEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    UIGestureEnvironment *a;
    return YES;
}

@end
