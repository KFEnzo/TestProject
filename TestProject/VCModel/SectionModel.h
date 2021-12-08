//
//  SectionModel.h
//  TestProject
//
//  Created by fandeng on 2018/8/15.
//  Copyright © 2018年 Jia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VCModel.h"

@interface SectionModel : NSObject
@property(nonatomic, copy) NSString *sectionTitle;
@property(nonatomic, strong) NSMutableArray <VCModel *>*VCModels;

- (void)test;
@end
