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
        NSString * etalon = @"[myNilObj floatValue] is false";
        XCTAssert([exception.description isEqualToString:etalon], @"Exception reason not equals to etalon string! It's: %@", exception);
    }

}

- (void)testVRPRECONDITIONS_LOG_ERROR_ASSERT_RETURN_NIL
{
    BOOL a = YES;
    NSNumber * b = nil;
    NSNumber * c = @(8);
    __block NSUInteger d = 7;
    NSObject * theresult = nil;

    NSObject* (^testblock)(void) = ^NSObject* (void){
        VRPRECONDITIONS_LOG_ERROR_ASSERT_RETURN_NIL(a, b == nil, c, d > 7);
        return [NSObject new];
    };

    theresult = nil;
    BOOL wasThrown = NO;
    @try {
        theresult = testblock();
    }
    @catch (NSException *exception) {
        NSString * etalon = @"One of the following preconditions fails: [a, b == nil, c, d > 7]. Check #3 => (d > 7)";
        XCTAssert([exception.description isEqualToString:etalon], @"Exception reason not equals to etalon string! It's: %@", exception);
        wasThrown = YES;
    }
    @finally {
        XCTAssert(wasThrown, @"Must throw exception and block must return nil (currently %p).", theresult);
    }

    theresult = nil;
    wasThrown = NO;
    @try {
        d = 9;
        theresult = testblock();
    }
    @catch (NSException *exception) {
        wasThrown = YES;
    }
    @finally {
        XCTAssertFalse(wasThrown, @"Must not throw exception but it has!");
        XCTAssertNotNil(theresult, @"Block must return not nil value.");
    }
}

@end
