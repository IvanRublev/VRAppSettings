//
//  NSArray+VRCheckMembers.h
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 8/7/13.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (VRCheckMembers)
- (BOOL)allMembersAreKindOfClass:(Class)oneTestClass orClass:(Class)otherTestClass;
- (BOOL)allMembersAreKindOfClass:(Class)oneTestClass orClass:(Class)otherTestClass options:(NSEnumerationOptions)options;
- (BOOL)allMembersAreKindOfClass:(Class)testClass;
- (BOOL)allMembersAreKindOfClass:(Class)testClass options:(NSEnumerationOptions)options;
@end
