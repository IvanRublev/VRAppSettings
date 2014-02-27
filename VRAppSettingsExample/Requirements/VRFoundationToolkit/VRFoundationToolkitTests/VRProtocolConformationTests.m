//
//  VRProtocolConformationTests.m
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 2/27/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VRProtocolConformation.h"
#import <objc/runtime.h>

#pragma mark -
#pragma mark Classes for testVRCanPerform
@protocol VRPCMyClassProtocol <NSObject>
- (NSUInteger)justReturnInput:(NSUInteger)input;
@end

@interface VRPCMyDelegateClass : NSObject <VRPCMyClassProtocol>
@end

@implementation VRPCMyDelegateClass
- (NSUInteger)justReturnInput:(NSUInteger)input
{
    return input;
}
@end


#pragma mark -
#pragma mark Tests
@interface VRProtocolConformationTests : XCTestCase

@end

@implementation VRProtocolConformationTests

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

- (void)testVRCanPerform
{
    id<VRPCMyClassProtocol> delegate = [VRPCMyDelegateClass new];
    SEL delegateSelector = @selector(justReturnInput:);
    Protocol * delegateProtocol = @protocol(VRPCMyClassProtocol);

    XCTAssertFalse(VRCanPerform(nil, nil, nil),                             @"Must return NO");
    XCTAssertFalse(VRCanPerform(delegate, nil, nil),                        @"Must return NO");
    XCTAssertFalse(VRCanPerform(nil, delegateSelector, nil),                @"Must return NO");
    XCTAssertFalse(VRCanPerform(nil, nil, delegateProtocol),                @"Must return NO");
    XCTAssertFalse(VRCanPerform(nil, delegateSelector, delegateProtocol),   @"Must return NO");
    XCTAssertFalse(VRCanPerform(delegate, nil, delegateProtocol),           @"Must return NO");
    XCTAssertFalse(VRCanPerform(delegate, delegateSelector, nil),           @"Must return NO");
    
    XCTAssert(VRCanPerform(delegate, delegateSelector, delegateProtocol),   @"Must return YES!");
    if (VRCanPerform(delegate, delegateSelector, delegateProtocol)) {
        XCTAssert([delegate justReturnInput:42] == 42, @"Input must match output.");
    }
    
    XCTAssertFalse(VRCanPerform(delegate, @selector(floatValue), delegateProtocol),  @"Must return NO");
    XCTAssertFalse(VRCanPerform(delegate, delegateSelector, @protocol(NSCopying)),   @"Must return NO");
    XCTAssertFalse(VRCanPerform([NSObject new], delegateSelector, @protocol(NSObject)),  @"Must return NO");
    
    XCTAssertFalse(VRCanPerform(@(3), delegateSelector, @protocol(NSObject)),  @"Must return NO");
    XCTAssert(VRCanPerform(@"hello", @selector(mutableCopyWithZone:), @protocol(NSMutableCopying)),  @"Must return YES");
}

@end
