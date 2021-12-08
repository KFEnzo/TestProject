//
//  CoreDataTest.m
//  TestProject
//
//  Created by fandeng on 2018/7/3.
//  Copyright © 2018年 Jia. All rights reserved.
//

#import "CoreDataTest.h"
#import <CoreData/CoreData.h>
#import "Employee+CoreDataClass.h"



@interface CoreDataTest(){
    NSManagedObjectContext *_managedObjectContext;
    NSPersistentStoreCoordinator *_persistentStoreCoodinator;
}
@end

@implementation CoreDataTest

- (instancetype)init{
    if (self = [super init]) {
        [self configCoreData];
    }
    return self;
}

- (void)configCoreData{
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Company" withExtension:@".momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    _persistentStoreCoodinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    [_persistentStoreCoodinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:nil options:nil error:nil];
    
    _managedObjectContext.persistentStoreCoordinator = _persistentStoreCoodinator;
}


- (BOOL)insertData{
    Employee *employee = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:_managedObjectContext];
    employee.name = @"jia";
    employee.age = 12;
    employee.job = @"ios";
    
    NSError *error = nil;
    if (_managedObjectContext.hasChanges) {
        [_managedObjectContext save:&error];
    }
    
    if (error) {
        NSLog(@"插入失败%@",error);
        return NO;
    }
    
    return YES;
}

- (BOOL)deleteData{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",@"jia"];
    fetchRequest.predicate = predicate;
    
    NSError *error = nil;
    NSArray <Employee *>*employees = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    __weak typeof(_managedObjectContext) managedObjectcontext = _managedObjectContext;
    [employees enumerateObjectsUsingBlock:^(Employee * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [managedObjectcontext deleteObject:obj];
    }];
    
    if (managedObjectcontext.hasChanges) {
        [managedObjectcontext save:nil];
    }
    
    if (error) {
        NSLog(@"删除失败%@",error);
        return NO;
    }
    
    return YES;
}

- (BOOL)modifyData{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",@"jia"];
    fetchRequest.predicate = predicate;
    
    NSError *error = nil;
    NSArray <Employee *>*employees = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [employees enumerateObjectsUsingBlock:^(Employee * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.age = 16;
    }];
    
    if (_managedObjectContext.hasChanges) {
        [_managedObjectContext save:nil];
    }
    
    if (error) {
        NSLog(@"修改失败%@",error);
        return NO;
    }
    return YES;
}

- (BOOL)queryData{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];

    NSError *error = nil;
    NSArray <Employee *>*employees = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [employees enumerateObjectsUsingBlock:^(Employee * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"Employee Name : %@", obj.name);
    }];

    if (error) {
        NSLog(@"查询失败%@",error);
        return NO;
    }
    
    return YES;
}

@end
