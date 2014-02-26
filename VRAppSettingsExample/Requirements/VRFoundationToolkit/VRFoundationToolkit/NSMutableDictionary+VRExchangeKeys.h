//
//  NSMutableDictionary+VRExchangeKeys.h
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 6/23/13.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (VRExchangeKeys)
- (void)exchangeKey:(id<NSCopying, NSObject>)aKey withKey:(id<NSCopying, NSObject>)aNewKey;
@end
