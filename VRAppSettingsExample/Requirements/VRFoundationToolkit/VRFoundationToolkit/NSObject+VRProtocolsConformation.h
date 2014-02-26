//
//  NSObject+VRProtocolsConformation.h
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 2/21/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VRPerformSelectorUnderProtocolIfPossible(aObject, aSelector, aProtocol) (if([aObject canPerformSelector:aSelector underProtocol:aProtocol]) [aObject aSelector])

@interface NSObject (VRProtocolsConformation)
+ (BOOL)instancesCanPerformSelector:(SEL)aSelector underProtocol:(Protocol *)aProtocol;
- (BOOL)canPerformSelector:(SEL)aSelector underProtocol:(Protocol *)aProtocol;
@end
