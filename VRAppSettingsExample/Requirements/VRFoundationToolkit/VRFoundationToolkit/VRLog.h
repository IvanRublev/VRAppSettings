//
//  VRLog.h
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 2/21/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#ifndef VRFoundationToolkit_VRLog_h
#define VRFoundationToolkit_VRLog_h

#define VRYN(expr) ((expr)? @"YES" : @"NO") // For output bool value as string in console

// Logging macros to use in projects.
// Macros are mapped to KSLogger logging macros if they are defined. Or falls back to NSLog.
#ifdef KSLOG_TRACE
#define VRLOG_TRACE KSLOG_TRACE
#endif
#ifdef KSLOG_DEBUG
#define VRLOG_DEBUG KSLOG_DEBUG
#endif
#ifdef KSLOG_ERROR
#define VRLOG_ERROR KSLOG_ERROR
#endif
#ifdef KSLOG_IFNO
#define VRLOG_INFO KSLOG_IFNO
#endif
#ifdef KSLOG_ALWAYS
#define VRLOG_ALWAYS KSLOG_ALWAYS
#endif

#ifndef VRLOG_TRACE
#define VRLOG_TRACE NSLog
#endif
#ifndef VRLOG_DEBUG
#define VRLOG_DEBUG NSLog
#endif
#ifndef VRLOG_ERROR
#define VRLOG_ERROR NSLog
#endif
#ifndef VRLOG_INFO
#define VRLOG_INFO NSLog
#endif
#ifndef VRLOG_ALWAYS
#define VRLOG_ALWAYS NSLog
#endif

// Macros for log error then assert with same message then return.
#define VRLOG_ERROR_ASSERT_RETURN_VALUE(VALUE, FMT, ...) do { VRLOG_ERROR(FMT,  ##__VA_ARGS__); \
NSAssert(FALSE, FMT,  ##__VA_ARGS__); \
return VALUE; } while(0)

#define VRLOG_ERROR_ASSERT_RETURN(FMT, ...) VRLOG_ERROR_ASSERT_RETURN_VALUE(, FMT,  ##__VA_ARGS__)
#define VRLOG_ERROR_ASSERT_RETURN_NIL(FMT, ...) VRLOG_ERROR_ASSERT_RETURN_VALUE(nil, FMT,  ##__VA_ARGS__)

// and custom assert
#define VRASSERT(CONDITION) NSAssert(CONDITION, @#CONDITION@" == false")

#endif
