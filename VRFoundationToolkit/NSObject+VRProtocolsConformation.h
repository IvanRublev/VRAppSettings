//
//  NSObject+VRProtocolsConformation.h
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 2/21/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import <Foundation/Foundation.h>

/* This category of the NSObject allows one to prevent "message no implemented" crashes when working with delegates.
 * It allows to make check if method IS implemented by delegate before sending message to it.
 *
 * The restriction is that instead of usuall @property(nonatomic, assign) id<SomeProtocol> delegate;
 * you must use @property(nonatomic, assign) NSObject<SomeProtocol> * delegate;
 * This disables usage of NSProxy instance as delegate but improves stability.
 */

#define VRPerformSelectorUnderProtocolIfPossible(aObject, aSelector, aProtocol) do { if([aObject canPerformSelector:aSelector underProtocol:aProtocol]) [aObject performSelector:aSelector]; } while(0)

@interface NSObject (VRProtocolsConformation)
+ (BOOL)instancesCanPerformSelector:(SEL)aSelector underProtocol:(Protocol *)aProtocol;
- (BOOL)canPerformSelector:(SEL)aSelector underProtocol:(Protocol *)aProtocol;
@end
