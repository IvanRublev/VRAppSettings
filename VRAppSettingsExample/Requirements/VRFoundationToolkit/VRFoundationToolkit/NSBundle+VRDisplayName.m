//
//  NSBundle+VRDisplayName.m
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 3/3/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import "NSBundle+VRDisplayName.h"

@implementation NSBundle (VRDisplayName)

+ (NSString *)localizedDisplayName
{
    NSString * appName = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
    if (!appName) {
        appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    }
    if (!appName) {
        appName = @"";
    }
    return appName;
}

@end
