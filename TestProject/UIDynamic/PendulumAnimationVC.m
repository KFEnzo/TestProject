//
//  PendulumAnimationVC.m
//  TestProject
//
//  Created by fandeng on 2018/8/15.
//  Copyright © 2018年 Jia. All rights reserved.
//

#import "PendulumAnimationVC.h"


@interface PendulumAnimationVC (){
    UIAttachmentBehavior *attachmentBehavior;
    UIGravityBehavior *gravityBehavior;
    UIDynamicItemBehavior *itemBehavior;
}
@property(nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property(nonatomic, strong) UIImageView *dynamicImageView;
@end

@implementation PendulumAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.dynamicImageView = imageView;
    imageView.backgroundColor = [UIColor redColor];
    imageView.center = CGPointMake(self.view.center.x, self.view.center.y);
    imageView.userInteractionEnabled= YES;
    [self.view addSubview:imageView];
    imageView.transform = CGAffineTransformMakeRotation(M_PI_4);
//    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[imageView]];
//    UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:imageView offsetFromCenter:UIOffsetMake(20, 20) attachedToAnchor:CGPointMake(self.view.center.x, sqrt(30.0*30.0*2))];
//    [self.dynamicAnimator addBehavior:gravityBehavior];
//    [self.dynamicAnimator addBehavior:attachmentBehavior];
    
//    [imageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
}

- (void)tap:(UITapGestureRecognizer *)tapGes{
    CGPoint point = [tapGes locationInView:self.view];
    [self.dynamicAnimator removeBehavior:gravityBehavior];
    [self.dynamicAnimator removeBehavior:attachmentBehavior];
    [self.dynamicAnimator removeBehavior:itemBehavior];
//    [self.dynamicImageView setCenter:point];
    self.dynamicImageView.transform = CGAffineTransformRotate(self.dynamicImageView.transform, M_PI_4/2);
    [self.dynamicImageView  setCenter:CGPointMake(self.view.center.x+10, self.view.center.y-10)];
    gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.dynamicImageView]];
    gravityBehavior.magnitude = 2;
    [self.dynamicAnimator addBehavior:gravityBehavior];
    attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.dynamicImageView offsetFromCenter:UIOffsetMake(0, 0) attachedToAnchor:CGPointMake(self.view.center.x, self.view.center.y-sqrt(30*30*2)/2)];
    [self.dynamicAnimator addBehavior:attachmentBehavior];
    itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.dynamicImageView]];
    itemBehavior.allowsRotation=YES;
    itemBehavior.resistance = 0;
    itemBehavior.angularResistance = 0;
    [self.dynamicAnimator addBehavior:itemBehavior];
}

- (void)pan:(UIPanGestureRecognizer *)panGes{
    CGPoint point = [panGes locationInView:self.view];
//    if (panGes.state == UIGestureRecognizerStateBegan) {
//        CGPoint anchor = CGPointMake(point.x, point.y);
//        attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.dynamicImageView attachedToAnchor:anchor];
//        [self.dynamicAnimator addBehavior:attachmentBehavior];
//
//
//    }else if (panGes.state == UIGestureRecognizerStateChanged){
//        [attachmentBehavior setAnchorPoint:point];
//    }else if (panGes.state == UIGestureRecognizerStateEnded){
//        [self.dynamicAnimator removeBehavior:attachmentBehavior];
//    }
    [self.dynamicImageView setCenter:point];
    attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.dynamicImageView offsetFromCenter:UIOffsetMake(20, 20) attachedToAnchor:CGPointMake(self.view.center.x, sqrt(30.0*30.0*2))];
    [self.dynamicAnimator addBehavior:attachmentBehavior];
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
