//
//  ViewController.m
//  MYTest
//
//  Created by 周海 on 16/7/28.
//  Copyright © 2016年 zhouhai. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    /*
    dispatch_group_t group =  dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("异步队列", DISPATCH_QUEUE_CONCURRENT);
    
    //任务1
    dispatch_group_async(group, queue, ^{
        for (NSInteger i = 0; i < 3; i++) {
            NSLog(@"group-01 - %@", [NSThread currentThread]);
        }
    });
    
    //任务2
    dispatch_group_async(group, queue, ^{
        for (NSInteger i = 0; i < 8; i++) {
            NSLog(@"group-02 - %@", [NSThread currentThread]);
        }
    });
    
    //任务3
    dispatch_group_async(group, queue, ^{
        for (NSInteger i = 0; i < 20; i++) {
            NSLog(@"group-03 - %@", [NSThread currentThread]);
        }
    });
    
    //任务4
    dispatch_group_async(group, queue, ^{
        for (NSInteger i = 0; i < 11; i++) {
            NSLog(@"group-04 - %@", [NSThread currentThread]);
        }
    });
    
    //完成所有任务后自动通知
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"完成 - %@", [NSThread currentThread]);
    });
     */
    
//    [self operation];
    
//    [self blockOperation];
//    [self addDependecy];
    [self operation2];
}


#pragma makr -添加依赖
- (void)addDependecy{
    //NSOperation 有一个非常实用的功能，那就是添加依赖。比如有 3 个任务：A: 从服务器上下载一张图片，B：给这张图片加个水印，C：把图片返回给服务器。这时就可以用到依赖了
    
    //1.任务一：下载图片
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"下载图片 - %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    }];
    
    //2.任务二：打水印
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"打水印   - %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    }];
    
    //3.任务三：上传图片
    NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"上传图片 - %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    }];
    
    //4.设置依赖
    [operation2 addDependency:operation1];      //任务二依赖任务一
    [operation3 addDependency:operation2];      //任务三依赖任务二
    
    
    //注意：不能添加相互依赖，会死锁，比如 A依赖B，B依赖A。
    //可以使用 removeDependency 来解除依赖关系。
    //可以在不同的队列之间依赖，反正就是这个依赖是添加到任务身上的，和队列没关系。

    
    //5.创建队列并加入任务
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperations:@[operation3, operation2, operation1] waitUntilFinished:NO];
}

- (void)operation{
    //创建任务
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run) object:nil];
    
//    [operation start];//默认在主线程
    
    //队列
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
}


- (void)blockOperation{
    NSBlockOperation *blockOperation1 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i < 100; i++) {
            NSLog(@"blockOperation1- - %@", [NSThread currentThread]);
        }
    }];
    
    NSBlockOperation *blockOperation2 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i < 20; i++) {
            NSLog(@"blockOperation2- - %@", [NSThread currentThread]);
        }
    }];
    
    NSBlockOperation *blockOperation3 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i < 50; i++) {
            NSLog(@"blockOperation3- - %@", [NSThread currentThread]);
        }
    }];
    
    NSBlockOperation *blockOperation4 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i < 60; i++) {
            NSLog(@"blockOperation4- - %@", [NSThread currentThread]);
        }
    }];
    
    NSBlockOperation *blockOperation5 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i < 200; i++) {
            NSLog(@"blockOperation5- - %@", [NSThread currentThread]);
        }
    }];
    
//    [blockOperation start];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    //不用管串行、并行、同步、异步这些名词。NSOperationQueue 有一个参数 maxConcurrentOperationCount 最大并发数，用来设置最多可以让多少个任务同时执行。当你把它设置为 1 的时候，他不就是串行了嘛！
    queue.maxConcurrentOperationCount = 20;
    
    [queue addOperation:blockOperation1];
    [queue addOperation:blockOperation2];
    [queue addOperation:blockOperation3];
    [queue addOperation:blockOperation4];
    [queue addOperation:blockOperation5];
    
    

    
}

#pragma makr - 演示线程同步
- (void)operation2{
    //所谓线程同步就是为了防止多个线程抢夺同一个资源造成的数据安全问题，所采取的一种措施。当然也有很多实现方法，
    
    //创建任务1
    NSInvocationOperation *operation1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run) object:nil];
    
    NSInvocationOperation *operation2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(run) object:nil];
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation1];
    [queue addOperation:operation2];
    
}
- (void)run{
    
    //@synchronized 互斥锁 ：给需要同步的代码块加一个互斥锁，就可以保证每次只有一个线程访问此代码块。
    @synchronized(self) {
        for (NSInteger i = 0; i < 10; i++) {
            NSLog(@"operation- - %@", [NSThread currentThread]);
        }
    }

}
@end
