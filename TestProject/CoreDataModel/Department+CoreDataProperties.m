//
//  Department+CoreDataProperties.m
//  TestProject
//
//  Created by fandeng on 2018/7/3.
//  Copyright © 2018年 Jia. All rights reserved.
//
//

#import "Department+CoreDataProperties.h"

@implementation Department (CoreDataProperties)

+ (NSFetchRequest<Department *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Department"];
}

@dynamic name;
@dynamic employee;

@end
