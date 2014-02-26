//
//  MySettings.m
//  IVRAppSettingsExample
//
//  Created by Ivan Rublev on 11/26/13.
//  Copyright (c) 2013 Ivan Rublev http://ivanrublev.me . All rights reserved.
//

#import "VRMySettings.h"

@implementation VRMySettings

- (NSString *)userDefaultsKeyPostfix
{
    return @"VRMySettings";
}

- (void)resetToDeveloperDefaults
{
    self.value = 1;
    self.title = @"Default title";
    self.number = @(2.5);
}

- (void)checkAfterInitWithCoder
{
}

@end
