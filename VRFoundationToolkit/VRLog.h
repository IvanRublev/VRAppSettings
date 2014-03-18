//
//  VRLog.h
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 2/21/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#ifndef VRFoundationToolkit_VRLog_h
#define VRFoundationToolkit_VRLog_h

#import "metamacros.h"
#import "EXTScope.h"

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
#define VRLOG_ERROR_ASSERT_LASTINSTRUCTION(LASTINSTRUCTION, FMT, ...) do { VRLOG_ERROR(FMT,  ##__VA_ARGS__); \
NSAssert(FALSE, FMT,  ##__VA_ARGS__); \
LASTINSTRUCTION; } while(0)
#define VRLOG_ERROR_ASSERT(FMT, ...) VRLOG_ERROR_ASSERT_LASTINSTRUCTION(, FMT,  ##__VA_ARGS__)
#define VRLOG_ERROR_ASSERT_RETURN_VALUE(VALUE, FMT, ...) VRLOG_ERROR_ASSERT_LASTINSTRUCTION(return VALUE, FMT,  ##__VA_ARGS__)
#define VRLOG_ERROR_ASSERT_RETURN(FMT, ...) VRLOG_ERROR_ASSERT_RETURN_VALUE(, FMT,  ##__VA_ARGS__)
#define VRLOG_ERROR_ASSERT_RETURN_NIL(FMT, ...) VRLOG_ERROR_ASSERT_RETURN_VALUE(nil, FMT,  ##__VA_ARGS__)

// Custom assertion with only one argument for checking condition
#define VRASSERT(CONDITION) NSAssert(CONDITION, @#CONDITION@" is false")

// Some Design By Contract goodies
/** VRPRECONDITIONS_LOG_ERROR_ASSERT_RETURN(condition1, condition2, ...) checks if all conditions are met, otherwithe logs, asserts and returns according to macro name.
    Others the same.
 */
#define __VRROUNDBRACKETSARGUMENT(IDX, ARGUMENT) (ARGUMENT)
#define __VRSTRINGIFY_FALSE_ARGUMENT_VIA_PRECOND(IDX, ARGUMENT) !(ARGUMENT) ? @"#"@metamacro_stringify(IDX)@" => ("@metamacro_stringify(ARGUMENT)@")"

#define VRPRECONDITIONS_LOG_ERROR_ASSERT_RETURN_NIL(...) VRPRECONDITIONS_LOG_ERROR_ASSERT_RETURN_VALUE(nil, ##__VA_ARGS__)
#define VRPRECONDITIONS_LOG_ERROR_ASSERT_RETURN(...) VRPRECONDITIONS_LOG_ERROR_ASSERT_RETURN_VALUE(, ##__VA_ARGS__)
#define VRPRECONDITIONS_LOG_ERROR_ASSERT_RETURN_VALUE(VALUE, ...) VRCONDITIONS_LOG_ERROR_ASSERT_RETURN_VALUE(VALUE, "pre", ##__VA_ARGS__)
#define VRCONDITIONS_LOG_ERROR_ASSERT_RETURN_VALUE(VALUE, LOG_PREFIX, ...) \
do { \
if(!( metamacro_foreach(__VRROUNDBRACKETSARGUMENT, &&, __VA_ARGS__) )) { \
VRLOG_ERROR_ASSERT(@"One of the following "@LOG_PREFIX@"conditions fails: [%@]. Check %@", @#__VA_ARGS__, metamacro_foreach(__VRSTRINGIFY_FALSE_ARGUMENT_VIA_PRECOND, :, __VA_ARGS__) : @""); \
return VALUE; \
} \
} while (0)

#endif
