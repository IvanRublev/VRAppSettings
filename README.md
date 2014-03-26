VRAppSettings
=============

This superclass makes it easier to handle the user's preferences (app's settings). It's intended to be used in iOS primarily.

A successor to this class keeps the app settings in properties and stores itself in the defaults system. Although the settings values will not be accessible through the [NSUserDefaults](https://developer.apple.com/library/ios/documentation/cocoa/reference/foundation/Classes/NSUserDefaults_Class) class directly, but only via the setters and getters of the `VRAppSettings` successor.

That gives common place for app's setting definition. The possibility to make range and consistency checks of the setting values in setters and getters. The refactoring tool can be used to change the setting's name across the project. 

Usage
-----

A `VRAppSettings` class is normally used as a singleton. Make your own successor to the  `VRAppSettings` class for example `MySettings`. Though, you'll be able to use inherited `+sharedInstance` and `-synchronizeToUserDefaults` methods. Describe all your app settings as properties of the `MySettings` class and override the compulsory methods. You'll get something like this:

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

Here how app settings can be saved now:

	[MySettings sharedInstance].dontDimScreen = YES;
	[MySettings sharedInstance].soundLevel = 0.85;
	[[MySettings sharedInstance] synchronizeToUserDefaults];

You __need__ to call the `-synchronizeToUserDefaults` manually every time when you want to write settings object to user defaults.

And that's how app settings can be loaded:

	BOOL dontDim = [MySettings sharedInstance].dontDimScreen;
	float soundLevel = [MySettings sharedInstance].soundLevel;

### Benefits

The benefits of keeping the app's settings in the defaults system via the VRAppSettings class:

* The settings are defined as properties of the primitive type or object type (conforming to the NSCoding protocol).
* No need to choose the appropriate `-setType:forKey:` or `-typeForKey:` methods, just write or read properties!
* Consistency and range checks of settings values in setters and getters!
* No misspelling of settings names anymore, compiler checks everything!
* The Xcode refactoring tool can be used to change the setting's name across the project.
* The possibility to reset all changes in the settings object to what is in the user defaults now.
* Several independent settings sets around the project.
* Settings sets accessibility either in the app or in the class scope.
* Storing the whole class in the user defaults protects the individual settings from any external change.

See definition of the class and _VRAppSettingsExample_ project that is included in the repository.

### Properties types

The properties of a successor class must be a primitive type or an object type, conforming to NSCoding protocol.

The properties with names which begins from `const` will be excluded from the save or load processes. In such excluded properties you can store the runtime values that are counted on in the kept properties.

Installation & Requirements
------------

1. This class requires several utilities from the  [VRFoundationToolkit](https://github.com/IvanRublev/VRFoundationToolkit) repository. Add it to your project following installation instructions from that repositorie's [README](https://github.com/IvanRublev/VRFoundationToolkit/blob/master/README.md) file.
2. Subtree the `VRAppSettings` repository in to the `Requirements` subdirectory of your project's directory via following command:
	
	```git subtree add --prefix=Requirements/VRAppSettings --squash https://github.com/IvanRublev/VRAppSettings.git master```
		
3. Drag & drop `VRAppSettings.h` and `VRAppSettings.m` files to your Xcode project.

And it's ready to use! 

### Documentation set for Xcode

If you have an [appledoc](https://github.com/tomaz/appledoc) installed in your system you can open the `VRAppSettingsExample` project and build the `Docset for Xcode` target. This will add description of the `VRAppSettings` class to your Xcode help system.

### ARC

This class requires ARC.

If you are going to use this class into a project that does not yet use [Automatic Reference Counting](http://clang.llvm.org/docs/AutomaticReferenceCounting.html), you will need to set the `-fobjc-arc` compiler flag on `NSObject+VRPropertiesProcessing.m` and `VRAppSettings.m` files under the "Compile Sources" section in the "Build Phases" tab of your project.

Licence
-------

MIT. Copyright (c) 2013 Ivan Rublev, ivan@ivanrublev.me 