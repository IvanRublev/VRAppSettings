//
//  NSObject+VRPropertiesProcessing.h
//
//  Created by Ivan Rublev on 6/3/13.
//  Copyright (c) 2013 Ivan Rublev http://ivanrublev.me . All rights reserved.
//

#import <Foundation/Foundation.h>

/* NSObject+VRPropertiesProcessing category.
 *
 * Following methods walk through object instance's properties and run specified routine.
 * Properties that are declared in empty category of class within appropriate .m file are processed also.
 *
 * Processing runs with following restrictions:
 * - No ivars are processed.
 * - Only properties declared DIRECTLY IN CLASS are taken in account, no superclass properties!
 * - Properties with const* prefix will be ignored. For example constMyVar.
 * - in [-enumeratePropertiesUsingBlock:] valuesClass is nil when propertyValue is nil obviously.
 *
 * To check for equality or to copy properties they must conform to NSObject and NSCoding protocols correspondingly.
 * In case of equality check properties classes must realise address independent verion of [-isEqual]
 *
 * Run NSObject_VRPropertiesProcessingTests, to see examples of usage.
 *
 */

@interface NSObject (VRPropertiesProcessing)

- (void)enumeratePropertiesUsingBlock:(void (^)(NSString * propertyName, id propertyValue, __unsafe_unretained Class valuesClass))block;

- (NSString *)descriptionWithProperties;
- (NSString *)descriptionWithPropertiesTypes;

- (BOOL)isEqualByProperties:(id)object; // If object is of different class then returns NO. It's faster then [-hashByProperties]
- (NSUInteger)hashByProperties;

- (id)deepCopyPropertiesToNewInstanceWithZone:(NSZone *)zone;
- (void)deepCopyPropertiesTo:(id)targetObject;

- (NSString *)keyForPropertyName:(NSString *)propertyName;
- (void)encodePropertiesWithCoder:(NSCoder *)aCoder; // For fast implementing of NSCoding protocol in subclass of NSObject.
- (id)initPropertiesWithCoder:(NSCoder *)aDecoder;

@end
