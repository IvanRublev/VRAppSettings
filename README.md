VRFoundationToolkit
===================

Several categories extending NSFoundation classes, and macros. For faster coding.

Installation
------------

- Subtree this repository somewhere in your project.
```
git subtree add --prefix=Somewhere/VRFoundationToolkit --squash https://github.com/IvanRublev/VRFoundationToolkit.git master
```

- Add `-ObjC` to Other Linker Flags in project's Build Settings. And add `"./Somewhere/**"` to Header Search Paths.
- Add VRFoundationToolkit target to Target Dependencies in Build phases of your project's target.
- Link to libVRFoundationToolkit.a in General tab of your project's target.
- Add `#import VRFoundationToolkit.h` to YourProject-Prefix.pch. 

Now it's ready to use!

Categories are included
-----------------------

#### NSFileManager+VRDocumentsDirectory

Documents and temporary directory for app.

#### NSDate+VRDurations

Calculates how much days, hours, minutes between two dates.

#### NSString+VRmd5

MD5 hash on string.

#### NSObject+VRProtocolsConformation

To check if object conforms to protocol and realize specified method.

#### NSObject+VRPropertiesProcessing

Hash, equality, NSCoding universal methods for any object. Also one can process every property of object via block. 

#### NSArray+VRCheckMembers

Checks if all members of array of specified class.

#### NSMutableDictionary+VRExchangeKeys

Exchanges keys in dictionary.

Macros are included
-------------------

#### VRLOG_xxx

For logging. If KSCrashLib is in project, then maps to KSLOG_xxx macros automaticaly.

#### VRKeyName

For creating key name for [aCoder encodeObject: withKey: ]

#### VRRETURN_SINGLETON

Returns singleton.

License
-------

MIT. Copyright (c) 2013 Ivan Rublev, ivan@ivanrublev.me 
