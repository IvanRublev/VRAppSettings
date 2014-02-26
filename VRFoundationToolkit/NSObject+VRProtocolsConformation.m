//
//  NSObject+VRProtocolsConformation.m
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 2/21/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import "NSObject+VRProtocolsConformation.h"

@implementation NSObject (VRProtocolsConformation)

+ (BOOL)instancesCanPerformSelector:(SEL)aSelector underProtocol:(Protocol *)aProtocol
{
    if (aProtocol && [self conformsToProtocol:aProtocol]) {
        if ([self respondsToSelector:aSelector]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)canPerformSelector:(SEL)aSelector underProtocol:(Protocol *)aProtocol
{
    if (self && aProtocol && [self conformsToProtocol:aProtocol]) {
        if ([self respondsToSelector:aSelector]) {
            return YES;
        }
    }
    return NO;
}

@end
