//
//  VRAppSettings.h
//
//  Created by Ivan Rublev on 1/24/13.
//  Copyright (c) 2013 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import <Foundation/Foundation.h>

/* IVRAppSettings singleton class.
 * Base self-serializable class for saving app's settings in system user defaults.
 *
 * This class provides automatic self serialization and synchronization functionality.
 * So you can just subclass this class, declare properties and they will be synchronized with user defaults.
 *
 * To use this class you must subclass it. Add properties, and overload following methods:
 * - (NSString *)userDefaultsKeyPostfix
 * - (void)resetToDeveloperDefaults
 * - (void)checkAfterInitWithCoder
 * + (id)sharedInstance
 *
 * Then you call for sigleton and get object with properties loaded from user defaults.
 * Call to [-(void)synchronizeToUserDefaults] will save current object to user defaults and as consequence it's properties values.
 *
 * Properties with names wich begins from const* will not be saved or loaded.
 */

#if ! __has_feature(objc_instancetype) // for compatability with clang prior to v3.1
    #define IVRAppSettingsNoInstancetype 1
    #define IVRAppSettingsClassName id
#else
    #define IVRAppSettingsClassName instancetype
#endif

@interface VRAppSettings : NSObject

- (NSString *)userDefaultsKeyPostfix;
- (void)resetToDeveloperDefaults;
- (void)checkAfterInitWithCoder;

- (NSString *)userDefaultsKey;
- (id)initWithDeveloperDefaults;
- (NSString *)description;

- (void)resetToUserDefaults;
- (void)synchronizeToUserDefaults;
- (void)resetSelfAndUserDefaultsToDeveloperDefaults;
+ (IVRAppSettingsClassName)sharedInstance;
@end
