//
//  VRAppSettings.h
//
//  Created by Ivan Rublev on 1/24/13.
//  Copyright (c) 2013 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import <Foundation/Foundation.h>

/** This superclass makes easier to handle user's preferences (app's settings). Successor of this class keeps app's settings in properties and stores itself in defaults system. Though settings values will not be accessible through [NSUserDefaults](https://developer.apple.com/library/ios/documentation/cocoa/reference/foundation/Classes/NSUserDefaults_Class) directly but only via setters and getters of `VRAppSettings` successor. This class normally is to be used as singleton.

 To use `VRAppSettings` class do the following. Inherit from it with your own settings class, for example `MySettings`. Describe all your app's settings as properties of `MySettings` class and override compulsory methods.  You'll get something like this:
 
    @interface MySettings : VRAppSettings
 
    @property (nonatomic, readwrite) BOOL dontDimScreen;
    @property (nonatomic, readwrite) float soundLevel;
 
    @end

    @implementation MySettings
 
    - (NSString *)userDefaultsKeyPostfix
    {
        return @"MyAppsSettings";
    }

    - (void)resetToDeveloperDefaults
    {
        // This will be called from -init of the superclass.
        self.dontDimScreen = NO;
        self.soundLevel = 0.7;
    }

    - (void)checkAfterInitWithCoder
    {
        // This will be called from -initWithCoder: of the superclass.
    }
 
    @end
 
 
 This class exports two base methods to work with. They are -synchronizeToUserDefaults and +sharedInstance. 
 
 When the message with -synchronizeToUserDefaults method is sent to the `MySettings` object it will be archived with all it's properties according to NSCoding protocol and saved in user's defaults as a value. 
 
 The +sharedInstance class method will return singleton of `MySettings` class. During initialization of singleton `-resetToDeveloperDefaults` method will be called. Then if the object is saved in user's defaults it will be unarchived and replaces current one. After that `-checkAfterInitWithCoder` method will be called.
 
 ### Properties types
 Properties of successor class must be of primitive type or of object type conforming to NSCoding protocol.
 
 Properties with names which begins from const* will be excluded from save or load processes. In such excluded properties you can store runtime values that are counted on kept properties.
 
 ### Subclassing notes
 Use full power of setters and getters in successor class to make range checks and keep consistency of settings values.
 
 If you need to keep several sets of settings you can make several successors of `VRAppSettings` class and return different strings from `-userDefaultsKeyPostfix` method to separate settings sets.
*/
@interface VRAppSettings : NSObject

/** -----------------------------------------
 *  @name Methods compulsory to subclass
 */
/** Returns the postfix for the key in user's defaults dictionary at which object of concrete subclass will be stored.
*
*  Concrete subclass must overload this method and return nonempty `NSString` key postfix value that is unique among other subclasses. Usually it's the name of the concrete subclass. The key to store settings object in user's defaults dictionary will be obtained by concatenation of common string and returned unique postfix. Full key string may be obtained via -userDefaultsKey.
*
*  @return Nonempty string with postfix for key name that is unique among all subclasses.
*  @see -userDefaultsKey
*/
- (NSString *)userDefaultsKeyPostfix;

/** Resets properties values to defaults hardcoded by developer.
 *
 *  Concrete subclass must overload this method to specify defaults for its properties.
 */
- (void)resetToDeveloperDefaults;

/** Checks values of properties of concrete subclass object after loading from user's defaults.
 *
 *  Concrete subclass must overload this method. This method may be empty if check is not needed.
 */
- (void)checkAfterInitWithCoder;

/** -----------------------------------------
 * @name Creating the singleton or object initialization
 */
/** Returns singleton of concrete subclass loaded from user's defaults with key with postfix returned by -userDefaultsKeyPostfix.
 *
 *  Concrete subclass object will be loaded from user's defaults with key with postfix returned by -userDefaultsKeyPostfix during initialization. Object's properties values will be unacrhived and restored to state what was saved earlier.
 *
 *  @return Singleton of concrete subclass loaded from user's defaults.
 *  @see -userDefaultsKeyPostfix
 */
+ (instancetype)sharedInstance;
/** Initializes object of concrete subclass by loading it from user's defaults with key with postfix returned by -userDefaultsKeyPostfix.
 *
 *  Object initialized by this method may be used to compare loaded values to current values of the singleton of same class.
 *
 *  @return Object
 *  @warning Object initialized by this method __will not__ update it's properties values automatically. It just contains a copy of what was in user's defaults.
 *  @see -userDefaultsKeyPostfix
 */
- (id)initWithDeveloperDefaults;

/** -----------------------------------------
 * @name Loading or saving values of properties
 */
/** Loads values of self's properties from copy of object of concrete class obtained from user's defaults.
 *
 * Obtains object of self's class from user's defaults with key with postfix returned by -userDefaultsKeyPostfix. Then obtained object will be unarchived and it's properties values deeply copied to called object.
 * When you obtain singleton via +sharedInstance for the first time this method is called automatically.
 *
 * @see +sharedInstance
 */
- (void)resetToUserDefaults;

/** Saves values of self's properties by storing self to user's defaults.
 *
 * Archives current object with all it's properties values, then stores to user's defaults under key with postfix returned by -userDefaultsKeyPostfix.
 */
- (void)synchronizeToUserDefaults;

/** -----------------------------------------
 * @name Overwrite object in user's defaults with developer defaults values
 */
/** Sets properties of called object to default values via -resetToDeveloperDefaults then reset object is saved to user's defaults via -synchronizeToUserDefaults.
 *
 * @see -resetToDeveloperDefaults
 * @see -synchronizeToUserDefaults
 */
- (void)resetSelfAndUserDefaultsToDeveloperDefaults;

/** -----------------------------------------
 * @name Object's key in user's defaults
 */
/** Returns object's key of concrete subclass in user's defaults dictionary.
 *
 *  @return Key string obtained by concatenation of common string and unique postfix returned from -userDefaultsKeyPostfix.
 *  @see -userDefaultsKeyPostfix
 */
- (NSString *)userDefaultsKey;

/** -----------------------------------------
 * @name Describing object
 */
/** Describes object
 *
 *  @return String with description of called object including list of properties with their values.
 */
- (NSString *)description;
@end
