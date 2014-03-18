//
//  VRAppSettings.m
//
//  Created by Ivan Rublev on 1/24/13.
//  Copyright (c) 2013 Ivan Rublev http://ivanrublev.me . All rights reserved.
//

#import "VRAppSettings.h"
#import "NSObject+VRPropertiesProcessing.h"
#import "VRLog.h"

@interface VRAppSettings ()
@end

@implementation VRAppSettings

#pragma mark -
#pragma mark Methods are obligatory for subclass
- (NSString *)userDefaultsKeyPostfix
{
    NSAssert(FALSE, @"[-userDefaultsKeyPostfix] must be overloaded in subclass to distincs settings sets. Must return value.");
    return nil;
}

- (void)resetToDeveloperDefaults
{
    NSAssert(FALSE, @"[-resetToDeveloperDefaults] must be overloaded in subclass to setup all properties to developer defaults there.");
}

- (void)checkAfterInitWithCoder
{
    NSAssert(FALSE, @"[-checkAfterInitWithCoder] must be overloaded in subclass to make range checking of loaded properties.");
}

#pragma mark -
#pragma mark Creating singleton or object
+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static NSMutableDictionary * __strong sharedInstances;
    dispatch_once(&once, ^ { sharedInstances = [[NSMutableDictionary alloc] init]; });
    NSString * className = NSStringFromClass([self class]);
    id theSharedInstance = nil;
    if ([className length] > 0 && sharedInstances) {
        theSharedInstance = sharedInstances[className];
        if (!theSharedInstance) {
            theSharedInstance = [[[self class] alloc] init];
            sharedInstances[className] = theSharedInstance;
        }
    }
    return theSharedInstance;
}

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
            VRLOG_ERROR(@"Can't register defaults. Archiving of self failed!");
            return nil;
        }
    }
    return self;
}

#pragma mark -
#pragma mark Loading or synchronizing values of properties
- (void)resetToUserDefaults
{
    @try {
        NSData * appStateObjData = [[NSUserDefaults standardUserDefaults] objectForKey:[self userDefaultsKey]];
        if ([appStateObjData isKindOfClass:[NSData class]]) {
            id selfsCopy = [NSKeyedUnarchiver unarchiveObjectWithData:appStateObjData];
            [selfsCopy deepCopyPropertiesTo:self];
        } else {
            VRLOG_ERROR(@"Value in user defaults key %@ is not of NSData class. Can't unarchive and reset.", [self userDefaultsKey]);
        }
    }
    @catch (NSException *exception) {
        VRLOG_ERROR(@"Exception %@: %@", exception.name, exception.reason);
        [self resetToDeveloperDefaults]; // our options are coruppted fall back to hardcoded default values
    }
}

- (void)synchronizeToUserDefaults
{
    NSData *appStateObjData = [self archive];
    [[NSUserDefaults standardUserDefaults] setObject:appStateObjData forKey:[self userDefaultsKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -
#pragma mark Synchronizing to system user defaults with developer defaults values
- (void)resetSelfAndUserDefaultsToDeveloperDefaults
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[self userDefaultsKey]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self resetToDeveloperDefaults];
    [self synchronizeToUserDefaults];
}


#pragma mark -
#pragma mark Key of singleton in system user defaults
- (NSString *)userDefaultsKey
{
    NSString * result = @"VRAppSettings";
    NSString * postfix = [self userDefaultsKeyPostfix];
    NSAssert([postfix length], @""); // must be set.
    if ([postfix length]) {
        result = [result stringByAppendingString:postfix];
    }
    return result;
}

#pragma mark -
#pragma mark Describing object
- (NSString *)description
{
    return [self descriptionWithProperties];
}

#pragma mark -
#pragma mark Helpers
- (NSData *)archive
{
    NSData * archive = [NSKeyedArchiver archivedDataWithRootObject:self];
    return archive;
}

#pragma mark -
#pragma mark NSCoding protocol realized via properties processing
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
