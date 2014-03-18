//
//  NSObject+VRPropertiesProcessing.m
//
//  Created by Ivan Rublev on 6/3/13.
//  Copyright (c) 2013 Ivan Rublev http://ivanrublev.me . All rights reserved.
//

#import "NSObject+VRPropertiesProcessing.h"
#import "VRProtocolConformation.h"
#import <objc/runtime.h>

#define VREPLogLevel 0 // 0 - no console log, 1 - errors, 2 - trace

#ifdef DEBUG
#if VREPLogLevel>0
#define VREPLOG_ERROR NSLog
#endif
#if VREPLogLevel>1
#define VREPLOG_TRACE NSLog
#endif
#endif

#ifndef VREPLOG_TRACE
#define VREPLOG_TRACE(FMT, ...)
#endif
#ifndef VREPLOG_ERROR
#define VREPLOG_ERROR(FMT, ...)
#endif

#define kNSObjectVRPropertiesProcessingIgnorePrefix @"const"
@implementation NSObject (VRPropertiesProcessing)

- (void)enumeratePropertiesUsingBlock:(void (^)(NSString * propertyName, id propertyValue, __unsafe_unretained Class valuesClass))block
{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    if (properties == nil || count == 0) {
        VREPLOG_ERROR(@"No properties in object!");
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
                    VREPLOG_ERROR(@"Can't compare property .%@ by value. Deep copies of propertie's value are not equal. You must implement address independet [- isEqual:], for (%@) class or some of it's members.", propertyName, NSStringFromClass(valuesClass));
                }
#endif
            } else {
                VREPLOG_ERROR(@"Value of property .%@ not supporting [-isEqual:]. So instances of class (%@) can't be compared!", propertyName, NSStringFromClass([self class]));
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
        VREPLOG_ERROR(@"Can't deep copy propeties. targetObject class (%@) differs from self's class (%@).", NSStringFromClass([targetObject class]), NSStringFromClass([self class]));
        return;
    }
    [self enumeratePropertiesUsingBlock:^(NSString *propertyName, id propertyValue, __unsafe_unretained Class valuesClass) {
        id propertyValueDeepCopy = deepCopyOfObj(propertyValue);
        if (propertyValue != nil && propertyValueDeepCopy == nil) {
            VREPLOG_ERROR(@"Error occured on copying of .%@ property value.", propertyName);
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
                    VREPLOG_ERROR(@"Exeption on coding property .%@. %@: %@.", propertyName, exception.name, exception.reason);
                }
                VREPLOG_TRACE(@"Encoded [%@]%@: %@", valuesClass, propertyName, propertyValue);
            } else {
#ifdef DEBUG
                VREPLOG_ERROR(@"Property %@ of class %@ is not saved! It or its members doesn't support NSCoding protocol!", propertyName, NSStringFromClass(valuesClass));
#endif
            }
        } else {
            VREPLOG_TRACE(@"Value of .%@ is nil, not encoded.", propertyName);
        }
    }];
}

- (id)initPropertiesWithCoder:(NSCoder *)aDecoder
{
    if (self) {
        [self enumeratePropertiesUsingBlock:^(NSString *propertyName, id propertyValue, __unsafe_unretained Class valuesClass) {
            if (propertyName != nil) {
                if ([aDecoder containsValueForKey:[self keyForPropertyName:propertyName]]) {
                    VREPLOG_TRACE(@"Decoding [%@]%@", valuesClass, propertyName);
                    id value = nil;
                    @try {
                        value = [aDecoder decodeObjectForKey:[self keyForPropertyName:propertyName]];
                    }
                    @catch (NSException *exception) {
                        VREPLOG_ERROR(@"Exeption on decoding property .%@. %@: %@.", propertyName, exception.name, exception.reason);
                        value = nil;
                    }
                    Class propertyClass = [self classOfPropertyNamed:propertyName];
                    if (propertyClass == nil ||
                        [value isKindOfClass:propertyClass] ||
                        ([propertyClass isSubclassOfClass:valuesClass] && class_getSuperclass(valuesClass) != Nil))
                    {
                        [self setValue:value forKey:propertyName];
                    } else {
                        VREPLOG_ERROR(@"Can't set value becuse of classes type mismatch.");
                    }
                } else {
                    VREPLOG_TRACE(@"Property %@ is not restored! No data were saved for it.", propertyName);
                }
            } else {
                VREPLOG_ERROR(@"Can't decode value for nil property name!");
            }
        }];
    }
    return self;
}

- (Class)classOfPropertyNamed:(NSString*)propertyName
{
    if (![propertyName length]) {
        return nil;
    }

    Class propertyClass = nil;
    objc_property_t property = class_getProperty([self class], [propertyName UTF8String]);
    if (property == NULL) {
        return nil;
    }
    
    char *typeEncoding = nil;
    typeEncoding = property_copyAttributeValue(property, "T");
    if (!typeEncoding) {
        return nil;
    }
    switch (typeEncoding[0])
    {
        case '@':
        {
            if (strlen(typeEncoding) >= 3)
            {
                char *className = strndup(typeEncoding + 2, strlen(typeEncoding) - 3);
                __autoreleasing NSString *name = @(className);
                NSRange range = [name rangeOfString:@"<"];
                if (range.location != NSNotFound)
                {
                    name = [name substringToIndex:range.location];
                }
                propertyClass = NSClassFromString(name); // may be nil.
                free(className);
            }
            break;
        }
        case 'c':
        case 'i':
        case 's':
        case 'l':
        case 'q':
        case 'C':
        case 'I':
        case 'S':
        case 'L':
        case 'Q':
        case 'f':
        case 'd':
        case 'B':
        {
            propertyClass = [NSNumber class];
            break;
        }
        case '{':
        {
            propertyClass = [NSValue class];
            break;
        }
    }
    free(typeEncoding);
    
    return propertyClass;
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
        VREPLOG_ERROR(@"Can't make deepCopy of object %@, it not supporting NSCoding protocol.", value);
    }
    return newValue;
}

@end
