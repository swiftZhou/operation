//
//  MYTestTests.m
//  MYTestTests
//
//  Created by 周海 on 16/7/28.
//  Copyright © 2016年 zhouhai. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Psrson.h"
@interface MYTestTests : XCTestCase

@end

@implementation MYTestTests

-(void)testModelFunc_randomLessThanTen{
    Psrson * model = [[Psrson alloc] init];
    NSInteger num = [model randomLessThanTen];
    XCTAssert(num<10,@"num should less than 10");
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
