//
//  VREnumTests.m
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 3/9/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VREnum.h"

@interface VREnumTests : XCTestCase

@end

@implementation VREnumTests

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

#define MyconstantsIntType int
VRENUM_TYPEDEF_AND_UTILS(MyConstant, MyconstantsIntType, MyOne, MyTwo, MyThree);
//VRENUM_TYPEDEF_STARTVAL_AND_UTILS(AnotherConstant, MyconstantsIntType, 10, AnotherOne, AnotherTwo);

- (void)testVRENUM_isValidX
{
    MyconstantsIntType value;
    for (value = 0; value < 3; value++) {
        XCTAssert(isValidMyConstant(value), @"Fail with value == %d", value);
    }
    XCTAssertFalse(isValidMyConstant(value+1));
}

- (void)testVRENUM_NSStringFromX
{
    MyconstantsIntType badval = 3;
    NSString * etalon = [NSString stringWithFormat:@"undefined (%d)", badval];
    NSString * baddescr = NSStringFromMyConstant(badval);
    XCTAssert([baddescr isEqualToString:etalon], @"Returned string for bad value %d not matches etalon! It's: %@", badval, baddescr);
    
    MyconstantsIntType goodVal = 2;
    NSString * goodetalon = @"MyThree";
    NSString * gooddescr = NSStringFromMyConstant(goodVal);
    XCTAssert([gooddescr isEqualToString:goodetalon], @"Returned string for good value %d not matches etalon! It's: %@", goodVal, gooddescr);
    
}


@end
