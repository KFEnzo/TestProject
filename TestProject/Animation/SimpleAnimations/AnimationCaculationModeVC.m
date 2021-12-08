//
//  AnimationCaculationModeVC.m
//  TestProject
//
//  Created by jiaHS on 2020/6/14.
//  Copyright © 2020 Jia. All rights reserved.
//

#import "AnimationCaculationModeVC.h"

@interface AnimationCaculationModeVC ()<CAAnimationDelegate>

@end

@implementation AnimationCaculationModeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"动画计算模式";
    UIView *view1 = [[UIView alloc] init];
    view1.backgroundColor = [UIColor redColor];
    view1.frame = CGRectMake(0, 10, 50, 50);
    [self.view addSubview:view1];
    [self addAnimation:view1 calculationMode:kCAAnimationLinear];
    
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = [UIColor redColor];
    view2.frame = CGRectMake(0, 70, 50, 50);
    [self.view addSubview:view2];
    [self addAnimation:view2 calculationMode:kCAAnimationDiscrete];
    
    UIView *view3 = [[UIView alloc] init];
    view3.backgroundColor = [UIColor redColor];
    view3.frame = CGRectMake(0, 130, 50, 50);
    [self.view addSubview:view3];
    [self addAnimation:view3 calculationMode:kCAAnimationPaced];
    
    UIView *view4 = [[UIView alloc] init];
    view4.backgroundColor = [UIColor redColor];
    view4.frame = CGRectMake(0, 190, 50, 50);
    [self.view addSubview:view4];
    [self addAnimation:view4 calculationMode:kCAAnimationCubic];
    
    UIView *view5 = [[UIView alloc] init];
    view5.backgroundColor = [UIColor redColor];
    view5.frame = CGRectMake(0, 250, 50, 50);
    [self.view addSubview:view5];
    [self addAnimation:view5 calculationMode:kCAAnimationCubicPaced];
    
}

- (void)addAnimation:(UIView *)view calculationMode:(CAAnimationCalculationMode)calculationMode {
    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    lable1.textColor = [UIColor whiteColor];
    lable1.font = [UIFont systemFontOfSize:16];
    lable1.textAlignment = NSTextAlignmentCenter;
    lable1.numberOfLines = 2;
    [view addSubview:lable1];
    if ([calculationMode isEqualToString:kCAAnimationLinear]) {
        lable1.text = @"线性";
    }else if ([calculationMode isEqualToString:kCAAnimationDiscrete]) {
        lable1.text = @"离散";
    }else if ([calculationMode isEqualToString:kCAAnimationPaced]) {
        lable1.text = @"均匀";
    }else if ([calculationMode isEqualToString:kCAAnimationCubic]) {
        lable1.text = @"平滑";
    }else if ([calculationMode isEqualToString:kCAAnimationCubicPaced]) {
        lable1.text = @"平滑均匀";
    }
    
    CGPoint center1 = view.center;
    center1.x = 150;
    CGPoint center2 = view.center;
    center2.x = 280;
    CGPoint center3 = view.center;
    center3.x = 370;
    keyframeAnimation.values = @[[NSValue valueWithCGPoint:view.center],[NSValue valueWithCGPoint:center1],[NSValue valueWithCGPoint:center2],[NSValue valueWithCGPoint:center3]];
    keyframeAnimation.keyTimes = @[@0,@0.5,@0.75,@1];
//    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(10, 10, 200, 200)];
//    keyframeAnimation.path = path.CGPath;
    keyframeAnimation.duration = 3;
    keyframeAnimation.beginTime = CACurrentMediaTime() + 2;
    keyframeAnimation.removedOnCompletion = NO;
    keyframeAnimation.repeatCount = 100;
    keyframeAnimation.calculationMode = calculationMode;
//    keyframeAnimation.timingFunction = kCAMediaTimingFunctionEaseIn;
    [view.layer addAnimation:keyframeAnimation forKey:@"CAKeyframeAnimation"];
    keyframeAnimation.delegate = self;
    
//    [UIView animateWithDuration:3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        // 设置要修改的动画属性
//        view.center = CGPointMake(300, 300);
//    } completion:^(BOOL finished) {
//        // 动画完成
//    }];
//    // damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
//    // velocity:弹性复位的速度
//    [UIView animateWithDuration:3 delay:0 usingSpringWithDamping:0.1 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        // 设置要修改的动画属性
//    } completion:^(BOOL finished) {
//        // 动画完成
//    }];
    
//    [UIView animateKeyframesWithDuration:5 delay:1 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
//        // 设置关键帧
//        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
//            // 设置要修改的动画属性
//        }];
//        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
//            // 设置要修改的动画属性
//        }];
//    } completion:^(BOOL finished) {
//        // 动画完成
//    }];
//    [UIView transitionWithView:view duration:1 options:UIViewAnimationOptionTransitionCurlUp animations:^{
//        //更新视图内容
//    } completion:^(BOOL finished) {
//        // 动画完成
//    }];
//    [UIView transitionFromView:view1 toView:view2 duration:1 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
//        // 动画完成
//    }];
}

//- (void)animationDidStart:(CAAnimation *)anim {
//}
//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//    [_layer animationForKey:@"KCBasicAnimation_Translation"];//通过前面的设置的key获得动画
//}
    

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
