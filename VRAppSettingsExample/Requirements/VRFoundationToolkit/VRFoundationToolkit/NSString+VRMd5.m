//
//  NSString+VRmd5.m
//  VRFoundationToolkit
//
//  Included in kit by Ivan Rublev on 12/4/12.
//  Copyright (c) 2012 Karl Stenerud. All rights reserved.
//

#import "NSString+VRMd5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (VRMd5)

- (NSString *)md5
{
    NSString * text = self;
    if (!text) {
        return nil;
    }
    
    // Create pointer to the string as UTF8
    const char *ptr = [text UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

@end
