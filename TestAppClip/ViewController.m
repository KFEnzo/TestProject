//
//  ViewController.m
//  TestAppClip
//
//  Created by jiaHS on 2020/9/3.
//  Copyright © 2020 Jia. All rights reserved.
//

#import "ViewController.h"
#import "VCModel.h"
#import "SectionModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Test App Clip";
    self.view.backgroundColor = [UIColor blueColor];
    
    VCModel *model = [[VCModel alloc] init];
    SectionModel *section = [[SectionModel alloc] init];
    
#if !APPCLIP
    // Code you don't want to use in your app clip.
    [model test];
#else
    // Code your app clip may access.
    [section test];
#endif
    
}


@end
