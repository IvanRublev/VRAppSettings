//
//  VRProtocolConformation.h
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 2/21/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import <Foundation/Foundation.h>

/* This functions allows one to prevent "message no implemented" crashes when working with delegates.
 * VRCanPerform allows to make check if method IS implemented by delegate before sending message to it.
 */

FOUNDATION_EXPORT BOOL VRCanPerform(id object, SEL selector, Protocol *protocol);

#define VRPerformSelectorUnderProtocolIfPossible(aObject, aSelector, aProtocol) do { if(VRCanPerform(aObject, aSelector, aProtocol)) [aObject performSelector:aSelector]; } while(0)
