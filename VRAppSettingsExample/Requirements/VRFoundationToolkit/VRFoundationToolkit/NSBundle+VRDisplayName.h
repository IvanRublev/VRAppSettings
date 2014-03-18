//
//  NSBundle+VRDisplayName.h
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 3/3/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import <Foundation/Foundation.h>

/* VRAppLocalizedDisplayName macro returns app localized display name with 
 * fallback to target's name. For case when value for key CFBundleDisplayName
 * returns nil.
 *
 * To make fallback work please add kPRODUCT_NAME="@\"$(PRODUCT_NAME)\"" to
 * preprocessor macros section of your project to both Debug and Relese configurations.
 */
#ifndef VRAppLocalizedDisplayName
#ifdef kPRODUCT_NAME
#define VRAppLocalizedDisplayName ([[NSBundle localizedDisplayName] length] ? [NSBundle localizedDisplayName] : kPRODUCT_NAME)
#else
#define VRAppLocalizedDisplayName [NSBundle localizedDisplayName]
#endif
#endif

@interface NSBundle (VRDisplayName)

+ (NSString *)localizedDisplayName;

@end
