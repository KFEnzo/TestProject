//
//  BlocksViewController.m
//  TestProject
//
//  Created by jiaHS on 2020/3/22.
//  Copyright © 2020 Jia. All rights reserved.
//

#import "BlocksViewController.h"
#import "BlockObject.h"

@interface BlocksViewController ()

@end

@implementation BlocksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [BlockObject blockTest];
    [[[BlockObject alloc] init] blockTest];
}


@end
