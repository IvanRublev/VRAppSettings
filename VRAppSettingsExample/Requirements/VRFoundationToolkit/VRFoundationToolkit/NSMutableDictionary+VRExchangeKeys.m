//
//  NSMutableDictionary+VRExchangeKeys.m
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 6/23/13.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import "NSMutableDictionary+VRExchangeKeys.h"

@implementation NSMutableDictionary (VRExchangeKeys)
-(void)exchangeKey:(id<NSCopying,NSObject>)aKey withKey:(id<NSCopying,NSObject>)aNewKey
{
    if (![aKey isEqual:aNewKey]) {
        if (self && aKey && aNewKey) {
            id objectToPreserve = [self objectForKey:aKey];
            if (objectToPreserve) {
                [self setObject:objectToPreserve forKey:aNewKey];
                [self removeObjectForKey:aKey];
            }
        }
    }
}

@end
