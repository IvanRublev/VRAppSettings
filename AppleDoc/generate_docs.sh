#!/bin/sh

APPLEDOC_PATH=$(whereis appledoc)
if [ -f $APPLEDOC_PATH ]; then
  echo "Appledoc is found at $APPLEDOC_PATH"
    $APPLEDOC_PATH ./AppledocSettings.plist ../VRAppSettings
fi