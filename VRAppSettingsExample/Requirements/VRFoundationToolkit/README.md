VRFoundationToolkit
===================

This library contains custom classes, categories for extending [NSFoundation](https://developer.apple.com/library/ios/documentation/cocoa/reference/foundation/) and useful macros. It can be used in iOS or OS X projects for faster coding. Also this library is a base layer for several classes written by [@IvanRublev](https://github.com/IvanRublev?tab=repositories).

Supply
------

This repository already includes [libextobjc](libextobjc) (via subtree) as requirement for some of macros from `VRLog.h` and `VREnum.h` that are build on top. So when you clone this repo you're got libextobjc also.
That's gives all benefits of libextobjc like `@weakify`, `@strongify` directives to use with variables over blocks and many, many more. See [description](libextobjc) of that repo.  

Thanks a lot to [@jspahrsummers](https://github.com/jspahrsummers) and all contributors for such perfect [libextobjc](libextobjc) library.

Installation
------------

- Subtree this repository, for example to `Requirements` subdirectory in your project.
```
git subtree add --prefix=Requirements/VRFoundationToolkit --squash https://github.com/IvanRublev/VRFoundationToolkit.git master
```

- Add `-ObjC` to Other Linker Flags in project's Build Settings. And add `"./Requirements/**"` to Header Search Paths.
- Add `VRFoundationToolkit` target (or `VRFoundationToolkitOSX` for OS X) in "Target Dependencies" section of "Build phases" tab of your project's target.
- Link to `libVRFoundationToolkit.a` (or `libVRFoundationToolkitOSX.a` for OS X) in General tab of your project's target.
- Add `#import VRFoundationToolkit.h` to YourProject-Prefix.pch. 

Now it's ready to use!

Classes are included
--------------------
#### VRURLConnectionChecker

Class that checks if default site or specified URL is accessible with completion and error blocks.

	+ (void)checkURLWithRequest:(NSURLRequest *)request
	                 accessible:(VRURLConnectionCheckerAccessibleBlock)accessible
	                    failure:(VRURLConnectionCheckerFailureBlock)failure;
	
	...
	
	+ (void)checkDefaultSiteIsAccessible:(VRURLConnectionCheckerAccessibleBlock)accessible
	                             failure:(VRURLConnectionCheckerFailureBlock)failure;

Categories are included
-----------------------

#### NSFileManager+VRDocumentsDirectory

Returns Documents directory and Temporary directory for app. Removing items if exists only. Random file names generation.

	- (NSString*)temporaryDirectory;
	- (NSString*)documentsDirectory;
	- (NSString*)documentsDirectoryAddingPath:(NSString*)relativePath;
	- (BOOL)removeItemAtPathIfExists:(NSString *)path error:(NSError *__autoreleasing *)error;
	+ (NSString*)randomFileNameOfType:(NSString *)type;
	+ (NSString*)randomFileNameOfLength:(NSUInteger)length type:(NSString *)type;

#### NSDate+VRDurations

Calculates how much days, hours, minutes between two dates.

	-(NSInteger)daysUntilDate:(NSDate *)nextDate;
	-(NSInteger)hoursUntilDate:(NSDate *)nextDate;
	-(NSInteger)minutesUntilDate:(NSDate *)nextDate;
	-(NSDateComponents *)componentsWithUnits:(NSCalendarUnit)units untilDate:(NSDate *)nextDate;

#### NSString+VRmd5

MD5 hash on string.

	- (NSString*)md5;

#### NSObject+VRPropertiesProcessing

Processing of every property of any object via block. Hash, equality, NSCoding universal methods for any object. 

	- (void)enumeratePropertiesUsingBlock:(void (^)(NSString * propertyName, id propertyValue, __unsafe_unretained Class valuesClass))block;
	
	- (NSString *)descriptionWithProperties;
	- (NSString *)descriptionWithPropertiesTypes;
	
	- (BOOL)isEqualByProperties:(id)object; // If object is of different class then returns NO. It's faster then [-hashByProperties]
	- (NSUInteger)hashByProperties;
	
	- (id)deepCopyPropertiesToNewInstanceWithZone:(NSZone *)zone;
	- (void)deepCopyPropertiesTo:(id)targetObject;
	
	- (NSString *)keyForPropertyName:(NSString *)propertyName;
	- (void)encodePropertiesWithCoder:(NSCoder *)aCoder; // For fast implementing of NSCoding protocol in subclass of NSObject.
	- (id)initPropertiesWithCoder:(NSCoder *)aDecoder;

#### NSArray+VRCheckMembers

Checks if all members of array of specified class.

	- (BOOL)allMembersAreKindOfClass:(Class)oneTestClass orClass:(Class)otherTestClass;
	- (BOOL)allMembersAreKindOfClass:(Class)oneTestClass orClass:(Class)otherTestClass options:(NSEnumerationOptions)options;
	- (BOOL)allMembersAreKindOfClass:(Class)testClass;
	- (BOOL)allMembersAreKindOfClass:(Class)testClass options:(NSEnumerationOptions)options;


#### NSMutableDictionary+VRExchangeKeys

Exchanges keys in dictionary.

	- (void)exchangeKey:(id<NSCopying, NSObject>)aKey withKey:(id<NSCopying, NSObject>)aNewKey;

#### NSBundle+VRDisplayName.h

To obtain localized display name of bundle with fallback to non-nil string if name is not accessible.

	+ (NSString *)localizedDisplayName;

To make fallback work, please, add `kPRODUCT_NAME="@\"$(PRODUCT_NAME)\""` to preprocessor macros section of your project to both `Debug` and `Relese` configurations.

Macros are included
-------------------

### VRLog.h

#### Logging & assertion macros

	VRLOG_xxx(...)

If KSCrashLib is in project, then maps to KSLOG_xxx macros automaticaly.

Also contains `VRLOG_ERROR_ASSERT_xxxx` macros that asserts just after logging error with same message.

#### Just assertion

	VRASSERT(CONDITION)

Asserts when condition is false.
	
#### Precondition checking

	VRPRECONDITIONS_LOG_ERROR_ASSERT_RETURN(...)

Asserts when one of passed condition's is false, inclides that condition in assertion message.

### VREnum.h

#### Definition of enums types and utilities for them

	VRENUM_TYPEDEF_AND_UTILS(tdeName, intType, const1, const2, ...)

Generates `enum` with specified `tdeName` for `typedef`, `intType` for integer type and provided constants.

Generates following inline functions:

* `BOOL isValidNAME(intType value)` returns YES if specified value matches one of defined enum constants
	  
* `NSStringFromNAME(intType value)` returns string representation of value if it belongs to enum or `@"undefined (value)"`.

Constants can be only simple text CONSTA, CONSTB etc. Up to 18. 
Arbitrary number assignments to constants is not supported. Preprocessor doesn't support regexps :(((

`VRENUM_TYPEDEF(tdeName, intType, ...)` same macro but without utility functions.

### NSCoder+VRKeyName.h

#### Unifyed Key names
	
	VRKeyName(...)

Creates key name for `-[NSCoder encodeObject:withKey:]`.

You pass not string but language expression that will be stringifyed. Usefull to cheating with code completion feature in Xcode.

### VRSingleton.h

#### One string singleton

	VRRETURN_SINGLETON

To be used for realization of `+sharedInstance` class method. Returns singleton of current class as reccomended by Apple.

### VRProtocolConformation.h

#### Check if object can perform selector an conforms to protocol simultaneously

	BOOL VRCanPerform(id object, SEL selector, Protocol *protocol);

Returns YES if `object` responses to `selector` and conforms to `protocol` are passed.

Also inclides macro `VRPerformSelectorUnderProtocolIfPossible(aObject, aSelector, aProtocol)` that will send message to given object with specified selector without parameters if `VRCanPerform` function returns YES. 

License
-------

MIT. Copyright (c) 2013 Ivan Rublev, ivan@ivanrublev.me 

[libexcobjc]:https://github.com/jspahrsummers/libextobjc.git