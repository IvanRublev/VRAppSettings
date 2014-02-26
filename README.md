VRAppSettings
=============

Base class for saving app's settings in system user defaults. 

Usage
-----

Make your successor class and it will inherit as self-serializable singleton.

### Save

Add properties you want to keep. After call ```[[YourSuccessorClass sharedInstance] synchronizeToUserDefaults]``` your object will be automatically serialized to system user defaults.

### Load

Call `[YourSuccessorClass sharedInstance]` and previously saved settings will be loaded from system user defaults and automatically mapped to properties of YourSuccessorClass.

_Example is included_.

Licence
-------

MIT. Copyright (c) 2013 Ivan Rublev, ivan@ivanrublev.me 