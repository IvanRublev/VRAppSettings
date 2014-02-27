//
//  NSObject+VRPropertiesProcessing.m
//
//  Created by Ivan Rublev on 6/3/13.
//  Copyright (c) 2013 Ivan Rublev http://ivanrublev.me . All rights reserved.
//

#import "NSObject+VRPropertiesProcessing.h"
#import "VRLog.h"
#import "VRProtocolConformation.h"
#import <objc/runtime.h>

#define kNSObjectVRPropertiesProcessingIgnorePrefix @"const"
@implementation NSObject (VRPropertiesProcessing)

- (void)enumeratePropertiesUsingBlock:(void (^)(NSString * propertyName, id propertyValue, __unsafe_unretained Class valuesClass))block
{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    if (properties == nil || count == 0) {
        VRLOG_DEBUG(@"No properties in object!");
        return;
    }
    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        if ([name hasPrefix:kNSObjectVRPropertiesProcessingIgnorePrefix]) {
            continue;
        }
        id propertyObject = [self valueForKey:name];
        block(name, propertyObject, [propertyObject class]);
    }
    free(properties);
    return;
}

- (NSString *)descriptionWithPropertiesTypes
{
    NSMutableArray * propertiesDescriptions = [NSMutableArray array];
    [self enumeratePropertiesUsingBlock:^(NSString *propertyName, id propertyValue, __unsafe_unretained Class valuesClass) {
        [propertiesDescriptions addObject:[NSString stringWithFormat:@".%@:%@", propertyName, NSStringFromClass(valuesClass)]];
    }];
    NSString * myDesc = [NSString stringWithFormat:@"<%@:%p %@>",
                         NSStringFromClass([self class]),
                         self,
                         [propertiesDescriptions componentsJoinedByString:@" "]];
    return myDesc;
}

- (NSString *)descriptionWithProperties
{
    NSMutableArray * propertiesDescriptions = [NSMutableArray array];
    [self enumeratePropertiesUsingBlock:^(NSString *propertyName, id propertyValue, __unsafe_unretained Class valuesClass) {
        [propertiesDescriptions addObject:[NSString stringWithFormat:@".%@=%@", propertyName, propertyValue]];
    }];
    NSString * myDesc = [NSString stringWithFormat:@"<%@:%p %@>",
                         NSStringFromClass([self class]),
                         self,
                         [propertiesDescriptions componentsJoinedByString:@" "]];
    return myDesc;
}

- (BOOL)isEqualByProperties:(id)object
{
    __block BOOL equal = YES;
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    [self enumeratePropertiesUsingBlock:^(NSString *propertyName, id propertyValue, __unsafe_unretained Class valuesClass) {
        if (propertyValue == nil) {
            equal = ([object valueForKey:propertyName] == nil);
        } else {
            BOOL propertyValueSupportsCompare = VRCanPerform(propertyValue, @selector(isEqual:), @protocol(NSObject));
            if (propertyValueSupportsCompare) {
#ifdef DEBUG
                // Check if [-isEqual] compares values by address.
                id propertyValueDeepCopy = deepCopyOfObj(propertyValue);
                id propertyValueDeepCopy2 = deepCopyOfObj(propertyValue);
                if ([propertyValueDeepCopy isEqual:propertyValueDeepCopy2]) {
#endif
                    if (![propertyValue isEqual:[object valueForKey:propertyName]]) {
                        equal = NO;
                        return;
                    }
#ifdef DEBUG
                } else {
                    VRLOG_DEBUG(@"Can't compare property .%@ by value. Deep copies of propertie's value are not equal. You must implement address independet [- isEqual:], for (%@) class or some of it's members.", propertyName, NSStringFromClass(valuesClass));
                }
#endif
            } else {
                VRLOG_ERROR(@"Value of property .%@ not supporting [-isEqual:]. So instances of class (%@) can't be compared!", propertyName, NSStringFromClass([self class]));
                equal = NO;
            }
        }
    }];
    return equal;
}

- (NSUInteger)hashByProperties
{
    // As suggested by Mike Ash in http://www.mikeash.com/pyblog/friday-qa-2010-06-18-implementing-equality-and-hashing.html
#define NSUINT_BIT (CHAR_BIT * sizeof(NSUInteger))
#define NSUINTROTATE(val, howmuch) ((((NSUInteger)val) << howmuch) | (((NSUInteger)val) >> (NSUINT_BIT - howmuch)))
    __block NSUInteger hash = 0;
    [self enumeratePropertiesUsingBlock:^(NSString *propertyName, id propertyValue, __unsafe_unretained Class valuesClass) {
        hash = NSUINTROTATE(hash, NSUINT_BIT / 2) ^ [propertyValue hash];
    }];
    return hash;
}

- (id)deepCopyPropertiesToNewInstanceWithZone:(NSZone *)zone
{
    id selfCopy = [[[self class] allocWithZone:zone] init];
    [self enumeratePropertiesUsingBlock:^(NSString *propertyName, id propertyValue, __unsafe_unretained Class valuesClass) {
        [selfCopy setValue:propertyValue forKey:propertyName];
    }];
    return selfCopy;
}

- (void)deepCopyPropertiesTo:(id)targetObject
{
    if (![targetObject isMemberOfClass:[self class]]) {
        VRLOG_ERROR(@"Can't deep copy propeties. targetObject class (%@) differs from self's class (%@).", NSStringFromClass([targetObject class]), NSStringFromClass([self class]));
        return;
    }
    [self enumeratePropertiesUsingBlock:^(NSString *propertyName, id propertyValue, __unsafe_unretained Class valuesClass) {
        id propertyValueDeepCopy = deepCopyOfObj(propertyValue);
        if (propertyValue != nil && propertyValueDeepCopy == nil) {
            VRLOG_ERROR(@"Error occured on copying of .%@ property value.", propertyName);
        } else {
            [targetObject setValue:propertyValueDeepCopy forKey:propertyName];
        }
    }];
}

- (NSString *)keyForPropertyName:(NSString *)propertyName
{
    return [NSString stringWithFormat:@"prop.%@", propertyName];
}

- (void)encodePropertiesWithCoder:(NSCoder *)aCoder
{
    [self enumeratePropertiesUsingBlock:^(NSString *propertyName, id propertyValue, __unsafe_unretained Class valuesClass) {
        if (propertyValue != nil) {
            __block BOOL propertySupportsNSCoding = YES;
            if ([valuesClass isSubclassOfClass:[NSArray class]]) {
                [((NSArray *)propertyValue) enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if (!VRCanPerform(obj, @selector(encodeWithCoder:), @protocol(NSCoding))) {
                        propertySupportsNSCoding = NO;
                        *stop = YES;
                    }
                }];
            } else if ([valuesClass isSubclassOfClass:[NSDictionary class]]) {
                [((NSDictionary *)propertyValue) enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if (!VRCanPerform(key, @selector(encodeWithCoder:), @protocol(NSCoding)) ||
                        !VRCanPerform(obj, @selector(encodeWithCoder:), @protocol(NSCoding))) {
                        propertySupportsNSCoding = NO;
                        *stop = YES;
                    }
                }];
            } else if ([valuesClass isSubclassOfClass:[NSSet class]]) {
                [((NSSet *)propertyValue) enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                    if (!VRCanPerform(obj, @selector(encodeWithCoder:), @protocol(NSCoding))) {
                        propertySupportsNSCoding = NO;
                        *stop = YES;
                    }
                }];
            } else {
                propertySupportsNSCoding = [propertyValue conformsToProtocol:@protocol(NSCoding)];
            }
            if (propertySupportsNSCoding) {
                @try {
                    [aCoder encodeObject:propertyValue forKey:[self keyForPropertyName:propertyName]];
                }
                @catch (NSException *exception) {
                    VRLOG_ERROR(@"Exeption on coding property .%@. %@: %@.", propertyName, exception.name, exception.reason);
                }
                VRLOG_TRACE(@"Encoded [%@]%@: %@", valuesClass, propertyName, propertyValue);
            } else {
#ifdef DEBUG
                VRLOG_ERROR(@"Property %@ of class %@ is not saved! It or its members doesn't support NSCoding protocol!", propertyName, NSStringFromClass(valuesClass));
#endif
            }
        } else {
            VRLOG_TRACE(@"Value of .%@ is nil, not encoded.", propertyName);
        }
    }];
}

- (id)initPropertiesWithCoder:(NSCoder *)aDecoder
{
    if (self) {
        [self enumeratePropertiesUsingBlock:^(NSString *propertyName, id propertyValue, __unsafe_unretained Class valuesClass) {
            if (propertyName != nil) {
                if ([aDecoder containsValueForKey:[self keyForPropertyName:propertyName]]) {
                    VRLOG_TRACE(@"Decoding [%@]%@", valuesClass, propertyName);
                    id value = nil;
                    @try {
                        value = [aDecoder decodeObjectForKey:[self keyForPropertyName:propertyName]];
                    }
                    @catch (NSException *exception) {
                        VRLOG_ERROR(@"Exeption on decoding property .%@. %@: %@.", propertyName, exception.name, exception.reason);
                    }
                    [self setValue:value forKey:propertyName];
                } else {
                    VRLOG_TRACE(@"Property %@ is not restored! No data were saved for it.", propertyName);
                }
            } else {
                VRLOG_ERROR(@"Can't decode value for nil property name!");
            }
        }];
    }
    return self;
}

#pragma mark -
#pragma mark Helpers
FOUNDATION_STATIC_INLINE id deepCopyOfObj(id value)
{
    if (!value) {
        return nil;
    }
    id newValue = nil;
    if (VRCanPerform(value, @selector(encodeWithCoder:), @protocol(NSCoding)) &&
        VRCanPerform(value, @selector(initWithCoder:), @protocol(NSCoding))) {
        newValue = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:value]];
    } else {
        VRLOG_ERROR(@"Can't make deepCopy of object %@, it not supporting NSCoding protocol.", value);
    }
    return newValue;
}

@end
