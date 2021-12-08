//
//  Employee+CoreDataProperties.m
//  TestProject
//
//  Created by fandeng on 2018/7/3.
//  Copyright © 2018年 Jia. All rights reserved.
//
//

#import "Employee+CoreDataProperties.h"

@implementation Employee (CoreDataProperties)

+ (NSFetchRequest<Employee *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
}

@dynamic name;
@dynamic age;
@dynamic job;
@dynamic salary;
@dynamic department;

@end
