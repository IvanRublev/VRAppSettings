//
//  VRSingleton.h
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 2/23/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#ifndef VRFoundationToolkit_VRSingleton_h
#define VRFoundationToolkit_VRSingleton_h

#define VRRETURN_SINGLETON do { static dispatch_once_t once; \
static id __strong sharedInstance; \
dispatch_once(&once, ^ { sharedInstance = [[[self class] alloc] init]; }); \
return sharedInstance; } while(0)

#endif
