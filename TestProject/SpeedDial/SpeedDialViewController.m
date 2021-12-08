//
//  SpeedDialViewController.m
//  TestProject
//
//  Created by fandeng on 2018/10/25.
//  Copyright © 2018年 Jia. All rights reserved.
//

#import "SpeedDialViewController.h"

@interface SpeedDialViewController ()

@end

@implementation SpeedDialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIScrollView *sc = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:sc];
    CGFloat itemWidth = (self.view.frame.size.width-10)/2/2;
    CGFloat itemHeight = itemWidth;
    NSInteger n = 10;
    for (int i = 0; i < n ; i++) {
        NSInteger k = i/4;
        UIButton *bt = [[UIButton alloc] init];
        bt.backgroundColor = [UIColor blueColor];
        [bt setTitle:[NSString stringWithFormat:@"%lld",i] forState:UIControlStateNormal];
        NSInteger space = 10;
//        CGFloat y = i%2*(itemHeight+space);
//        CGFloat x = i/2*(itemWidth+space);
        CGFloat y = i/2*(itemWidth+space)-k*2*(itemHeight+space);
        CGFloat x = i%2*(itemHeight+space)+k*2*(itemWidth+space);
        
        bt.frame = CGRectMake(x, y, itemWidth, itemHeight);
        [sc addSubview:bt];
    }
    
    sc.contentSize = CGSizeMake(n*itemWidth + (n-1)*10, sc.frame.size.height);
//    NSString *b= @"b";
//    NSString *s = [[NSString alloc] initWithString:b];
//    NSInteger t =[s retainCount];
//    NSLog(@"%p",b);
//    NSLog(@"%p",s);
//    NSLog(@"%d",t);
    self.view.backgroundColor = [UIColor redColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *cacelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cacelAction];
    [alertController addAction:sureAction];
    UIView *view = alertController.view.subviews.firstObject;
//    view.backgroundColor = [UIColor blueColor];
    [self printSubview:alertController.view layer:1];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)printSubview:(UIView *)view layer:(NSInteger)layer {
    for (UIView *subview in view.subviews) {
        if (subview.subviews.count) {
            [self printSubview:subview layer:layer + 1];
        }else {
//            if (subview.backgroundColor) {
//                subview.backgroundColor = [UIColor blackColor];
//            }
            if ([NSStringFromClass(subview.class) isEqualToString:@"_UIVisualEffectContentView"]) {
                NSLog(@"%@",subview);
                subview.backgroundColor = [UIColor whiteColor];
            }
            NSLog(@"layer: %ld--%@--%f--%@",layer,subview.backgroundColor,subview.alpha,NSStringFromClass(subview.class));
        }
    }
//    if (view.backgroundColor) {
//        view.backgroundColor = [UIColor blackColor];
//    }
    if ([NSStringFromClass(view.class) isEqualToString:@"_UIVisualEffectContentView"]) {
        view.backgroundColor = [UIColor whiteColor];
        NSLog(@"%@",view);
    }
    NSLog(@"layer: %ld--%@--%f--%@",layer,view.backgroundColor,view.alpha,NSStringFromClass(view.class));
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
