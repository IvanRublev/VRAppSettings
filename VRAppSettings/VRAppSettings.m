//
//  VRAppSettings.m
//
//  Created by Ivan Rublev on 1/24/13.
//  Copyright (c) 2013 Ivan Rublev http://ivanrublev.me . All rights reserved.
//

#import "VRAppSettings.h"

@interface VRAppSettings ()
- (NSString *)userDefaultsKey;
@end

@implementation VRAppSettings

#pragma mark -
#pragma mark Methods for overloading in subclass
- (NSString *)userDefaultsKeyPostfix
{
    NSAssert(FALSE, @"[-userDefaultsKeyPostfix] must be overloaded to distincs settings sets.");
    return nil;
}

- (void)resetToDeveloperDefaults
{
    NSAssert(FALSE, @"[-resetToDeveloperDefaults] must be overloaded in your subclass of IVRAppSettings class! Setup all properties to developer defaults there.");
}

- (void)checkAfterInitWithCoder
{
    NSAssert(FALSE, @"[-checkAfterInitWithCoder] must be overloaded in your subclass of IVRAppSettings class! Use it to make range checking of loaded properties, or leave it empty.");
}

#pragma mark -
#pragma mark Helpers
- (NSString *)userDefaultsKey
{
    NSString * result = @"VRAppSettings";
    NSString * postfix = [self userDefaultsKeyPostfix];
    NSAssert(postfix, @""); // must be set.
    if (postfix) {
        result = [result stringByAppendingString:postfix];
    }
    return result;
}

- (NSData *)archive
{
    NSData * archive = [NSKeyedArchiver archivedDataWithRootObject:self];
    return archive;
}


#pragma mark -
#pragma mark Object livecycle
- (id)init
{
    self = [self initWithDeveloperDefaults];
    if (self) {
        [self resetToUserDefaults]; // load values from user defaults.
    }
    return self;
}

- (id)initWithDeveloperDefaults
{
    self = [super init];
    if (self) {
        [self resetToDeveloperDefaults];  // initialize app state object with default values.
        NSData *appStateObjData = [self archive];
        if (appStateObjData) {
            NSDictionary *appDefaults = [NSDictionary dictionaryWithObject:appStateObjData forKey:[self userDefaultsKey]];
            [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];  // register defaults in system
        } else {
            KSLOG_ERROR(@"Can't register defaults. Archiving of self failed!");
            return nil;
        }
    }
    return self;
}

- (NSString *)description
{
    return [self descriptionWithProperties];
}

#pragma mark -
#pragma mark Public actions
- (void)resetToUserDefaults
{
    @try {
        NSData * appStateObjData = [[NSUserDefaults standardUserDefaults] objectForKey:[self userDefaultsKey]];
        if ([appStateObjData isKindOfClass:[NSData class]]) {
            id selfsCopy = [NSKeyedUnarchiver unarchiveObjectWithData:appStateObjData];
            [selfsCopy deepCopyPropertiesTo:self];
        } else {
            KSLOG_ERROR(@"Value in user defaults key %@ is not of NSData class. Can't unarchive and reset.", [self userDefaultsKey]);
        }
    }
    @catch (NSException *exception) {
        KSLOG_ERROR(@"Exception %@: %@", exception.name, exception.reason);
        [self resetToDeveloperDefaults]; // our options are coruppted fall back to hardcoded default values
    }
}

- (void)synchronizeToUserDefaults
{
    NSData *appStateObjData = [self archive];
    [[NSUserDefaults standardUserDefaults] setObject:appStateObjData forKey:[self userDefaultsKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// Erases user defaults and set them from init
- (void)resetSelfAndUserDefaultsToDeveloperDefaults
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self userDefaultsKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self resetToDeveloperDefaults];
    [self synchronizeToUserDefaults];
}

+ (IVRAppSettingsClassName)sharedInstance
{
#ifdef IVRAppSettingsNoInstancetype
    NSAssert(FALSE, @"'instancetype' is not supported. So [+sharedInstance] must be overloaded in child class with return type of that class name.");
    return nil;
    //  Use singleton approach:
    //  static dispatch_once_t once;
    //  static id __strong sharedInstance;
    //  dispatch_once(&once, ^ { sharedInstance = [[[self class] alloc] init]; });
    //  return sharedInstance;
#else
    RETURN_SINGLETON;
#endif
}

#pragma mark -
#pragma mark NSCoding protocol

- (NSString *)keyForPropertyName:(NSString *)propertyName
{
    return [NSString stringWithFormat:@"%@.%@", [self userDefaultsKey], propertyName];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self initWithDeveloperDefaults];
    if (self) {
        self = [self initPropertiesWithCoder:aDecoder];
        [self checkAfterInitWithCoder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self encodePropertiesWithCoder:aCoder];
}

@end
