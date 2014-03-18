//
//  VREnum.h
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 3/9/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#ifndef VRFoundationToolkit_VREnum_h
#define VRFoundationToolkit_VREnum_h

#import "metamacros.h"

/* VRENUM_TYPEDEF_AND_UTILS(tdeName, intType, const1, const2, ...)
 *
 * Generates enum with specified tdeName for typedef, intType for integer type and provided constants.
 * Generates inline functions
 *    BOOL isValidNAME(intType value) returns YES if specified value matches one of defined enum constants
 *    NSStringFromNAME(intType value) returns string representation of value if it belongs to enum or @"undefined (value)".
 *
 * Constants can be only simple text CONSTA, CONSTB etc. Up to 18. 
 * Arbitrary number assignments to constants is not supported. Preprocessor doesn't support regexps (((
 *
 * TODO: Implement VRENUM_TYPEDEF_STARTVAL_AND_UTILS(tdeName, intType, startValueForConst1, const1, const2, ...)
 *
 *
 * VRENUM_TYPEDEF(tdeName, intType, ...) same macro but without utility functions.
 */

#define __VRENUM_CHECK(IDX, CONTEXT, VALUE) (CONTEXT == VALUE)
#define __VRENUM_RETURN_VALUE_AS_STRING_IF_MATCHES_CONTEXT(IDX, CONTEXT, VALUE) if (CONTEXT == VALUE) return @#VALUE;

#define VRENUM_TYPEDEF(tdeName, intType, ...) \
typedef NS_ENUM(intType, tdeName) {\
metamacro_expand_(__VA_ARGS__) \
}; \

#define VRENUM_TYPEDEF_AND_UTILS(tdeName, intType, ...) \
VRENUM_TYPEDEF(tdeName, intType, __VA_ARGS__) \
NS_INLINE BOOL isValid##tdeName (intType value) { \
return metamacro_foreach_cxt(__VRENUM_CHECK, ||, value, __VA_ARGS__); \
}; \
NS_INLINE NSString * NSStringFrom##tdeName (intType value) { \
metamacro_foreach_cxt(__VRENUM_RETURN_VALUE_AS_STRING_IF_MATCHES_CONTEXT, , value, __VA_ARGS__); \
return [NSString stringWithFormat:@"undefined (%@)", @(value)]; \
}; \

#endif
