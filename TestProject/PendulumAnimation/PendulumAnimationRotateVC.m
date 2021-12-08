//
//  PendulumAnimationRotateVC.m
//  TestProject
//
//  Created by fandeng on 2018/8/22.
//  Copyright © 2018年 Jia. All rights reserved.
//

#import "PendulumAnimationRotateVC.h"
#import <CoreMotion/CoreMotion.h>

@interface PendulumAnimationRotateVC ()
@property(nonatomic, strong) UIView *redView;
@property(nonatomic, assign) CGFloat redViewSuitAngle;
@property(nonatomic, strong) CMMotionManager *motionManager;
@end

@implementation PendulumAnimationRotateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"旋转钟摆动画";
    [self.view addSubview:self.redView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.redView.transform = CGAffineTransformMakeRotation(self.redViewSuitAngle);
    self.redView.layer.anchorPoint = self.redView.bounds.origin;
    CGPoint point = [self.redView convertPoint:self.redView.layer.anchorPoint toView:self.view];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(point.x, point.y, 1, 300)];
    view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:view];
//    self.redView.transform = CGAffineTransformRotate(self.redView.transform, -M_PI_4);
    //    [UIView animateWithDuration:2 delay:1 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    //        self.redView.transform = CGAffineTransformRotate(self.redView.transform, -M_PI_4);
    //    } completion:^(BOOL finished) {
    //
    //    }];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(start:)]];
    [self startGyroMotionMonitor];
}

- (CGFloat)redViewSuitAngle{
    return atan(self.redView.bounds.size.width/self.redView.bounds.size.height);
}

- (void)startGyroMotionMonitor{
    if (self.motionManager.isGyroAvailable) {
        self.motionManager.gyroUpdateInterval = 0.1;
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            CGFloat x = motion.gravity.x;
            CGFloat y = motion.gravity.y;
            CGFloat angle = atan2(x, y);
            NSLog(@"eeeeee%lf",angle / M_PI * 180.0);
            CGFloat suitAngle = angle-M_PI+self.redViewSuitAngle;
            [UIView animateWithDuration:0.2 animations:^{
                self.redView.transform = CGAffineTransformMakeRotation(suitAngle);
            }];
        }];
    }
}


-(CMMotionManager *)motionManager{
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    return _motionManager;
}


- (void)start:(UIButton *)tap{
    CGFloat originAngle = 0;
    self.redView.transform = CGAffineTransformMakeRotation(originAngle);
    CGFloat angle = self.redViewSuitAngle -originAngle;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
//    NSMutableArray *values = [NSMutableArray arrayWithCapacity:7];
//    [values addObject:[NSValue valueWithCGAffineTransform:CGAffineTransformMakeRotation(originAngle)]];
//    [values addObject:[NSValue valueWithCGAffineTransform:CGAffineTransformMakeRotation(originAngle+angle*1.5)]];
//    [values addObject:[NSValue valueWithCGAffineTransform:CGAffineTransformMakeRotation(originAngle+angle*1/4)]];
//    [values addObject:[NSValue valueWithCGAffineTransform:CGAffineTransformMakeRotation(originAngle+angle)]];
//    [values addObject:[NSValue valueWithCGAffineTransform:CGAffineTransformMakeRotation(originAngle+angle*2/4)]];
//    [values addObject:[NSValue valueWithCGAffineTransform:CGAffineTransformMakeRotation(originAngle+angle)]];
//    [values addObject:[NSValue valueWithCGAffineTransform:CGAffineTransformMakeRotation(originAngle+angle*3/4)]];
//    [values addObject:[NSValue valueWithCGAffineTransform:CGAffineTransformMakeRotation(originAngle+angle)]];
//    animation.values = [values copy];
    animation.values = @[@(originAngle),@(originAngle+angle*1.5),@(originAngle+angle*1/4),@(originAngle+angle),@(originAngle+angle*2/4),@(originAngle+angle),@(originAngle+angle*3/4),@(originAngle+angle)];
    animation.duration = 1.78; //1.78
//    @[@(0),@(0.23),@(0.2),@(0.17),@(0.14),@(0.11),@(0.09),@(0.06)]
    animation.keyTimes = @[@(0),@(0.23),@(0.43),@(0.6),@(0.74),@(0.85),@(0.94),@(1.0)];
//    animation.fillMode = kCAFillModeForwards;
    animation.calculationMode = kCAAnimationLinear;
    animation.removedOnCompletion = YES;
    animation.rotationMode = kCAAnimationRotateAuto;
    CAMediaTimingFunction *timeFunc = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    animation.timingFunctions = @[timeFunc,timeFunc,timeFunc,timeFunc,timeFunc,timeFunc,timeFunc];
    [self.redView.layer addAnimation:animation forKey:@"transform.rotation.z"];
    
    
//    __block CGFloat angle = atan(self.redView.bounds.size.width/self.redView.bounds.size.height) -originAngle;
//    __block NSArray *anglesArr = @[@(originAngle+angle*1.5),@(originAngle+angle*1/4),@(originAngle+angle),@(originAngle+angle*2/4),@(originAngle+angle),@(originAngle+angle*3/4),@(originAngle+angle)];
//    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                self.redView.transform =  CGAffineTransformMakeRotation([anglesArr[0] floatValue]);
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:0.36 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                    self.redView.transform = CGAffineTransformMakeRotation([anglesArr[1] floatValue]);
//                } completion:^(BOOL finished) {
//                    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                        self.redView.transform =  CGAffineTransformMakeRotation([anglesArr[2] floatValue]);
//                    } completion:^(BOOL finished) {
//                        [UIView animateWithDuration:0.26 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                            self.redView.transform =  CGAffineTransformMakeRotation([anglesArr[3] floatValue]);
//                        } completion:^(BOOL finished) {
//                            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//                                self.redView.transform =  CGAffineTransformMakeRotation([anglesArr[4] floatValue]);
//                            } completion:^(BOOL finished) {
//                                [UIView animateWithDuration:0.16 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//                                    self.redView.transform =  CGAffineTransformMakeRotation([anglesArr[5] floatValue]);
//                                } completion:^(BOOL finished) {
//                                    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//                                        self.redView.transform =  CGAffineTransformMakeRotation([anglesArr[6] floatValue]);
//                                    } completion:^(BOOL finished) {
//                                    }];
//                                }];
//                            }];
//                        }];
//                    }];
//                }];
//            }];
    
    
//    __block CGFloat angle = M_PI_2;
//    __block  CGFloat time = 0.4;
//    __block CGFloat totalTime = 0;
//    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.redView.transform = CGAffineTransformRotate(self.redView.transform, angle);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:time/2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//            self.redView.transform = CGAffineTransformRotate(self.redView.transform, -(angle/2));
//        } completion:^(BOOL finished) {
//            while (angle > 0.001) {
//                angle/=2;
//                time/=1.1;
//                __block CGFloat angleX = angle;
//                __block CGFloat timeX = time;
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(totalTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self repeatAnimationByAngel:angleX time:timeX];
//                });
//                totalTime += time*2;
//            }
//        }];
//    }];

    
}

- (void)repeatAnimationByAngel:(CGFloat)angle time:(CGFloat)time{
    [UIView animateWithDuration:time/2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.redView.transform = CGAffineTransformRotate(self.redView.transform, -(angle/2));
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:time/2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.redView.transform = CGAffineTransformRotate(self.redView.transform, +(angle/2));
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:time/2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.redView.transform = CGAffineTransformRotate(self.redView.transform, +(angle/2));
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:time/2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.redView.transform = CGAffineTransformRotate(self.redView.transform, -(angle/2));
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }];
}

- (UIView *)redView{
    if (!_redView) {
        _redView = [[UIView alloc] initWithFrame:CGRectMake(120, 200, 25, 22)];
        _redView.backgroundColor = [UIColor redColor];
    }
    return _redView;
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
