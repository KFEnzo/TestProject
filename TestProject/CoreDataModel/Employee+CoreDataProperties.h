//
//  Employee+CoreDataProperties.h
//  TestProject
//
//  Created by fandeng on 2018/7/3.
//  Copyright © 2018年 Jia. All rights reserved.
//
//

#import "Employee+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Employee (CoreDataProperties)

+ (NSFetchRequest<Employee *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int16_t age;
@property (nullable, nonatomic, copy) NSString *job;
@property (nonatomic) int32_t salary;
@property (nullable, nonatomic, retain) Department *department;

@end

NS_ASSUME_NONNULL_END
