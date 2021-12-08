//
//  VCModel.h
//  TestProject
//
//  Created by fandeng on 2018/8/15.
//  Copyright © 2018年 Jia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VCModel : NSObject
@property(nonatomic, strong) UIViewController *vc;
@property(nonatomic, copy) NSString *title;

- (void)test;
@end
