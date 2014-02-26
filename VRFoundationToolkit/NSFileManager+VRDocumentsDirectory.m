//
//  NSFileManager+VRDocumentsDirectory.m
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 8/2/12.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import "NSFileManager+VRDocumentsDirectory.h"

@implementation NSFileManager (VRDocumentsDirectory)

- (NSString *)temporaryDirectory
{
    NSString * temporaryDirectory = nil;
    NSArray * tmpDirs = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    if ([tmpDirs count] > 0) {
        temporaryDirectory = [tmpDirs lastObject];
    }
    return temporaryDirectory;
}

- (NSString*)documentsDirectory
{
    NSString* documentsDirectory = nil;
    NSArray * docDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([docDirs count] > 0) {
        documentsDirectory = [docDirs lastObject];
    }
    return documentsDirectory;
}

- (NSString *)documentsDirectoryAddingPath:(NSString*)relativePath
{
    return [[self documentsDirectory] stringByAppendingPathComponent:relativePath];
}

- (BOOL)removeItemAtPathIfExists:(NSString *)path error:(NSError *__autoreleasing *)error
{
    if ([self fileExistsAtPath:path]) {
        return [self removeItemAtPath:path error:error];
    }
    return YES;
}

+ (NSString *)randomFileNameOfType:(NSString *)type
{
    return [[self class] randomFileNameOfLength:NAME_MAX type:type];
}

+ (NSString *)randomFileNameOfLength:(NSUInteger)length type:(NSString *)type
{
    if (length < 3) length = 3;
    NSString * uniqueString = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString * resultFileName = length < [uniqueString length] ? [uniqueString substringToIndex:length] : uniqueString;
    return [resultFileName stringByAppendingPathExtension:type];
}

@end
