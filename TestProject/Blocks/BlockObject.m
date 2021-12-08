//
//  BlockObject.m
//  TestProject
//
//  Created by jiaHS on 2020/3/22.
//  Copyright © 2020 Jia. All rights reserved.
//

#import "BlockObject.h"
typedef void (^DefABlock)(void);

DefABlock defABlock = ^{
    NSLog(@"全局block");
};

@interface BlockObject ()
@property (nonatomic, readwrite, copy) void (^aBlock)(void);
@property (nonatomic, readwrite, strong) NSString *name;
@end

@implementation BlockObject

- (void)dealloc {
    NSLog(@"我释放了");
}

+ (void)blockTest {
//    //声明及实现
//    int (^aBlock)(int) = ^int(int num) {
//        return num ++;
//    };
//    aBlock(1);
//    //block实现部分省略了返回值类型和参数列表，声明部分无返回值、无参数时也最好写上viod
//    void (^aBlock)(void) = ^ {
//        printf("a Block");
//    };
//    aBlock();
    
    //Block 的循环引用问题及如何避免
    //Block 会对引用的局部变量进行持有。同样，Block 也会对引用的对象进行持有，从而会导致相互持有，引起循环引用。
    BlockObject *aBlockObject = [[BlockObject alloc] init];
    aBlockObject.name = @"aBlockObject";
    //ARC 下用 __weak 避免循环引用
//    __weak typeof(aBlockObject)weakABlockObject = aBlockObject;
    //MRC 下不能使用 __weak 用 __block避免循环引用
//    __block typeof(aBlockObject)weakABlockObject = aBlockObject;
    aBlockObject.aBlock = ^() {
        //将 aBlockObject 对象转换为强引用，防止block中的对象由于 弱引用 被释放
//        __strong typeof(weakABlockObject)aBlockObject = weakABlockObject;
        NSLog(@"我是%@",aBlockObject.name);
    };
    aBlockObject.aBlock();
    
    //aBlockObject 持有属性 aBlock，而 aBlock 也同时持有成员变量 aBlockObject，两者互相引用，永远无法释放。就造成了循环引用问题。
}

//捕获变量特性
int global_var = 10; // 全局变量
static int static_global_var = 20; // 静态全局变量
- (void)blockTest {
    int local_var = 30; //局部变量(只可使用，不可修改)
    __block int block_local_var = 40; //__block修饰的局部变量（可使用，可修改）
    static int static_var = 50; // 静态局部变量
    NSMutableArray *aMutableArray = [[NSMutableArray alloc] init]; //局部对象变量 数组
    [aMutableArray addObject:@"123"];
    BlockObject *aBlockObject = [[BlockObject alloc] init]; //局部对象变量
    aBlockObject.name = @"";
    void (^aBlock)(void) = ^{
        global_var = 1;
        static_global_var = 2;
//        local_var = 3; //不可修改 Variable is not assignable (missing __block type specifier)
        block_local_var = 4;
        static_var = 5;
        [aMutableArray addObject:@"123"]; //可以使用该数组对象
        //        aMutableArray = nil; //不可修改 Variable is not assignable (missing __block type specifier)
        aBlockObject.name = @"aBlockObject";
        
        NSLog(@"static_var = %d, static_global_var = %d, local_var = %d, block_local_var = %d, global_var = %d, aBlockObjectName = %@ \n",static_var, static_global_var, local_var, block_local_var, static_var, aBlockObject.name);
    };
    aBlock();
    NSLog(@"%@",[defABlock  class]);
}

- (void(^)(void))returnABlockMethod {
    __block NSInteger block_local_var = 1;
    defABlock = ^{
        block_local_var = 2;
    };
    NSLog(@"%@",[defABlock  class]);
    return defABlock;
}

@end
