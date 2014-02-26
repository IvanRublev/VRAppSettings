//
//  NSArray+VRCheckMembers.m
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 8/7/13.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import "NSArray+VRCheckMembers.h"

@implementation NSArray (VRCheckMembers)
- (BOOL)allMembersAreKindOfClass:(Class)oneTestClass orClass:(Class)otherTestClass
{
    return [self allMembersAreKindOfClass:oneTestClass orClass:otherTestClass options:0];
}

- (BOOL)allMembersAreKindOfClass:(Class)oneTestClass orClass:(Class)otherTestClass options:(NSEnumerationOptions)options
{
    if (!self) {
        return NO;
    }
    __block BOOL result = YES;
    [self enumerateObjectsWithOptions:options usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:oneTestClass] && ![obj isKindOfClass:otherTestClass]) {
            result = NO;
            *stop = YES;
        }
    }];
    return result;
}

- (BOOL)allMembersAreKindOfClass:(Class)testClass
{
    return [self allMembersAreKindOfClass:testClass options:0];
}

- (BOOL)allMembersAreKindOfClass:(Class)testClass options:(NSEnumerationOptions)options
{
    if (!self) {
        return NO;
    }
    __block BOOL result = YES;
    [self enumerateObjectsWithOptions:options usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:testClass]) {
            result = NO;
            *stop = YES;
        }
    }];
    return result;
}
@end
