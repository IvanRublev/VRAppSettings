//
//  MySettings.h
//  IVRAppSettingsExample
//
//  Created by Ivan Rublev on 11/26/13.
//  Copyright (c) 2013 Ivan Rublev http://ivanrublev.me . All rights reserved.
//

#import <VRAppSettings/VRAppSettings.h>

@interface VRMySettings : VRAppSettings
@property (nonatomic, readwrite) BOOL value;
@property (nonatomic, readwrite) NSString * title;
@property (nonatomic, readwrite) NSNumber * number;
@property (nonatomic, readwrite) NSString * constTitle;
@end
