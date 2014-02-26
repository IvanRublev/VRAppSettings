//
//  NSCoder+VRKeyName.h
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 2/21/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#ifndef VRFoundationToolkit_NSCoder_VRKeyName_h
#define VRFoundationToolkit_NSCoder_VRKeyName_h

/* Macro used to make key for property coded via NSCoder object
 * Define VRKEYPREFIX to have unique prefix added to every key.
 */

#ifndef VRKEYPREFIX
#define VRKEYPREFIX @"VR"
#endif

#define VRKeyName(name) _1_VRKeyName(VRKEYPREFIX, name)
#define _1_VRKeyName(prefix, name) __VRKeyName(prefix, name)
#define __VRKeyName(prefix, name) @#prefix@#name

#endif
