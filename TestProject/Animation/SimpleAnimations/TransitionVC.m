//
//  TransitionVC.m
//  TestProject
//
//  Created by jiaHS on 2020/6/14.
//  Copyright © 2020 Jia. All rights reserved.
//

#import "TransitionVC.h"

@interface TransitionVC (){
    int _currentIndex;
}
/** 转场View */
@property (nonatomic, readwrite, strong) UIImageView *imageView;
@end

@implementation TransitionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"转场动画";
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = self.view.bounds;
    self.imageView.image = [UIImage imageNamed:@"0.jpeg"];
    _currentIndex = 1;
    self.imageView.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    //添加手势
    UISwipeGestureRecognizer *leftSwipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftSwipe:)];
    leftSwipeGesture.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipeGesture];
    
    UISwipeGestureRecognizer *rightSwipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightSwipe:)];
    rightSwipeGesture.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGesture];
}

#pragma mark 向左滑动浏览下一张图片
-(void)leftSwipe:(UISwipeGestureRecognizer *)gesture{
    [self transitionAnimation:YES];
}

#pragma mark 向右滑动浏览上一张图片
-(void)rightSwipe:(UISwipeGestureRecognizer *)gesture{
    [self transitionAnimation:NO];
}


#pragma mark 转场动画
-(void)transitionAnimation:(BOOL)isNext{
    //1.创建转场动画对象
    CATransition *transition=[[CATransition alloc]init];
    
    //2.设置动画类型,注意对于苹果官方没公开的动画类型只能使用字符串，并没有对应的常量定义
    transition.type = @"cube";
    //设置子类型
    if (isNext) {
        transition.subtype=kCATransitionFromRight;
    }else{
        transition.subtype=kCATransitionFromLeft;
    }
    //设置动画时常
    transition.duration=1.0f;
    
    NSInteger red = rand() % 255;
    NSInteger green = rand() % 255;
    NSInteger blue = rand() % 255;
    
    //3.设置转场后的新视图添加转场动画
    self.imageView.image = [self getImage:isNext];
    [self.imageView.layer addAnimation:transition forKey:@"KCTransitionAnimation"];
}

#pragma mark 取得当前图片
-(UIImage *)getImage:(BOOL)isNext{
    if (isNext) {
        _currentIndex= (_currentIndex+1) % 5;
    }else{
        _currentIndex= (_currentIndex-1 + 5) % 5;
    }
    NSString *imageName=[NSString stringWithFormat:@"%i.jpeg",_currentIndex];
    return [UIImage imageNamed:imageName];
}


@end
