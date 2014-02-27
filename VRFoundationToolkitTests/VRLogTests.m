//
//  VRLogTests.m
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 2/27/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VRLog.h"

@interface VRLogTests : XCTestCase

@end

@implementation VRLogTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testVRASSERT
{
    NSNumber * myNilObj = nil;
    @try {
        VRASSERT([myNilObj floatValue]);
    }
    @catch (NSException *exception) {
        NSString * etalon = @"[myNilObj floatValue] == false";
        XCTAssert([exception.description isEqualToString:etalon], @"Exception reason not equals to etalon string! It's: %@", exception);
    }
    @finally {
    }
}

@end
