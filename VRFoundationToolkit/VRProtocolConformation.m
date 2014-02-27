//
//  VRProtocolConformation.m
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 2/21/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import "VRProtocolConformation.h"
#import <objc/runtime.h>

/* VRCanPerform - function returns YES if object responds to selector under protocol.
 * We assume that object is a valid pointer of object. If not then behaiviour is unexpected.
 */
FOUNDATION_EXPORT BOOL VRCanPerform(id object, SEL selector, Protocol *protocol)
{
    if (!object || !selector || !protocol ) {
        return NO;
    }
    
    if ([object conformsToProtocol:protocol] &&
        [object respondsToSelector:selector]) {
        return YES;
    }
    return NO;
}

