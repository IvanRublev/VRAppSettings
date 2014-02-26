//
//  VRPPMyClass.m
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 2/26/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import "VRPPMyClass.h"
#import "NSObject+VRPropertiesProcessing.h"

@interface VRPPMyClass ()
@property (nonatomic, assign) NSUInteger value2;
@end

@implementation VRPPMyClass

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self encodePropertiesWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        self = [self initPropertiesWithCoder:aDecoder];
    }
    return self;
}

@end
