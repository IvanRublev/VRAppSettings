VRAppSettings
=============

This superclass makes easier to handle user's preferences (app's settings). It's intended to be used in iOS primarily.

Successor of this class keeps app's settings in properties and stores itself in defaults system. Though settings values will not be accessible through [NSUserDefaults](https://developer.apple.com/library/ios/documentation/cocoa/reference/foundation/Classes/NSUserDefaults_Class) directly but only via setters and getters of `VRAppSettings` successor.

That gives common place of app's settings definition. Possibility to make range and consistency checks of properties values in setters and getters. Refactoring of properties names across the project via IDE. 

Usage
-----

`VRAppSettings` successor normally is to be used as singleton. Inherit from it with your own settings class, for example `MySettings`. You'll receive `+sharedInstance` class method automatically. Describe all your app's settings as properties of `MySettings` class and override compulsory methods. You'll get something like this:

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

Here how app's settings can be saved now:

	[MySettings sharedInstance].dontDimScreen = YES;
    [MySettings sharedInstance].soundLevel = 0.85;
    [[MySettings sharedInstance] synchronizeToUserDefaults];

You __need__ to call `-synchronizeToUserDefaults` manually every time when want to write settings object to user's defaults.

And that's how settings can be loaded:

    BOOL dontDim = [MySettings sharedInstance].dontDimScreen;
    float soundLevel = [MySettings sharedInstance].soundLevel;

### Benefits

When you manage app's settings with `VRAppSettings` class you receive following benefits:

* Settings are defined as properties of primitive type or object type (conforming to NSCoding protocol).
* No need to choose appropriate `-setType:forKey:` or `-typeForKey:` methods, just write or read properties!
* Consistency and range checks of settings values in setters and getters!
* No misspelling with settings names anymore, compiler checks everything!
* Xcode refactoring tool can be used to change setting's name across the project.
* Possibility to reset all changes in settings object to what is in user's defaults now.
* Several independent settings sets around the project.
* Settings set accessibility either in app or in class scope.
* Storing whole class in user's defaults protects individual settings from external change.

See definition of class and _VRAppSettingsExample_ project included in repository.

### Properties types

Properties of successor class must be of primitive type or of object type conforming to NSCoding protocol.

Properties with names which begins from const* will be excluded from save or load processes. In such excluded properties you can store runtime values that are counted on kept properties.

Installation & Requirements
------------

1. This class requires several utilities from [VRFoundationToolkit](https://github.com/IvanRublev/VRFoundationToolkit) repository. Add it to your project, following installation instructions from that repositorie's [README](https://github.com/IvanRublev/VRFoundationToolkit/blob/master/README.md) file.
2. Subtree this repository to `Requirements` directory in your project's directory via following command:
	
	```git subtree add --prefix=Requirements/VRAppSettings --squash https://github.com/IvanRublev/VRAppSettings.git master```
		
3. Drag & drop `VRAppSettings.h` and `VRAppSettings.m` files to your Xcode project.

And it's ready to use! 

### Documentation set for Xcode

If you have [appledoc](https://github.com/tomaz/appledoc) installed in your system you can open `VRAppSettingsExample` project and build `Docset for Xcode` target. This will add description of `VRAppSettings` class to your Xcode help system.

### ARC

This class requires ARC.

If you are going to use this class into a project that does not yet use [Automatic Reference Counting](http://clang.llvm.org/docs/AutomaticReferenceCounting.html), you will need to set the `-fobjc-arc` compiler flag on `NSObject+VRPropertiesProcessing.m` and `VRAppSettings.m` files under "Compile Sources" section in "Build Phases" tab of your project.

Licence
-------

MIT. Copyright (c) 2013 Ivan Rublev, ivan@ivanrublev.me 