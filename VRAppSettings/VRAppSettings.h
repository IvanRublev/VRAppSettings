//
//  VRAppSettings.h
//
//  Created by Ivan Rublev on 1/24/13.
//  Copyright (c) 2013 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import <Foundation/Foundation.h>

/** This superclass makes it easier to handle the user’s preferences (app’s settings). A successor to this class keeps the app settings in properties and stores itself in the defaults system. Although the settings values will not be accessible through the  [NSUserDefaults](https://developer.apple.com/library/ios/documentation/cocoa/reference/foundation/Classes/NSUserDefaults_Class) directly, but only via the setters and getters of the `VRAppSettings` successor. This class is normally used as a singleton.

 To use `VRAppSettings` class do the following: make your own successor to the `VRAppSettings` class for example `MySettings`. Describe all your app settings as properties of the `MySettings` class and override the compulsory methods.  You'll get something like this:
 
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
 
 
 This class exports two inherited methods to work with. They are -synchronizeToUserDefaults and +sharedInstance.
 
 When the message with the -synchronizeToUserDefaults method is sent to the `MySettings` object it will be archived with all its properties according to the NSCoding protocol and saved in the user defaults as a value.
 
 The +sharedInstance class method will return a singleton of the `MySettings` class. During initialization of the singleton `-resetToDeveloperDefaults` method will be called. Then, if the object is saved in the user defaults it will be unarchived and will replace the current one. After that the `-checkAfterInitWithCoder` method will be called.
 
 ### Properties types
 The properties of a successor class must be a primitive type or an object type, conforming to NSCoding protocol.
 
 The properties with names which begin from `const` will be excluded from the save or load processes. For example the following property will not be processed:
 
    @property (nonatomic, readwrite) NSValue * constMyCountedValue;
 
 In such excluded properties you can store the runtime values that are counted on in the kept properties.
 
 ### Subclassing notes
 Use full power of setters and getters in the successor class to make range checks and keep consistency of the settings values.
 
 If you need to keep several sets of settings you can make several successors of the `VRAppSettings` class and return different strings from the `-userDefaultsKeyPostfix` method to separate settings sets.
*/
@interface VRAppSettings : NSObject

/** -----------------------------------------
 *  @name Methods that are compulsory to override in subclass
 */
/** Returns the postfix for the key in the user defaults dictionary at which the object of a concrete subclass will be stored.
*
*  A concrete subclass must overload this method and return the nonempty `NSString` key postfix value that is unique among other subclasses. Usually, it's the name of the concrete subclass. The key to store the settings object in the user defaults dictionary will be obtained by a linking of common string and a returned unique postfix. The full key string may be obtained via -userDefaultsKey.
*
*  @return Nonempty string with a postfix for the key name that is unique among all subclasses.
*  @see -userDefaultsKey
*/
- (NSString *)userDefaultsKeyPostfix;

/** Resets the properties values to the defaults hardcoded by the developer.
 *
 *  A concrete subclass must overload this method to specify the defaults for its properties.
 */
- (void)resetToDeveloperDefaults;

/** Checks the values of the properties of the concrete subclass object after loading it from the user defaults.
 *
 *  The concrete subclass must overload this method. This method may be empty if a check is not needed.
 */
- (void)checkAfterInitWithCoder;

/** -----------------------------------------
 * @name Creating the singleton or object initialization
 */
/** Returns a singleton of a concrete subclass loaded from the user defaults using a key with postfix, returned by -userDefaultsKeyPostfix.
 *
 *  The concrete subclass object will be loaded from the user defaults using a key with postfix, returned by -userDefaultsKeyPostfix during initialization. The object's properties values will be unacrhived and restored to the state that was saved earlier.
 *
 *  @return A singleton of a concrete subclass loaded from the user defaults.
 *  @see -userDefaultsKeyPostfix
 */
+ (instancetype)sharedInstance;
/** Initializes the object of the concrete subclass by loading it from the user defaults using a key with postfix, returned by -userDefaultsKeyPostfix.
 *
 *  Object initialized by this method may be used to compare the loaded values to the current values of the singleton of the same class.
 *
 *  @return Object
 *  @warning The object initialized by this method __will not__ update it's properties values automatically. It just contains a copy of what was in the user defaults.
 *  @see -userDefaultsKeyPostfix
 */
- (id)initWithDeveloperDefaults;

/** -----------------------------------------
 * @name Loading or saving values of properties
 */
/** Loads the values of the self-properties from a copy of the object of a concrete class obtained from the user defaults.
 *
 * Obtains the object of the self-class from the user defaults using a key with postfix, returned by -userDefaultsKeyPostfix. Then, the obtained object will be unarchived and its properties values deeply copied to the called object.
 * When you obtain a singleton via +sharedInstance for the first time this method is automatically called.
 *
 * @see +sharedInstance
 */
- (void)resetToUserDefaults;

/** Saves the values of the self-properties by storing the self to the user defaults.
 *
 * Archives current object with all its properties values, then stores them to the user defaults under a key with postfix, returned by -userDefaultsKeyPostfix.
 */
- (void)synchronizeToUserDefaults;

/** -----------------------------------------
 * @name Overwrite object in user's defaults with developer defaults values
 */
/** Sets the properties of the called object to its default values via -resetToDeveloperDefaults, then, it resets the object that is saved to the user defaults via -synchronizeToUserDefaults.
 *
 * @see -resetToDeveloperDefaults
 * @see -synchronizeToUserDefaults
 */
- (void)resetSelfAndUserDefaultsToDeveloperDefaults;

/** -----------------------------------------
 * @name Object's key in user's defaults
 */
/** Returns the object's key of a concrete subclass in the user defaults dictionary.
 *
 *  @return The key string obtained by linking up a common string and a unique postfix, returned from -userDefaultsKeyPostfix.
 *  @see -userDefaultsKeyPostfix
 */
- (NSString *)userDefaultsKey;

/** -----------------------------------------
 * @name Describing object
 */
/** Describes object
 *
 *  @return String with a description of the object called, including a list of the properties with their values.
 */
- (NSString *)description;
@end
